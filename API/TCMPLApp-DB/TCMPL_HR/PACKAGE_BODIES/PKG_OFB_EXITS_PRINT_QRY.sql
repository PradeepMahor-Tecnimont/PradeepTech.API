create or replace package body tcmpl_hr.pkg_ofb_exits_print_qry as

    procedure sp_emp_details (
        p_person_id    varchar2,
        p_meta_id      varchar2,
        p_empno        varchar2,
        p_message_type out varchar2,
        p_message_text out varchar2
    ) as
        v_empno  varchar2(5);
        v_exists number;
    begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        if v_empno = 'ERRRR' then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            return;
        end if;

      /*  select count(*)
          into v_exists
          from ofb_rollback
         where empno = p_empno and status = 0;
      */
        if v_exists = 0 then
            p_message_type := not_ok;
            p_message_text := 'Error - record not exists..';
            return;
        end if;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    exception
        when others then
            p_message_type := not_ok;
            p_message_text := sqlcode
                              || ' - '
                              || sqlerrm;
    end sp_emp_details;

    procedure sp_emp_exit_details (
        p_person_id               varchar2,
        p_meta_id                 varchar2,

        p_empno                   varchar2,

        p_emp_person_id                out varchar2,
        p_employee_name           out varchar2,
        p_grade                   out varchar2,
        p_parent                  out varchar2,
        p_dept_name               out varchar2,
        p_end_by_date             out date,
        p_relieving_date          out date,
        p_resignation_date        out date,
        p_doj                     out date,
        p_initiator_remarks       out varchar2,
        p_address                 out varchar2,
        p_mobile_primary          out varchar2,
        p_alternate_number        out varchar2,
        p_email_id                out varchar2,
        p_created_by              out varchar2,
        p_created_on              out date,
        p_modified_by             out varchar2,
        p_modified_on             out date,
        /*p_approval_status         out varchar2,
        p_first_approval_status   out varchar2,
        p_overall_approval_status out varchar2,
        p_hr_manager_can_approve  out varchar2,
        */
        p_message_type            out varchar2,
        p_message_text            out varchar2
    ) as
        v_empno  varchar2(5);
        v_exists number;
    begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        if v_empno = 'ERRRR' then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            return;
        end if;


        select count(*)
          into v_exists
          from tcmpl_hr.ofb_vu_emp_exits
         where empno = p_empno;

        if v_exists = 0 then
            p_message_type := not_ok;
            p_message_text := 'Error - record not exists..';
            return;
        end if;

        select personid as p_personid,
               employee_name,
               grade,
               parent,
               dept_name,
               end_by_date,
               relieving_date,
               resignation_date,
               doj, --dol,
               initiator_remarks,
               address,
               mobile_primary,
               alternate_number,
               email_id,
               created_by,
               created_on,
               modified_by,
               modified_on
          into
            p_emp_person_id,
            p_employee_name,
            p_grade,
            p_parent,
            p_dept_name,
            p_end_by_date,
            p_relieving_date,
            p_resignation_date,
            p_doj, --p_dol,
            p_initiator_remarks,
            p_address,
            p_mobile_primary,
            p_alternate_number,
            p_email_id,
            p_created_by,
            p_created_on,
            p_modified_by,
            p_modified_on

          from tcmpl_hr.ofb_vu_emp_exits
         where empno = p_empno;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    exception
        when others then
            p_message_type := not_ok;
            p_message_text := sqlcode
                              || ' - '
                              || sqlerrm;
    end sp_emp_exit_details;

    function fn_deptmnt_exit_approvals_list (
        p_person_id      varchar2,
        p_meta_id        varchar2,
        p_empno          varchar2,
        p_generic_search varchar2 default null
    ) return sys_refcursor as
        c       sys_refcursor;
        v_empno varchar2(5);
        e_employee_not_found exception;
        pragma exception_init ( e_employee_not_found, -20001 );
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        if v_empno = 'ERRRR' then
            raise e_employee_not_found;
            return null;
        end if;
        open c for select empno,
                          emp_name,
                          action_id,
                          action_desc,
                          role_id,
                          remarks,
                          is_approved,
                          is_approved_desc,
                          approval_date,
                          approved_by,
                          nvl(
                                  approver_name,
                                  tcmpl_hr.ofb_user.get_emp_name_csv_for_action_id(action_id)
                              ) approver_name,
                          group_desc group_name,
                          lag(group_desc,
                                  1,
                                  '-')
                          over(
                                   order by sort_order
                          ) as prev_group_name
                                from tcmpl_hr.ofb_vu_emp_exit_approvals
                    where empno = p_empno;
        return c;
    end fn_deptmnt_exit_approvals_list;

    Function fn_exit_pending_xl(
        p_person_id        Varchar2,
        p_meta_id          Varchar2
    ) Return sys_refcursor As
        c       sys_refcursor;
        v_empno varchar2(5);
        e_employee_not_found exception;
        pragma exception_init ( e_employee_not_found, -20001 );
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        Open c For
            Select
                oeea.empno,
                ove.name    employee_name,
                oeea.empno || ' - ' || ove.name empno_name,
                ove.emptype,
                ove.parent,
                ovc.name    department_name,
                ove.parent || ' - ' || ovc.name dept_name,
                ove.grade,
                oee.relieving_date,
                'Pending' as approval_status,
                oee.remarks initiator_remarks,
                oatd.action_desc,
                oeea.approval_date,
                oeea.tm_key_id,
                oatm.template_desc,
                oeea.tg_key_id,
                To_Char(oee.relieving_date, 'DD-Mon-YYYY') as relieving_date_string,
                To_Char(oeea.approval_date, 'DD-Mon-YYYY') as approval_date_string
              From
                ofb_emp_exits              oee,
                ofb_emp_exit_approvals     oeea,
                ofb_apprl_template_master  oatm,
                ofb_apprl_template_details oatd,
                ofb_vu_emplmast            ove,
                ofb_vu_costmast            ovc
             Where
                    oeea.empno = oee.empno
                   And oatd.tm_key_id       = oeea.tm_key_id
                   And oatm.tm_key_id       = oatd.tm_key_id
                   And oatd.tg_key_id       = oeea.tg_key_id
                   And oatd.apprl_action_id = oeea.apprl_action_id
                   And oeea.empno           = ove.empno
                   And ovc.costcode         = ove.parent
                   And ove.status           = 1
                   And oeea.empno In (
                    Select
                        oeea_1.empno
                      From
                        ofb_emp_exit_approvals oeea_1
                     Where
                        nvl(
                            oeea_1.is_approved,
                            'KO'
                        ) = 'KO'
                )
             Order By
                oeea.empno,
                tg_key_id,
                approval_date;
                    
        Return c;
                    
    End;

    Function fn_exit_approved_xl(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        
        p_start_year     Varchar2,
        p_end_year       Varchar2
    ) Return sys_refcursor As
        c       sys_refcursor;
        v_empno varchar2(5);
        e_employee_not_found exception;
        pragma exception_init ( e_employee_not_found, -20001 );
        v_start_year         Date;
        v_end_year           Date;
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        Select
            To_Date('01-01-' || p_start_year, 'dd-mm-YYYY') start_year,
            To_Date('31-12-' || p_end_year, 'dd-mm-YYYY')
        Into
            v_start_year,
            v_end_year
        From
            dual;
        
        Open c For
            Select
                oeea.empno,
                ove.name    employee_name,
                oeea.empno || ' - ' || ove.name empno_name,
                ove.emptype,
                ove.parent,
                ovc.name    department_name,
                ove.parent || ' - ' || ovc.name dept_name,
                ove.grade,
                oee.relieving_date,
                'Approved' as approval_status,
                oee.remarks initiator_remarks,
                oatd.action_desc,
                oeea.approval_date,
                oeea.tm_key_id,
                oatm.template_desc,
                oeea.tg_key_id,
                To_Char(oee.relieving_date, 'DD-Mon-YYYY') as relieving_date_string,
                To_Char(oeea.approval_date, 'DD-Mon-YYYY') as approval_date_string
              From
                ofb_emp_exits              oee,
                ofb_emp_exit_approvals     oeea,
                ofb_apprl_template_master  oatm,
                ofb_apprl_template_details oatd,
                ofb_vu_emplmast            ove,
                ofb_vu_costmast            ovc
             Where
                    oeea.empno = oee.empno
                   And oatd.tm_key_id       = oeea.tm_key_id
                   And oatm.tm_key_id       = oatd.tm_key_id
                   And oatd.tg_key_id       = oeea.tg_key_id
                   And oatd.apprl_action_id = oeea.apprl_action_id
                   And oeea.empno           = ove.empno
                   And ovc.costcode         = ove.parent
                   And ove.status           = 1
                   And (oee.relieving_date >= v_start_year And oee.relieving_date <= v_end_year)
                   And oeea.empno In (
                    Select
                        oeea_1.empno
                      From
                        ofb_emp_exit_approvals oeea_1
                     Where
                        nvl(
                            oeea_1.is_approved,
                            not_ok
                        ) = ok
                )
             Order By
                oeea.empno,
                tg_key_id,
                approval_date;
                    
        Return c;
                    
    End;


end pkg_ofb_exits_print_qry;