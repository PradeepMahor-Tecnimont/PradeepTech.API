Create Or Replace Package Body tcmpl_hr.mis_select_list_qry As

    Function fn_emp_list_all(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For

            Select
                empno                  data_value_field,
                empno || ' - ' || name data_text_field
            From
                vu_emplmast
            Where
                status = 1
            Order By
                empno;
        Return c;
    End;

    Function fn_dept_list_all(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For

            Select
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                vu_costmast
            Order By
                costcode;
        Return c;

    End;

    Function fn_joining_status_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For

            Select
                join_status_code data_value_field,
                join_status_desc data_text_field
            From
                mis_mast_joining_status
            Order By
                join_status_code;
        Return c;
    End;

    Function fn_office_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For

            Select
                office_location_code data_value_field,
                office_location_desc data_text_field
            From
                mis_mast_office_location
            Order By
                office_location_code;
        Return c;
    End;

    Function fn_resign_reason_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For

            Select
                resign_reason_type data_value_field,
                resign_reason_desc data_text_field
            From
                mis_mast_resign_reason_types
            Order By
                resign_reason_type;
        Return c;
    End;

    Function fn_resign_status_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For

            Select
                resign_status_code data_value_field,
                resign_status_desc data_text_field
            From
                mis_mast_resign_status
            Order By
                resign_status_code;
        Return c;
    End;

    Function fn_emp_curr_res_loc(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For

            Select
                loc_id   data_value_field,
                loc_desc data_text_field
            From
                mis_mast_cur_emp_res_loc
            Order By
                loc_desc;
        Return c;
    End;

    Function fn_employment_type(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For

            Select
                key_id          data_value_field,
                employment_type data_text_field
            From
                mis_employment_type
            Where
                is_active = 1
            Order By
                employment_type;
        Return c;
    End;

    Function fn_grade(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For

            Select
                grade_id   data_value_field,
                grade_desc data_text_field
            From
                vu_grademast

            Order By
                grade_desc;
        Return c;
    End;

    Function fn_designation(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For

            Select
                desgcode data_value_field,
                desg     data_text_field
            From
                vu_desgmast

            Order By
                desg;
        Return c;
    End;

    Function fn_sources_of_candidate(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For

            Select
                key_id               data_value_field,
                sources_of_candidate data_text_field
            From
                mis_sources_of_candidate
            Where
                is_active = 1
            Order By
                sources_of_candidate;
        Return c;
    End;

    Function fn_pre_emp_medical_test(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For

            Select
                key_id           data_value_field,
                pre_medical_test data_text_field
            From
                mis_pre_emp_medical_test
            Where
                is_active = 1
            Order By
                pre_medical_test;
        Return c;
    End;

    Function fn_rollback_emp_list_all(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                c.empno                             data_value_field,
                c.empno || ' - ' || c.employee_name data_text_field
            From
                ofb_vu_emp_exits c
            where 
				approval_status='KO'
                And c.empno Not In (
                    Select
                        c.empno
                    From
                        ofb_rollback c
                )
            order by 
				c.empno;
        Return c;
    End;

    Function fn_dept_deputation_list_all(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        
        p_costcode  Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_count              Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        Select 
            count(*) 
        Into 
            v_count 
        From
            dg_mid_transfer_costcode_deputation
        Where costcode = trim(p_costcode);
        
        If v_count = 0 Then
            Return null;
        End If;
        
        Open c For
            Select
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                vu_costmast
            Where costcode In (Select 
                                    dep_costcode 
                               From 
                                    dg_mid_transfer_costcode_deputation_dept                        
                               )            
            Order By
                costcode;
        Return c;

    End;
End;