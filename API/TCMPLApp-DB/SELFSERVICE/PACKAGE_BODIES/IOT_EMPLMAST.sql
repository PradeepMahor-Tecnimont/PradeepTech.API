--------------------------------------------------------
--  DDL for Package Body IOT_EMPLMAST
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."IOT_EMPLMAST" As

    Procedure employee_list_dept(p_dept             Varchar2,
                                 p_out_emp_list Out Sys_Refcursor) As
    Begin

        Open p_out_emp_list For
            Select
                empno, name, parent, assign
            From
                ss_emplmast
            Where
                status     = 1
                And parent = p_dept;
    End employee_list_dept;

    Procedure employee_details(
        p_empno        Varchar2,
        p_name     Out Varchar2,
        p_parent   Out Varchar2,
        p_metaid   Out Varchar2,
        p_personid Out Varchar2,
        p_success  Out Varchar2,
        p_message  Out Varchar2
    ) As
    Begin
        Select
            name, parent, metaid, personid
        Into
            p_name, p_parent, p_metaid, p_personid
        From
            ss_emplmast
        Where
            empno = p_empno;
        p_success := 'OK';
        p_message := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End employee_details;

    Procedure employee_details_ref_cur(
        p_empno               Varchar2,
        p_out_emp_details Out Sys_Refcursor) As
    Begin
        Open p_out_emp_details For
            Select
                name, parent, metaid, personid
            From
                ss_emplmast
            Where
                empno = p_empno;
    End;
    /*
        Function fn_employee_details_ref(p_empno         Varchar2,
                                         p_rownum In Out Number) Return Sys_Refcursor
        As
            c Sys_Refcursor;
        Begin
            Open c For
                Select
                    name, parent, metaid, personid, p_rownum
                From
                    ss_emplmast
                Where
                    empno = p_empno;
            p_rownum := -1;
            Return c;
        End;
    */
    Function fn_employee_details(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null
    ) Return Sys_Refcursor
    As
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_empno              Varchar2(5);
    Begin

        If p_empno Is Not Null Then
            v_empno := p_empno;
        Else
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;

        End If;
        Open c For
            /* Select
                 empno, name, parent, metaid, personid
             From
                 ss_emplmast
             Where
                 empno = v_empno;
        */

            Select
                a.empno,
                a.name,
                a.metaid,
                a.personid,
                a.grade                                                           As emp_grade,
                a.email                                                           As emp_email,
                a.emptype,
                iot_swp_common.get_emp_work_area(p_person_id, p_meta_id, a.empno) As work_area,
                a.parent                                                          As parent_code,
                a.assign                                                          As assign_code,
                (
                    Select
                    Distinct c.name
                    From
                        ss_costmast c
                    Where
                        c.costcode = a.parent
                )                                                                 As parent_desc,
                (
                    Select
                    Distinct c.name
                    From
                        ss_costmast c
                    Where
                        c.costcode = a.assign
                )                                                                 As assign_desc
            From
                ss_emplmast a
            Where
                empno = v_empno;
        Return c;
    End;

    Function fn_employee_list_ref(p_dept Varchar2) Return Sys_Refcursor
    As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                empno, name, parent, metaid, personid
            From
                ss_emplmast
            Where
                status = 1;
        --parent     = p_dept
        --And status = 1;
        --p_rownum := -1;
        Return c;
    End;
End iot_emplmast;
/

Grant Execute On "SELFSERVICE"."IOT_EMPLMAST" To "TCMPL_APP_CONFIG";
Grant Execute On "SELFSERVICE"."IOT_EMPLMAST" To "IOT_TCMPL";