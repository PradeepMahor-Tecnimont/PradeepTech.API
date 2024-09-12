Create Or Replace Package Body "TCMPL_HR"."PKG_EMP_ADHAAR" As

    Procedure sp_adhaar_details(

        p_empno            Varchar2,

        p_adhaar_no    Out Varchar2,
        p_adhaar_name  Out Varchar2,
        p_modified_on  Out Date,
        p_modified_by  Out Varchar2,
        p_has_aadhaar  Out Varchar2,
        p_file_name    Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin

        Select
            Count(*)
        Into
            v_exists
        From
            emp_adhaar
        Where
            empno = p_empno;

        If v_exists = 1 Then

            Select
            Distinct
                adhaar_no,
                adhaar_name,
                modified_on,
                modified_by,
                has_aadhaar
            Into
                p_adhaar_no,
                p_adhaar_name,
                p_modified_on,
                p_modified_by,
                p_has_aadhaar
            From
                emp_adhaar

            Where
                empno = p_empno;

            Select
                Count(*)
            Into
                v_exists
            From
                emp_scan_file
            Where
                empno         = Trim(p_empno)
                And file_type = 'AC';

            If v_exists = 1 Then
                Select
                Distinct file_name
                Into
                    p_file_name
                From
                    emp_scan_file
                Where
                    file_type = 'AC'
                    And empno = Trim(p_empno);
            End If;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';

        Else
            p_has_aadhaar  := not_ok;
            p_message_type := not_ok;
            p_message_text := 'No matching Employee adhaar exists !!!';
        End If;

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_adhaar_details;

    Procedure sp_update_adhaar(
        p_empno            Varchar2,
        p_modified_by      Varchar2,
        p_adhaar_no        Varchar2,
        p_adhaar_name      Varchar2,
        p_has_aadhaar      Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin

        Select
            Count(*)
        Into
            v_exists
        From
            emp_adhaar
        Where
            empno = p_empno;

        If v_exists = 1 Then

            Update
                emp_adhaar
            Set
                adhaar_no = Trim(upper(p_adhaar_no)),
                adhaar_name = Trim(upper(p_adhaar_name)),
                has_aadhaar = p_has_aadhaar,
                modified_on = sysdate,
                modified_by = p_modified_by
            Where
                empno = p_empno;

            Commit;

            p_message_type := ok;
            p_message_text := 'Employee adhaar updated successfully.';
        Else
            Insert Into emp_adhaar
            (
                empno,
                adhaar_no,
                adhaar_name,
                modified_on,
                modified_by,
                has_aadhaar
            )

            Values
            (
                p_empno,
                Trim(upper(p_adhaar_no)),
                Trim(upper(p_adhaar_name)),
                sysdate,
                p_modified_by,
                p_has_aadhaar
            );

            Commit;

            p_message_type := ok;
            p_message_text := 'Employee adhaar added successfully..';

        End If;

        If p_has_aadhaar = not_ok Then
            Delete
                From emp_scan_file
            Where
                empno         = p_empno
                And file_type = 'AC';
                
                Commit;
                
        End If;


    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee adhaar already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_adhaar;

    Procedure sp_emp_adhaar_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_adhaar_no    Out Varchar2,
        p_adhaar_name  Out Varchar2,
        p_modified_on  Out Date,
        p_modified_by  Out Varchar2,
        p_has_aadhaar  Out Varchar2,
        p_file_name    Out Varchar2,

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
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        pkg_emp_adhaar.sp_adhaar_details(
            p_empno        => v_empno,

            p_adhaar_no    => p_adhaar_no,
            p_adhaar_name  => p_adhaar_name,
            p_has_aadhaar  => p_has_aadhaar,
            p_modified_on  => p_modified_on,
            p_modified_by  => p_modified_by,
            p_file_name    => p_file_name,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_emp_adhaar_details;

    Procedure sp_update_emp_adhaar(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_adhaar_no        Varchar2 Default Null,
        p_adhaar_name      Varchar2 Default Null,
        p_has_aadhaar      Varchar2,

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
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        pkg_emp_adhaar.sp_update_adhaar(
            p_empno        => v_empno,
            p_modified_by  => v_empno,
            p_adhaar_no    => p_adhaar_no,
            p_adhaar_name  => p_adhaar_name,
            p_has_aadhaar  => p_has_aadhaar,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee adhaar already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_emp_adhaar;

    Procedure sp_4hr_emp_adhaar_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_adhaar_no    Out Varchar2,
        p_adhaar_name  Out Varchar2,
        p_modified_on  Out Date,
        p_modified_by  Out Varchar2,
        p_has_aadhaar  Out Varchar2,
        p_file_name    Out Varchar2,

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
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        pkg_emp_adhaar.sp_adhaar_details(
            p_empno        => p_empno,

            p_adhaar_no    => p_adhaar_no,
            p_adhaar_name  => p_adhaar_name,
            p_modified_on  => p_modified_on,
            p_modified_by  => p_modified_by,
            p_has_aadhaar  => p_has_aadhaar,
            p_file_name    => p_file_name,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_4hr_emp_adhaar_details;

    Procedure sp_update_4hr_emp_adhaar(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_adhaar_no        Varchar2 Default Null,
        p_adhaar_name      Varchar2 Default Null,
        p_has_aadhaar      Varchar2,

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
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        pkg_emp_adhaar.sp_update_adhaar(
            p_empno        => p_empno,
            p_modified_by  => v_empno,
            p_adhaar_no    => p_adhaar_no,
            p_adhaar_name  => p_adhaar_name,
            p_has_aadhaar  => p_has_aadhaar,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee adhaar already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_4hr_emp_adhaar;

End pkg_emp_adhaar;
/
 Grant Execute On   "TCMPL_HR"."PKG_EMP_ADHAAR"  To "TCMPL_APP_CONFIG";