Create Or Replace Package Body "TCMPL_HR"."PKG_EMP_GTLI" As

    Procedure sp_add_gtli(

        p_empno                    Varchar2,
        p_modified_by              Varchar2,
        p_nom_name                 Varchar2,
        p_nom_add1                 Varchar2,
        p_relation                 Varchar2,
        p_nom_dob                  Date Default null,
        p_share_pcnt               Number,
       p_nom_minor_guard_name     Varchar2 Default null,
        p_nom_minor_guard_add1     Varchar2 Default null,
        p_nom_minor_guard_relation Varchar2 Default null,

        p_message_type Out         Varchar2,
        p_message_text Out         Varchar2
    ) As
        v_exists       Number;
        v_share_pcnt   Number;
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
            emp_gtli
        Where
            Trim(empno) = Trim(p_empno);

        If v_exists > 0 Then
            Select
                (100 - nvl(Sum(share_pcnt), 0)) As remain_share_pcnt
            Into
                v_share_pcnt
            From
                emp_gtli
            Where
                Trim(empno) = Trim(p_empno)
            Group By
                empno;

            If p_share_pcnt > v_share_pcnt Then
                p_message_type := 'KO';
                p_message_text := 'Total percentage should be equal to 100 remain percentage is ' || to_char(v_share_pcnt);
                Return;
            End If;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            emp_gtli
        Where
            Trim(empno)        = Trim(p_empno)
            And Trim(nom_name) = Trim(p_nom_name)
            And Trim(relation) = Trim(p_relation)
            And trunc(nom_dob) = trunc(p_nom_dob);

        If v_exists = 0 Then
            Insert Into emp_gtli
            (
                key_id,
                empno,
                nom_name,
                nom_add1,
                relation,
                nom_dob,
                share_pcnt,
                nom_minor_guard_name,
                nom_minor_guard_add1,
                nom_minor_guard_relation,
                modified_on,
                modified_by
            )

            Values
            (
                v_keyid,
                Trim(p_empno),
                Trim(upper(p_nom_name)),
                Trim(p_nom_add1),
                Trim(upper(p_relation)),
                p_nom_dob,
                p_share_pcnt,
                Trim(p_nom_minor_guard_name),
                Trim(p_nom_minor_guard_add1),
                Trim(p_nom_minor_guard_relation),
                sysdate,
                p_modified_by
            );

            Commit;

            p_message_type := ok;
            p_message_text := 'Employee gtli added successfully..';
        Else
            p_message_type := not_ok;
            p_message_text := 'Employee gtli already exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_gtli;

    Procedure sp_update_gtli(
        p_key_id                   Varchar2,
        p_empno                    Varchar2,
        p_modified_by              Varchar2,
        p_nom_name                 Varchar2,
        p_nom_add1                 Varchar2,
        p_relation                 Varchar2,
        p_nom_dob                 Date Default null,
        p_share_pcnt               Number,
       p_nom_minor_guard_name     Varchar2 Default null,
        p_nom_minor_guard_add1     Varchar2 Default null,
        p_nom_minor_guard_relation Varchar2 Default null,

        p_message_type Out         Varchar2,
        p_message_text Out         Varchar2
    ) As
        v_exists       Number;
        v_share_pcnt   Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin

        Select
            Count(*)
        Into
            v_exists
        From
            emp_gtli
        Where
            key_id          = p_key_id
            And Trim(empno) = Trim(p_empno);

        Select
            (share_pcnt - p_share_pcnt) As remain_share_pcnt
        Into
            v_share_pcnt
        From
            emp_gtli
        Where
            key_id          = p_key_id
            And Trim(empno) = Trim(p_empno);

        Select
            (Sum(share_pcnt) - v_share_pcnt) As remain_share_pcnt
        Into
            v_share_pcnt
        From
            emp_gtli
        Where
            Trim(empno) = Trim(p_empno)
        Group By
            empno;

        If 100 < (v_share_pcnt) Then
            p_message_type := 'KO';
            p_message_text := 'Total percentage should be equal to 100';
            Return;
        End If;

        If v_exists = 1 Then

            Update
                emp_gtli
            Set
                nom_name = Trim(upper(p_nom_name)),
                nom_add1 = Trim(p_nom_add1),
                relation = Trim(upper(p_relation)),
                nom_dob = p_nom_dob,
                share_pcnt = p_share_pcnt,
                nom_minor_guard_name = Trim(p_nom_minor_guard_name),
                nom_minor_guard_add1 = Trim(p_nom_minor_guard_add1),
                nom_minor_guard_relation = Trim(p_nom_minor_guard_relation),
                modified_on = sysdate,
                modified_by = p_modified_by
            Where
                key_id          = p_key_id
                And Trim(empno) = Trim(p_empno);

            Commit;

            p_message_type := ok;
            p_message_text := 'Employee gtli updated successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Employee gtli exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee gtli already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_gtli;

    Procedure sp_delete_gtli(

        p_key_id           Varchar2,
        p_empno            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin

        Delete
            From emp_gtli
        Where
            key_id          = p_key_id
            And Trim(empno) = Trim(p_empno);

        Commit;

        p_message_type := ok;
        p_message_text := 'Record deleted successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_gtli;

    Procedure sp_emp_gtli_detail(
        p_person_id                    Varchar2,
        p_meta_id                      Varchar2,

        p_key_id                       Varchar2,

        p_empno                    Out Varchar2,
        p_nom_name                 Out Varchar2,
        p_nom_add1                 Out Varchar2,
        p_relation                 Out Varchar2,
        p_nom_dob                  Out Date,
        p_share_pcnt               Out Number,
        p_nom_minor_guard_name     Out Varchar2,
        p_nom_minor_guard_relation Out Varchar2,
        p_nom_minor_guard_add1     Out Varchar2,

        p_message_type             Out Varchar2,
        p_message_text             Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            eg.empno,
            eg.nom_name,
            eg.nom_add1,
            eg.relation,
            eg.nom_dob,
            eg.share_pcnt,
            eg.nom_minor_guard_name,
            eg.nom_minor_guard_relation,
            eg.nom_minor_guard_add1
        Into
            p_empno,
            p_nom_name,
            p_nom_add1,
            p_relation,
            p_nom_dob,
            p_share_pcnt,
            p_nom_minor_guard_name,
            p_nom_minor_guard_relation,
            p_nom_minor_guard_add1
        From
            emp_gtli eg
        Where
            eg.key_id = Trim(p_key_id);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_gtli_detail;

    Procedure sp_add_emp_gtli(
        p_person_id                Varchar2,
        p_meta_id                  Varchar2,

        p_nom_name                 Varchar2,
        p_nom_add1                 Varchar2,
        p_relation                 Varchar2,
        p_nom_dob                  Date Default null,
        p_share_pcnt               Number,
        p_nom_minor_guard_name     Varchar2 Default null,
        p_nom_minor_guard_add1     Varchar2 Default null,
        p_nom_minor_guard_relation Varchar2 Default null,

        p_message_type Out         Varchar2,
        p_message_text Out         Varchar2
    ) As
        v_exists       Number;
        v_share_pcnt   Number;
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

        pkg_emp_gtli.sp_add_gtli(
            p_empno                    => v_empno,
            p_modified_by              => v_empno,
            p_nom_name                 => p_nom_name,
            p_nom_add1                 => p_nom_add1,
            p_relation                 => p_relation,
            p_nom_dob                  => p_nom_dob,
            p_share_pcnt               => p_share_pcnt,
            p_nom_minor_guard_name     => p_nom_minor_guard_name,
            p_nom_minor_guard_add1     => p_nom_minor_guard_add1,
            p_nom_minor_guard_relation => p_nom_minor_guard_relation,
            p_message_type             => p_message_type,
            p_message_text             => p_message_text
        );

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_emp_gtli;

    Procedure sp_update_emp_gtli(
        p_person_id                Varchar2,
        p_meta_id                  Varchar2,

        p_key_id                   Varchar2,
        p_nom_name                 Varchar2,
        p_nom_add1                 Varchar2,
        p_relation                 Varchar2,
        p_nom_dob                  Date Default null,
        p_share_pcnt               Number,
       p_nom_minor_guard_name     Varchar2 Default null,
        p_nom_minor_guard_add1     Varchar2 Default null,
        p_nom_minor_guard_relation Varchar2 Default null,

        p_message_type Out         Varchar2,
        p_message_text Out         Varchar2
    ) As
        v_exists       Number;
        v_share_pcnt   Number;
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

        pkg_emp_gtli.sp_update_gtli(
            p_key_id                   => p_key_id,
            p_empno                    => v_empno,
            p_modified_by              => v_empno,
            p_nom_name                 => p_nom_name,
            p_nom_add1                 => p_nom_add1,
            p_relation                 => p_relation,
            p_nom_dob                  => p_nom_dob,
            p_share_pcnt               => p_share_pcnt,
            p_nom_minor_guard_name     => p_nom_minor_guard_name,
            p_nom_minor_guard_add1     => p_nom_minor_guard_add1,
            p_nom_minor_guard_relation => p_nom_minor_guard_relation,
            p_message_type             => p_message_type,
            p_message_text             => p_message_text
        );

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee gtli already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_emp_gtli;

    Procedure sp_delete_emp_gtli(
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
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        pkg_emp_gtli.sp_delete_gtli(
            p_key_id       => p_key_id,
            p_empno        => v_empno,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        Commit;

        p_message_type := ok;
        p_message_text := 'Record deleted successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_emp_gtli;

    Procedure sp_add_4hr_emp_gtli(
        p_person_id                Varchar2,
        p_meta_id                  Varchar2,

        p_empno                    Varchar2,

        p_nom_name                 Varchar2,
        p_nom_add1                 Varchar2,
        p_relation                 Varchar2,
        p_nom_dob                  Date Default null,
        p_share_pcnt               Number,
        p_nom_minor_guard_name     Varchar2 Default null,
        p_nom_minor_guard_add1     Varchar2 Default null,
        p_nom_minor_guard_relation Varchar2 Default null,

        p_message_type Out         Varchar2,
        p_message_text Out         Varchar2
    ) As
        v_exists       Number;
        v_share_pcnt   Number;
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

        pkg_emp_gtli.sp_add_gtli(
            p_empno                    => p_empno,
            p_modified_by              => v_empno,
            p_nom_name                 => p_nom_name,
            p_nom_add1                 => p_nom_add1,
            p_relation                 => p_relation,
            p_nom_dob                  => p_nom_dob,
            p_share_pcnt               => p_share_pcnt,
            p_nom_minor_guard_name     => p_nom_minor_guard_name,
            p_nom_minor_guard_add1     => p_nom_minor_guard_add1,
            p_nom_minor_guard_relation => p_nom_minor_guard_relation,
            p_message_type             => p_message_type,
            p_message_text             => p_message_text
        );

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_4hr_emp_gtli;

    Procedure sp_update_4hr_emp_gtli(
        p_person_id                Varchar2,
        p_meta_id                  Varchar2,

        p_key_id                   Varchar2,
        p_empno                    Varchar2,
        p_nom_name                 Varchar2,
        p_nom_add1                 Varchar2,
        p_relation                 Varchar2,
        p_nom_dob                  Date Default null,
        p_share_pcnt               Number,
        p_nom_minor_guard_name     Varchar2 Default null,
        p_nom_minor_guard_add1     Varchar2 Default null,
        p_nom_minor_guard_relation Varchar2 Default null,

        p_message_type Out         Varchar2,
        p_message_text Out         Varchar2
    ) As
        v_exists       Number;
        v_share_pcnt   Number;
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

        pkg_emp_gtli.sp_update_gtli(
            p_key_id                   => p_key_id,
            p_empno                    => p_empno,
            p_modified_by              => v_empno,
            p_nom_name                 => p_nom_name,
            p_nom_add1                 => p_nom_add1,
            p_relation                 => p_relation,
            p_nom_dob                  => p_nom_dob,
            p_share_pcnt               => p_share_pcnt,
            p_nom_minor_guard_name     => p_nom_minor_guard_name,
            p_nom_minor_guard_add1     => p_nom_minor_guard_add1,
            p_nom_minor_guard_relation => p_nom_minor_guard_relation,
            p_message_type             => p_message_type,
            p_message_text             => p_message_text
        );

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee gtli already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_4hr_emp_gtli;

    Procedure sp_delete_4hr_emp_gtli(
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
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        pkg_emp_gtli.sp_delete_gtli(
            p_key_id       => p_key_id,
            p_empno        => p_empno,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        Commit;

        p_message_type := ok;
        p_message_text := 'Record deleted successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_4hr_emp_gtli;

End pkg_emp_gtli;
/
 Grant Execute On   "TCMPL_HR"."PKG_EMP_GTLI"  To "TCMPL_APP_CONFIG";