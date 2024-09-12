Create Or Replace Package Body "TCMPL_HR"."PKG_EMP_ADHAAR_QRY" As

    Function fn_emp_adhaar_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_empno          Varchar2 Default Null,
        p_adhaar_no      Varchar2 Default Null,
        p_adhaar_name    Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        v_empno Varchar2(5);         
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c       Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (

                    Select
                        a.key_id                             As "KEY_ID",           -- VARCHAR2 
                        a.empno                              As "EMPNO",           -- VARCHAR2 
                        a.adhaar_no                          As "ADHAAR_NO",           -- VARCHAR2 
                        a.adhaar_name                        As "ADHAAR_NAME",           -- VARCHAR2 
                        a.modified_on                        As "MODIFIED_ON",           -- DATE 

                        Row_Number() Over (Order By a.empno) row_number,
                        Count(*) Over ()                     total_row
                    From
                        emp_adhaar a
                    Where
                        Trim(a.empno) = nvl(Trim(p_empno), v_empno)
                /*                        
                and a.empno           = nvl(Trim(p_empno), a.empno)
                And a.adhaar_no   = nvl(Trim(p_adhaar_no), a.adhaar_no)
                And a.adhaar_name = nvl(Trim(p_adhaar_name), a.adhaar_name)
                And
                (
                    upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%' Or

                    upper(a.adhaar_no) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.adhaar_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                )
                */
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End fn_emp_adhaar_list;

    Procedure sp_emp_adhaar_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_empno        Out Varchar2,
        p_adhaar_no    Out Varchar2,
        p_adhaar_name  Out Varchar2,
        p_modified_on  Out Date,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            emp_adhaar
        Where
            key_id = p_key_id;

        If v_exists = 1 Then

            Select
            Distinct empno,
                adhaar_no,
                adhaar_name,
                modified_on
            Into
                p_empno,
                p_adhaar_no,
                p_adhaar_name,
                p_modified_on
            From
                emp_adhaar

            Where
                key_id = p_key_id;

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';

        Else
            p_message_type := 'KO';
            p_message_text := 'No matching Employee adhaar exists !!!';
        End If;

    Exception

        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_emp_adhaar_details;

    Function sp_emp_adhaar_xl_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_empno          Varchar2 Default Null,
        p_adhaar_no      Varchar2 Default Null,
        p_adhaar_name    Varchar2 Default Null,
        p_modified_on    Date Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                a.key_id      As "KEY_ID",
                a.empno       As "EMPNO",
                a.adhaar_no   As "ADHAAR_NO",
                a.adhaar_name As "ADHAAR_NAME",
                a.modified_on As "MODIFIED_ON"
            From
                emp_adhaar a
            Where
                a.empno           = nvl(Trim(p_empno), a.empno)
                And a.adhaar_no   = nvl(Trim(p_adhaar_no), a.adhaar_no)
                And a.adhaar_name = nvl(Trim(p_adhaar_name), a.adhaar_name)
                And
                (
                    upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%' Or

                    upper(a.adhaar_no) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.adhaar_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                );

        Return c;

    End sp_emp_adhaar_xl_list;

End pkg_emp_adhaar_qry;
/
 Grant Execute On   "TCMPL_HR"."PKG_EMP_ADHAAR_QRY"  To "TCMPL_APP_CONFIG";