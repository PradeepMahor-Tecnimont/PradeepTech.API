Create Or Replace Package Body "TCMPL_HR"."PKG_EMP_EPS_4_MARRIED_QRY" As

    Function fn_get_emp_eps_4_married_list(

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
                *
            From
                (

                    Select
                    Distinct
                        a.key_id                              As "KEY_ID",           -- VARCHAR2 
                        a.empno                               As "EMPNO",           -- VARCHAR2 
                        a.nom_name                            As "NOM_NAME",           -- VARCHAR2 
                        a.nom_add1                            As "NOM_ADD1",           -- VARCHAR2 
                        a.relation                            As "RELATION",           -- VARCHAR2 
                        to_char(a.nom_dob, 'DD-Mon-YYYY')     As "NOM_DOB",           -- DATE 
                        to_char(a.modified_on, 'DD-Mon-YYYY') As "MODIFIED_ON",           -- DATE 

                        Row_Number() Over (Order By a.empno)  row_number,
                        Count(*) Over ()                      total_row
                    From
                        emp_eps_4_married a
                    Where
                        a.empno = Trim(p_empno)
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End fn_get_emp_eps_4_married_list;

    Function fn_emp_eps_4_married_list(
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

        Return fn_get_emp_eps_4_married_list(
                p_empno       => v_empno,

                p_row_number  => p_row_number,
                p_page_length => p_page_length
            );

    End fn_emp_eps_4_married_list;

    Function fn_4hr_emp_eps_4_married_list(
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

        Return fn_get_emp_eps_4_married_list(
                p_empno       => p_empno,

                p_row_number  => p_row_number,
                p_page_length => p_page_length
            );

    End fn_4hr_emp_eps_4_married_list;

End pkg_emp_eps_4_married_qry;
/
 Grant Execute On   "TCMPL_HR"."PKG_EMP_EPS_4_MARRIED_QRY"  To "TCMPL_APP_CONFIG";