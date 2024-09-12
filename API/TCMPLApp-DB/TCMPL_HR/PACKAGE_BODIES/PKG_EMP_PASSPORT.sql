Create Or Replace Package Body "TCMPL_HR"."PKG_EMP_PASSPORT" As

    Procedure sp_passport_details(

        p_empno            Varchar2,

        p_has_passport Out Varchar2,
        p_passport_no  Out Varchar,
        p_surname      Out Varchar2,
        p_given_name   Out Varchar2,
        p_issued_at    Out Varchar2,
        p_issue_date   Out Date,
        p_expiry_date  Out Date,
        p_modified_on  Out Date,
        p_modified_by  Out Varchar2,
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
            emp_passport
        Where
            empno = Trim(p_empno);

        If v_exists = 1 Then

            Select
            Distinct
                Trim(has_passport),
                passport_no,
                Trim(surname),
                Trim(given_name),
                Trim(issued_at),
                Trim(issue_date),
                Trim(expiry_date),
                modified_on,
                Trim(modified_by)
            Into
                p_has_passport,
                p_passport_no,
                p_surname,
                p_given_name,
                p_issued_at,
                p_issue_date,
                p_expiry_date,
                p_modified_on,
                p_modified_by
            From
                emp_passport
            Where
                empno = Trim(p_empno);

            Select
                Count(*)
            Into
                v_exists
            From
                emp_scan_file
            Where
                empno         = Trim(p_empno)
                And file_type = 'PP';

            If v_exists > 0 Then
                Select
                    file_name
                Into
                    p_file_name
                From
                    emp_scan_file
                Where
                    Rowid In (
                        Select
                                Max(Rowid) Keep (Dense_Rank Last Order By
                                modified_on)
                        From
                            emp_scan_file
                        Where
                            empno         = p_empno
                            And file_type = 'PP'
                        Group By
                            empno
                    );
                /*                
                file_type       = 'PP'
                And empno       = Trim(p_empno)
                And (rowid,modified_on) = (
                    Select
                        max(rowid), Max(modified_on)
                    From
                        emp_scan_file
                    Where
                        file_type = 'PP'
                        And empno = Trim(p_empno)
                );
                */
            End If;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_passport_no  := not_ok;
            p_message_type := ok;
            p_message_text := 'No matching Employee passport exists !!!';
        End If;

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_passport_details;

    Procedure sp_update_passport(
        p_empno            Varchar2,
        p_has_passport     Varchar2,
        p_passport_no      Varchar2 Default Null,
        p_surname          Varchar2,
        p_given_name       Varchar2,
        p_issued_at        Varchar2,
        p_issue_date       Date,
        p_expiry_date      Date,

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
            emp_passport
        Where
            empno = p_empno;

        If v_exists = 1 Then

            Update
                emp_passport
            Set
                has_passport = upper(Trim(p_has_passport)),
                passport_no = upper(Trim(p_passport_no)),
                surname = upper(Trim(p_surname)),
                given_name = upper(Trim(p_given_name)),
                issued_at = upper(Trim(p_issued_at)),
                issue_date = p_issue_date,
                expiry_date = p_expiry_date,
                modified_on = sysdate,
                modified_by = p_modified_by
            Where
                empno = Trim(p_empno);
            Commit;

            p_message_type := ok;
            p_message_text := 'Employee passport updated successfully.';
        Else
            v_keyid        := dbms_random.string('X', 8);

            Select
                Count(*)
            Into
                v_exists
            From
                emp_passport
            Where
                Trim(upper(empno)) = Trim(upper(p_empno));

            Insert Into emp_passport
            (
                empno,
                has_passport,
                surname,
                given_name,
                issued_at,
                issue_date,
                expiry_date,
                modified_on,
                modified_by
            )

            Values
            (
                Trim(p_empno),
                Trim(p_has_passport),
                Trim(p_surname),
                Trim(p_given_name),
                Trim(p_issued_at),
                p_issue_date,
                p_expiry_date,
                sysdate,
                p_modified_by
            );

            /* Update
                   emp_details
               Set
                   passport_no = p_passport_no
               Where
                   empno = Trim(p_empno); */
            Commit;
            p_message_type := ok;
            p_message_text := 'Employee passport added successfully..';

        End If;

        If p_has_passport = not_ok Then
            Delete
                From emp_scan_file
            Where
                empno         = p_empno
                And file_type = 'PP';
            Commit;
        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee passport already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_passport;

    Procedure sp_emp_passport_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_has_passport Out Varchar2,
        p_passport_no  Out Varchar,
        p_surname      Out Varchar2,
        p_given_name   Out Varchar2,
        p_issued_at    Out Varchar2,
        p_issue_date   Out Date,
        p_expiry_date  Out Date,
        p_modified_on  Out Date,
        p_modified_by  Out Varchar2,
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

        pkg_emp_passport.sp_passport_details(
            p_empno        => v_empno,
            p_has_passport => p_has_passport,
            p_passport_no  => p_passport_no,
            p_surname      => p_surname,
            p_given_name   => p_given_name,
            p_issued_at    => p_issued_at,
            p_issue_date   => p_issue_date,
            p_expiry_date  => p_expiry_date,
            p_file_name    => p_file_name,
            p_modified_on  => p_modified_on,
            p_modified_by  => p_modified_by,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_emp_passport_details;

    Procedure sp_update_emp_passport(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_has_passport     Varchar2,
        p_passport_no      Varchar2 Default Null,
        p_surname          Varchar2 Default Null,
        p_given_name       Varchar2 Default Null,
        p_issued_at        Varchar2 Default Null,
        p_issue_date       Date     Default Null,
        p_expiry_date      Date     Default Null,

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

        pkg_emp_passport.sp_update_passport(
            p_empno        => v_empno,
            p_modified_by  => v_empno,
            p_has_passport => p_has_passport,
            p_passport_no  => p_passport_no,
            p_surname      => p_surname,
            p_given_name   => p_given_name,
            p_issued_at    => p_issued_at,
            p_issue_date   => p_issue_date,
            p_expiry_date  => p_expiry_date,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee passport already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_emp_passport;

    Procedure sp_4hr_emp_passport_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_has_passport Out Varchar2,
        p_passport_no  Out Varchar,
        p_surname      Out Varchar2,
        p_given_name   Out Varchar2,
        p_issued_at    Out Varchar2,
        p_issue_date   Out Date,
        p_expiry_date  Out Date,
        p_modified_on  Out Date,
        p_modified_by  Out Varchar2,
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

        pkg_emp_passport.sp_passport_details(
            p_empno        => p_empno,
            p_has_passport => p_has_passport,
            p_passport_no  => p_passport_no,
            p_surname      => p_surname,
            p_given_name   => p_given_name,
            p_issued_at    => p_issued_at,
            p_issue_date   => p_issue_date,
            p_expiry_date  => p_expiry_date,
            p_file_name    => p_file_name,
            p_modified_on  => p_modified_on,
            p_modified_by  => p_modified_by,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_4hr_emp_passport_details;

    Procedure sp_update_4hr_emp_passport(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_has_passport     Varchar2,
        p_passport_no      Varchar2 Default Null,
        p_surname          Varchar2 Default Null,
        p_given_name       Varchar2 Default Null,
        p_issued_at        Varchar2 Default Null,
        p_issue_date       Date     Default Null,
        p_expiry_date      Date     Default Null,

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

        pkg_emp_passport.sp_update_passport(
            p_empno        => p_empno,
            p_modified_by  => v_empno,
            p_has_passport => p_has_passport,
            p_passport_no  => p_passport_no,
            p_surname      => p_surname,
            p_given_name   => p_given_name,
            p_issued_at    => p_issued_at,
            p_issue_date   => p_issue_date,
            p_expiry_date  => p_expiry_date,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee passport already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_4hr_emp_passport;

End pkg_emp_passport;
/
 Grant Execute On   "TCMPL_HR"."PKG_EMP_PASSPORT"  To "TCMPL_APP_CONFIG";