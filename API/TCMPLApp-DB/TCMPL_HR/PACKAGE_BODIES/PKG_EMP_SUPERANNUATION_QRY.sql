Create Or Replace Package Body "TCMPL_HR"."PKG_EMP_SUP_ANNUATION_QRY" As

    Function fn_get_emp_sup_annuation_list(

        p_empno       Varchar2,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin

        Open c For
            Select
                key_id,
                empno,
                nom_name,
                nom_add1,
                relation,
                to_char(nom_dob, 'DD-Mon-YYYY') nom_dob,
                to_char(share_pcnt)             As share_pcnt,
                '1'                             As is_editable,
                Row_Number() Over (Order By
                        nom_name Desc)          row_number,
                Count(*) Over ()                total_row
            From
                emp_sup_annuation
            Where
                empno = Trim(p_empno)
            Order By
                nom_dob Desc;
        Return c;

    End fn_get_emp_sup_annuation_list;

    Function fn_emp_sup_annuation_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Return fn_get_emp_sup_annuation_list(
                p_empno       => v_empno,

                p_row_number  => p_row_number,
                p_page_length => p_page_length
            );

    End fn_emp_sup_annuation_list;

    Function fn_4hr_emp_sup_annuation_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        v_hr_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin

        v_hr_empno := get_empno_from_meta_id(p_meta_id);

        If v_hr_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Return fn_get_emp_sup_annuation_list(
                p_empno       => p_empno,

                p_row_number  => p_row_number,
                p_page_length => p_page_length
            );

    End fn_4hr_emp_sup_annuation_list;

End pkg_emp_sup_annuation_qry;
/
 Grant Execute On   "TCMPL_HR"."PKG_EMP_SUP_ANNUATION_QRY"  To "TCMPL_APP_CONFIG";