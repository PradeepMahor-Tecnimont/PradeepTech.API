Create Or Replace Package Body "TIMECURR"."IOT_JOBS_SELECT_LIST_QRY" As
 
    Function fn_phases_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                phase                         data_value_field,
                phase || ' - ' || description data_text_field
            From
                job_phases
            Where
                Trim(inuse)   = 'Y'
                And timesheet = 1
            Order By
                phase;
        Return c;
    End fn_phases_list;

    Function fn_tmagroup_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                tmagroup                          data_value_field,
                tmagroup || ' - ' || tmagroupdesc data_text_field
            From
                job_tmagroup
            Order By
                tmagroup;
        Return c;
    End fn_tmagroup_list;

    Function fn_country_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                country_code                          data_value_field,
                country_code || ' - ' || country_name data_text_field
            From
                country_master
            Order By
                country_name;
        Return c;
    End fn_country_list;

    Function fn_state_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                loc                  data_value_field,
                loc || ' - ' || name data_text_field
            From
                job_loc
            Order By
                name;
        Return c;
    End fn_state_list;

    Function fn_scope_of_work_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                code                         data_value_field,
                short_description || ' - ' || description data_text_field
            From
                scope_of_work
            Order By
                description;
        Return c;
    End fn_scope_of_work_list;

    Function fn_business_line_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                code                         data_value_field,
                short_description || ' - ' || description data_text_field
            From
                business_line
            Order By
                short_description;
        Return c;
    End fn_business_line_list;

    Function fn_sub_business_line_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                code                         data_value_field,
                short_description || ' - ' || description data_text_field
            From
                sub_business_line
            Order By
                short_description;
        Return c;
    End fn_sub_business_line_list;

    Function fn_segment_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                code                         data_value_field,
                code || ' - ' || description data_text_field
            From
                segment
            Order By
                description;
        Return c;
    End fn_segment_list;

    Function fn_plant_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                code                         data_value_field,
                short_description || ' - ' || description data_text_field
            From
                plant_type
            Order By
                short_description;
        Return c;
    End fn_plant_type_list;

    Function fn_project_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
               code                         data_value_field,
                short_description || ' - ' || description data_text_field
            From
                job_projtype
            Order By
                description;
        Return c;
    End fn_project_type_list;


    Function fn_job_responsible_edit_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_projno                  Varchar2,
        p_job_responsible_role_id Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                empno                  data_value_field,
                empno || ' - ' || name data_text_field
            From
                emplmast
            Where
                status = 1

            Union

            Select
                e.empno                    data_value_field,
                e.empno || ' - ' || e.name data_text_field
            From
                emplmast                          e, job_responsible_roles jrr
            Where
                e.empno                         = jrr.empno
                And jrr.job_responsible_role_id = Trim(p_job_responsible_role_id)
                And jrr.projno5                 = Trim(p_projno)

            Order By
                1;
        Return c;
    End fn_job_responsible_edit_list;    

    Function fn_mail_list_costcodes(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                costcode                  As data_value_field,
                costcode || ' - ' || name As data_text_field
            From
                costmast
            Where
                costcode In (
                    Select
                        costcode
                    From
                        job_tmagroup_mail_map
                );
        Return c;
    End fn_mail_list_costcodes;
    
    function fn_co_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                code                         data_value_field,
                code || ' - ' || description data_text_field
            From
                job_co_master
            Order By
                description;
        Return c;
    end fn_co_list;
    
    Function fn_invoicing_grp_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                code                          data_value_field,
                code || ' - ' || description  data_text_field
            From
                invoicing_grp_company
            Order By
                description;
        Return c;
    End fn_invoicing_grp_list;
    
    Function fn_contract_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                contract_type                       data_value_field,
                contract_type || ' - ' || descr     data_text_field
            From
                job_contract
            Order By
                descr;
        Return c;
    End fn_contract_type_list;

    Function fn_4_on_behalf_principal_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
    v_empno := get_empno_from_meta_id(p_meta_id);

    If v_empno = 'ERRRR' Then
        Return Null;
    End If;

    Open c For
        Select Distinct 
            e.empno                    data_value_field,
            e.empno || ' - ' || e.name data_text_field
        From
            emplmast              e, 
            vu_job_form_delegate  jfd, 
            job_responsible_roles jrr
        Where
            e.empno                         = jfd.principal_empno
            And jrr.empno                   = e.empno
            And jrr.job_responsible_role_id = c_r01
            And jfd.on_behalf_empno         = Trim(v_empno)

        Union All

        Select Distinct 
            e.empno                    data_value_field,
            e.empno || ' - ' || e.name data_text_field
        From
            emplmast                       e, 
            vu_job_form_delegate           jfd, 
            job_responsible_roles          jrr, 
            job_responsible_roles_defaults jrrd
        Where
            e.empno                 = jfd.principal_empno
            And jrr.empno           = e.empno
            And jrr.job_responsible_role_id Not In (c_r01, c_r02)
            And jrrd.empno != jfd.principal_empno
            And jfd.on_behalf_empno = Trim(v_empno)

        Order By
            1;
    Return c;
    End fn_4_on_behalf_principal_list;
    
    Function fn_client_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
    v_empno := get_empno_from_meta_id(p_meta_id);

    If v_empno = 'ERRRR' Then
        Return Null;
    End If;

    Open c For
        Select        
            client data_value_field,
            name   data_text_field
        From
            clntmast
        Order By
            name;
    Return c;
    End fn_client_list;

    Function fn_costcode_abbr_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor as
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
    
        If v_empno = 'ERRRR' Then
            Return Null;
        End If;
    
        Open c For
            select 
                d.costcode                data_value_field, 
                d.costcode ||'-'|| c.abbr   data_text_field
            from
                deptphase d, costmast c 
            where 
                d.costcode = c.costcode and d.isPrimary = 1 
            order by 
                d.costcode;            
        Return c;
    end fn_costcode_abbr_list;

End iot_jobs_select_list_qry;
/
Grant Execute On "TIMECURR"."IOT_JOBS_SELECT_LIST_QRY" To "TCMPL_APP_CONFIG";