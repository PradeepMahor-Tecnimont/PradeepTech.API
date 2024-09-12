Create Or Replace Package Body "TCMPL_HR"."PKG_EMP_EPS_4_ALL" As

    Procedure sp_add_eps_4_all(

        p_empno            Varchar2,
        p_modified_by      Varchar2,
        p_nom_name         Varchar2,
        p_nom_add1         Varchar2,
        p_relation         Varchar2,
        p_nom_dob          Date,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_keyid        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin

        v_keyid := dbms_random.string('X', 5);

        Select
            Count(*)
        Into
            v_exists
        From
            emp_eps_4_all
        Where
            Trim(empno)        = Trim(p_empno)
            And Trim(nom_name) = Trim(p_nom_name)
            And Trim(relation) = Trim(p_relation)
            And trunc(nom_dob) = trunc(p_nom_dob);

        If v_exists = 0 Then
            Insert Into emp_eps_4_all
            (
                key_id,
                empno,
                nom_name,
                nom_add1,
                relation,
                nom_dob,
                modified_on,
                modified_by
            )

            Values
            (
                v_keyid,
                Trim(p_empno),
                Trim(p_nom_name),
                Trim(p_nom_add1),
                Trim(p_relation),
                p_nom_dob,
                sysdate,
                p_modified_by
            );

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Employee pension fund added successfully..';
        Else
            p_message_type := 'KO';
            p_message_text := 'Employee pension fund already exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_eps_4_all;

    Procedure sp_update_eps_4_all(

        p_key_id           Varchar2,
        p_empno            Varchar2,
        p_modified_by      Varchar2,
        p_nom_name         Varchar2,
        p_nom_add1         Varchar2,
        p_relation         Varchar2,
        p_nom_dob          Date,

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
            emp_eps_4_all
        Where
            key_id          = p_key_id
            And Trim(empno) = Trim(p_empno);

        If v_exists = 1 Then

            Update
                emp_eps_4_all
            Set
                empno = Trim(p_empno),
                nom_name = Trim(p_nom_name),
                nom_add1 = Trim(p_nom_add1),
                relation = Trim(p_relation),
                nom_dob = p_nom_dob,
                modified_on = sysdate,
                modified_by = p_modified_by
            Where
                key_id          = p_key_id
                And Trim(empno) = Trim(p_empno);

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Employee pension fund updated successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching Employee pension fund exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'Employee pension fund already exists !!!';
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_eps_4_all;

    Procedure sp_delete_eps_4_all(

        p_key_id           Varchar2,
        p_empno            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin

        Delete
            From emp_eps_4_all
        Where
            key_id          = p_key_id
            And Trim(empno) = Trim(p_empno);

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Record deleted successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_eps_4_all;

    Procedure sp_emp_eps_4_all_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_empno        Out Varchar2,
        p_nom_name     Out Varchar2,
        p_nom_add1     Out Varchar2,
        p_relation     Out Varchar2,
        p_nom_dob      Out Date,
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
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            emp_eps_4_all
        Where
            key_id = p_key_id;

        If v_exists = 1 Then

            Select
            Distinct empno,
                nom_name,
                nom_add1,
                relation,
                nom_dob,
                modified_on
            Into
                p_empno,
                p_nom_name,
                p_nom_add1,
                p_relation,
                p_nom_dob,
                p_modified_on
            From
                emp_eps_4_all

            Where
                key_id = p_key_id;

            Commit;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Employee pension fund exists !!!';
        End If;

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_emp_eps_4_all_details;

    Procedure sp_add_emp_eps_4_all(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_nom_name         Varchar2,
        p_nom_add1         Varchar2,
        p_relation         Varchar2,
        p_nom_dob          Date,

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

        pkg_emp_eps_4_all.sp_add_eps_4_all(
            p_empno        => v_empno,
            p_modified_by  => v_empno,
            p_nom_name     => p_nom_name,
            p_nom_add1     => p_nom_add1,
            p_relation     => p_relation,
            p_nom_dob      => p_nom_dob,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_emp_eps_4_all;

    Procedure sp_update_emp_eps_4_all(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_nom_name         Varchar2,
        p_nom_add1         Varchar2,
        p_relation         Varchar2,
        p_nom_dob          Date,

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

        pkg_emp_eps_4_all.sp_update_eps_4_all(

            p_key_id       => p_key_id,
            p_empno        => v_empno,
            p_modified_by  => v_empno,
            p_nom_name     => p_nom_name,
            p_nom_add1     => p_nom_add1,
            p_relation     => p_relation,
            p_nom_dob      => p_nom_dob,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

    Exception
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'Employee pension fund already exists !!!';
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_emp_eps_4_all;

    Procedure sp_delete_emp_eps_4_all(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        pkg_emp_eps_4_all.sp_delete_eps_4_all(
            p_key_id       => p_key_id,
            p_empno        => v_empno,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        p_message_type := 'OK';
        p_message_text := 'Record deleted successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_emp_eps_4_all;

    Procedure sp_add_4hr_emp_eps_4_all(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_nom_name         Varchar2,
        p_nom_add1         Varchar2,
        p_relation         Varchar2,
        p_nom_dob          Date,

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

        pkg_emp_eps_4_all.sp_add_eps_4_all(
            p_empno        => p_empno,
            p_modified_by  => v_empno,
            p_nom_name     => p_nom_name,
            p_nom_add1     => p_nom_add1,
            p_relation     => p_relation,
            p_nom_dob      => p_nom_dob,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_4hr_emp_eps_4_all;

    Procedure sp_update_4hr_emp_eps_4_all(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_empno            Varchar2,
        p_nom_name         Varchar2,
        p_nom_add1         Varchar2,
        p_relation         Varchar2,
        p_nom_dob          Date,

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

        pkg_emp_eps_4_all.sp_update_eps_4_all(

            p_key_id       => p_key_id,
            p_empno        => p_empno,
            p_modified_by  => v_empno,
            p_nom_name     => p_nom_name,
            p_nom_add1     => p_nom_add1,
            p_relation     => p_relation,
            p_nom_dob      => p_nom_dob,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

    Exception
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'Employee pension fund already exists !!!';
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_4hr_emp_eps_4_all;

    Procedure sp_delete_4hr_emp_eps_4_all(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_empno            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        pkg_emp_eps_4_all.sp_delete_eps_4_all(
            p_key_id       => p_key_id,
            p_empno        => p_empno,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        p_message_type := 'OK';
        p_message_text := 'Record deleted successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_4hr_emp_eps_4_all;

End pkg_emp_eps_4_all;
/
 Grant Execute On   "TCMPL_HR"."PKG_EMP_EPS_4_ALL"  To "TCMPL_APP_CONFIG";