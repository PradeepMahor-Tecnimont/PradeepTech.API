Create Or Replace Package Body "TCMPL_HR"."PKG_EMP_LOCK_STATUS" As

    Procedure sp_add_emp_lock_status(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_empno              Varchar2,
        p_is_login_open      Number,
        p_is_primary_open    Number,
        p_is_nomination_open Number,
        p_is_mediclaim_open  Number,
        p_is_aadhaar_open    Number,
        p_is_passport_open   Number,
        p_is_gtli_open       Number,

        p_message_type Out   Varchar2,
        p_message_text Out   Varchar2
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
            emp_lock_status
        Where
            Trim(upper(empno)) = Trim(upper(p_empno));

        If v_exists = 0 Then
            Insert Into emp_lock_status
            (
                empno,
                prim_lock_open,
                fmly_lock_open,
                nom_lock_open,
                login_lock_open,
                adhaar_lock,
                pp_lock,
                modified_on,
                gtli_lock
            )

            Values
            (
                p_empno,
                p_is_primary_open,
                p_is_mediclaim_open,
                p_is_nomination_open,
                p_is_login_open,
                p_is_aadhaar_open,
                p_is_passport_open,
                sysdate,
                p_is_gtli_open
            );

            Commit;

            p_message_type := ok;
            p_message_text := 'Employee lock status added successfully..';
        Else
            p_message_type := not_ok;
            p_message_text := 'Employee lock status already exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_emp_lock_status;

    Procedure sp_update_new_joinees(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Insert Into emp_lock_status(
            empno,
            prim_lock_open,
            fmly_lock_open,
            nom_lock_open,
            modified_on,
            login_lock_open,
            adhaar_lock,
            pp_lock,
            gtli_lock,
            secondary_lock
        )
        Select
            empno,
            1       prim,
            1       fmly,
            1       nom,
            sysdate modi,
            1       login,
            1       adhaar,
            1       pp,
            1       gtli,
            1       secon
        From
            vu_emplmast
        Where
            status = 1
            And emptype In (
                Select
                    emptype
                From
                    emp_details_include_emptype
            )
            And empno Not In (
                Select
                    empno
                From
                    emp_lock_status
            );

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_update_emp_lock_status(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_empno              Varchar2,
        p_is_primary_open    Number,
        p_is_secondary_open  Number,

        p_is_nomination_open Number,
        p_is_mediclaim_open  Number,
        p_is_aadhaar_open    Number,
        p_is_passport_open   Number,
        p_is_gtli_open       Number,

        p_message_type Out   Varchar2,
        p_message_text Out   Varchar2
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
            emp_lock_status
        Where
            empno = p_empno;

        If v_exists = 1 Then

            Update
                emp_lock_status
            Set
                prim_lock_open = p_is_primary_open,
                secondary_lock = p_is_secondary_open,
                fmly_lock_open = p_is_mediclaim_open,
                nom_lock_open = p_is_nomination_open,
                adhaar_lock = p_is_aadhaar_open,
                pp_lock = p_is_passport_open,
                modified_on = sysdate,
                gtli_lock = p_is_gtli_open
            Where
                empno = p_empno;

            Commit;

            p_message_type := ok;
            p_message_text := 'Employee lock status updated successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Employee lock status exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee lock status already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_emp_lock_status;

    Procedure sp_delete_emp_lock_status(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

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

        Delete
            From emp_lock_status
        Where
            empno = p_empno;

        Commit;

        p_message_type := ok;
        p_message_text := 'Record deleted successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_emp_lock_status;

    Procedure sp_bulk_update(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_is_primary_open    Number Default Null,
        p_is_secondary_open  Number Default Null,

        p_is_nomination_open Number Default Null,
        p_is_mediclaim_open  Number Default Null,
        p_is_aadhaar_open    Number Default Null,
        p_is_passport_open   Number Default Null,
        p_is_gtli_open       Number Default Null,

        p_message_type Out   Varchar2,
        p_message_text Out   Varchar2
    ) As
        v_msg_type Varchar2(2);
        v_msg_text Varchar2(1000);
    Begin
        /*
            sp_update_new_joinees(
                p_message_type => v_msg_type,
                p_message_text => v_msg_text
            );
        */
        If p_is_primary_open Is Not Null Then
            Update
                emp_lock_status
            Set
                prim_lock_open = p_is_primary_open;
        End If;

        If p_is_secondary_open Is Not Null Then
            Update
                emp_lock_status
            Set
                secondary_lock = p_is_secondary_open;
        End If;

        If p_is_nomination_open Is Not Null Then
            Update
                emp_lock_status
            Set
                nom_lock_open = p_is_nomination_open;
        End If;

        If p_is_mediclaim_open Is Not Null Then
            Update
                emp_lock_status
            Set
                fmly_lock_open = p_is_mediclaim_open;
        End If;

        If p_is_aadhaar_open Is Not Null Then
            Update
                emp_lock_status
            Set
                adhaar_lock = p_is_aadhaar_open;
        End If;

        If p_is_passport_open Is Not Null Then
            Update
                emp_lock_status
            Set
                pp_lock = p_is_passport_open;
        End If;
        /*
                If p_is_gtli_open Is Not Null Then
                    Update
                        emp_lock_status
                    Set
                        gtli_lock = p_is_gtli_open;
                End If;
        */
        Commit;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;
End pkg_emp_lock_status;
/
 Grant Execute On   "TCMPL_HR"."PKG_EMP_LOCK_STATUS"  To "TCMPL_APP_CONFIG";