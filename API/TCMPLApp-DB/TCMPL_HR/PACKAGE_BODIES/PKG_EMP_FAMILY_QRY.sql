Create Or Replace Package Body "TCMPL_HR"."PKG_EMP_FAMILY_QRY" As

    Function fn_get_emp_family_list(

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
                        a.key_id                                    As "KEY_ID",           -- VARCHAR2 
                        a.empno                                     As "EMPNO",           -- VARCHAR2 
                        a.member                                    As "MEMBER",           -- VARCHAR2 
                        to_char(a.dob, 'DD-Mon-YYYY')               As "DOB",           -- DATE 
                        To_Number(a.relation)                       As "RELATION_VAL",           -- NUMBER 
                        To_Number(a.occupation)                     As "OCCUPATION_VAL",           -- NUMBER 
                        rel.description || '(' || rel.gender || ')' As "RELATION_TEXT",           -- VARCHAR2 
                        oc.description                              As "OCCUPATION_TEXT",           -- VARCHAR2 
                        a.remarks                                   As "REMARKS",           -- VARCHAR2 
                        to_char(a.modified_on, 'DD-Mon-YYYY')       As "MODIFIED_ON",           -- DATE 

                        Row_Number() Over (Order By a.member)       row_number,
                        Count(*) Over ()                            total_row
                    From
                        emp_family        a,
                        emp_relation_mast rel,
                        emp_occupation    oc
                    Where
                        empno        = Trim(p_empno)
                        And oc.code  = a.occupation
                        And rel.code = a.relation
                    Order By RELATION_VAL desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End fn_get_emp_family_list;

    Function fn_emp_family_list(
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

        Return fn_get_emp_family_list(
                p_empno       => v_empno,

                p_row_number  => p_row_number,
                p_page_length => p_page_length
            );

    End fn_emp_family_list;

    Function fn_4hr_emp_family_list(
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

        Return fn_get_emp_family_list(
                p_empno       => p_empno,

                p_row_number  => p_row_number,
                p_page_length => p_page_length
            );

    End fn_4hr_emp_family_list;

End pkg_emp_family_qry;
/
 Grant Execute On   "TCMPL_HR"."PKG_EMP_FAMILY_QRY"  To "TCMPL_APP_CONFIG";