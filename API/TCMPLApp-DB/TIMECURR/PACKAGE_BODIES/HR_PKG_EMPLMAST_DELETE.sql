CREATE OR REPLACE PACKAGE BODY "TIMECURR"."HR_PKG_EMPLMAST_DELETE" as 

    Function fn_delete_employee_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor as
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);        
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
     begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            Raise e_employee_not_found;
            Return Null;            
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        keyid,
                        empno,
                        initcap(hr_pkg_common.get_employee_name(empno))         name,                        
                        createdon,
                        createdby,
                        initcap(hr_pkg_common.get_employee_name(createdby))     createdbyname,
                        nvl(isapproved,0)                                       isapproved,
                        Row_Number() Over (Order By keyid)                      row_number,
                        Count(*) Over ()                                        total_row
                    From
                        hr_emplmast_delete
                    Where
                        nvl(isapproved, 0) = 0 and
                        (   upper(empno) Like upper('%' || p_generic_search || '%') Or
                            upper(hr_pkg_common.get_employee_name(empno)) Like upper('%' || p_generic_search || '%') 
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                empno;
        Return c;
    end fn_delete_employee_list;

    Procedure sp_delete_employee_request (
        p_person_id     Varchar2,
        p_meta_id       Varchar2,        
        p_empno         Varchar2,        
        p_message_type  Out     Varchar2,
        p_message_text  Out     Varchar2
    ) as
        v_emp_exists    Number        := 0;
        v_exists        Number        := 0;
        v_empno         Varchar2(5);
        v_keyid         Varchar2(8);
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_keyid := dbms_random.string('X', 8);

        Select
            Count(*)
        Into
            v_emp_exists
        From
            hr_emplmast_main
        Where
            Trim(upper(empno)) = Trim(upper(p_empno));

        Select
            Count(*)
        Into
            v_exists
        From
            hr_emplmast_delete
        Where
            Trim(upper(empno)) = Trim(upper(p_empno))
            And nvl(isapproved, 0) = 0;

        If v_emp_exists = 1 and v_exists = 0 Then
            Insert Into hr_emplmast_delete (
                keyid,
                empno,
                createdby,
                createdon,
                isapproved
            )
            Values (
                v_keyid,
                Trim(upper(p_empno)),
                v_empno,
                sysdate,
                0
            );
            p_message_type := 'OK';
            p_message_text := 'Employee delete request generated successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Delete request already exits.';
        End If; 
        Commit;
      Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    end sp_delete_employee_request;

    Procedure sp_delete_employee_approval(
        p_person_id     Varchar2,
        p_meta_id       Varchar2,        
        p_key_id         Varchar2,        
        p_message_type  Out     Varchar2,
        p_message_text  Out     Varchar2
    ) as
        v_employee      Varchar2(5);
        v_empno         Varchar2(5);        
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        select
            empno
        into
            v_employee
        from
            hr_emplmast_delete
        where
            keyid = p_key_id;

        if length(v_employee) > 0 then
            delete from hr_emplmast_misc where trim(empno) = trim(v_employee);
            delete from hr_emplmast_roles where trim(empno) = trim(v_employee);        
            delete from hr_emplmast_organization where trim(empno) = trim(v_employee);        
            delete from hr_emplmast_organization_qual where trim(empno) = trim(v_employee);        
            delete from hr_emplmast_applications where trim(empno) = trim(v_employee);        
            delete from hr_emplmast_address where trim(empno) = trim(v_employee);        
            delete from hr_emplmast_main where trim(empno) = trim(v_employee);        
            delete from emplmast where trim(empno) = trim(v_employee);        

            Update
                hr_emplmast_delete
            Set
                isapproved = 1,
                approvedby = v_empno,
                approvedon = sysdate
            Where
                keyid = p_key_id;
            Commit;

            p_message_type := 'OK';
            p_message_text := 'Employee deleted successfully.';
         else
            p_message_type := 'KO';
            p_message_text := 'Employee does not exists.';
        end if;
      Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;   

    end sp_delete_employee_approval;
    
    Procedure sp_delete_employee_request_delete(
        p_person_id     Varchar2,
        p_meta_id       Varchar2,        
        p_key_id         Varchar2,        
        p_message_type  Out     Varchar2,
        p_message_text  Out     Varchar2
    ) as
        v_request       Number := 0;
        v_empno         Varchar2(5);        
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        select
            count(keyid)
        into
            v_request
        from
            hr_emplmast_delete
        where
            keyid = p_key_id;

        if v_request > 0 then
            delete from hr_emplmast_delete where trim(keyid) = trim(p_key_id);
            Commit;

            p_message_type := 'OK';
            p_message_text := 'Request deleted successfully.';
         else
            p_message_type := 'KO';
            p_message_text := 'Employee does not exists.';
        end if;
      Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;   

    end sp_delete_employee_request_delete;
    
END HR_PKG_EMPLMAST_DELETE;

/
Grant Execute On "TIMECURR"."HR_PKG_EMPLMAST_DELETE" To "TCMPL_APP_CONFIG";