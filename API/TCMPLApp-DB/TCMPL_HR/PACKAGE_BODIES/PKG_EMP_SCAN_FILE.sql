Create Or Replace Package Body tcmpl_hr.pkg_emp_scan_file As

    Procedure sp_scan_file_details(
        p_empno            Varchar2,
        p_file_type        Varchar2,

        p_file_name    Out Varchar,
        p_ref_number   Out Varchar2,
        p_modified_on  Out Date,
        p_modified_by  Out Varchar2,

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
            emp_scan_file
        Where
            empno         = Trim(p_empno)
            And file_type = p_file_type;

        If v_exists > 0 Then

            Select
                file_name,
                ref_number,
                modified_on,
                modified_by
            Into
                p_file_name,
                p_ref_number,
                p_modified_on,
                p_modified_by
            From
                emp_scan_file
            Where
                empno         = p_empno
                And file_type = p_file_type;
            /*
                empno           = Trim(p_empno)
                And file_type   = p_file_type
                And modified_on = (
                    Select
                        Max(modified_on)
                    From
                        emp_scan_file
                    Where
                        empno         = p_empno
                        And file_type = p_file_type
                );
*/
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := ok;
            p_message_text := 'No matching Employee scan file exists !!!';
        End If;

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_scan_file_details;

    Procedure sp_update_scan_file(
        p_empno            Varchar2,
        p_file_type        Varchar2,

        p_file_name        Varchar,
        p_ref_number       Varchar2,
        p_modified_by      Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_keyid        Varchar2(8);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin

        Select
            Count(*)
        Into
            v_exists
        From
            emp_scan_file
        Where
            empno         = Trim(p_empno)
            And file_type = p_file_type;

        If v_exists = 1 Then

            Update
                emp_scan_file
            Set
                file_name = p_file_name,
                ref_number = p_ref_number,
                modified_on = sysdate,
                modified_by = p_modified_by
            Where
                empno         = Trim(p_empno)
                And file_type = p_file_type;

            Commit;

            p_message_type := ok;
            p_message_text := 'Employee scan file updated successfully.';
        Else

            Insert Into emp_scan_file
            (
                empno,
                file_type,
                file_name,
                ref_number,
                modified_on,
                modified_by
            )
            Values
            (
                Trim(p_empno),
                Trim(p_file_type),
                Trim(p_file_name),
                Trim(p_ref_number),
                sysdate,
                p_modified_by
            );

            p_message_type := ok;
            p_message_text := 'Employee scan file added successfully..';

        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee scan file already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_scan_file;

    Procedure sp_emp_scan_file_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_file_type        Varchar2,

        p_file_name    Out Varchar,
        p_ref_number   Out Varchar2,
        p_modified_on  Out Date,
        p_modified_by  Out Varchar2,

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

        pkg_emp_scan_file.sp_scan_file_details(
            p_empno        => v_empno,
            p_file_type    => p_file_type,
            p_file_name    => p_file_name,
            p_ref_number   => p_ref_number,
            p_modified_on  => p_modified_on,
            p_modified_by  => p_modified_by,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_emp_scan_file_details;

    Procedure sp_update_emp_scan_file(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_file_type        Varchar2,

        p_file_name        Varchar,
        p_ref_number       Varchar2,

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

        pkg_emp_scan_file.sp_update_scan_file(
            p_empno        => v_empno,
            p_modified_by  => v_empno,
            p_file_type    => p_file_type,
            p_file_name    => p_file_name,
            p_ref_number   => p_ref_number,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee SCAN_FILE already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_emp_scan_file;

    Procedure sp_4hr_emp_scan_file_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_file_type        Varchar2,

        p_file_name    Out Varchar,
        p_ref_number   Out Varchar2,
        p_modified_on  Out Date,
        p_modified_by  Out Varchar2,

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

        pkg_emp_scan_file.sp_scan_file_details(
            p_empno        => p_empno,
            p_file_type    => p_file_type,
            p_file_name    => p_file_name,
            p_ref_number   => p_ref_number,
            p_modified_on  => p_modified_on,
            p_modified_by  => p_modified_by,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_4hr_emp_scan_file_details;

    Procedure sp_update_4hr_emp_scan_file(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_file_type        Varchar2,

        p_file_name        Varchar,
        p_ref_number       Varchar2,

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

        pkg_emp_scan_file.sp_update_scan_file(
            p_empno        => p_empno,
            p_modified_by  => v_empno,
            p_file_type    => p_file_type,
            p_file_name    => p_file_name,
            p_ref_number   => p_ref_number,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee SCAN_FILE already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_4hr_emp_scan_file;

End pkg_emp_scan_file;
/
 Grant Execute On   tcmpl_hr.pkg_emp_scan_file  To tcmpl_app_config;