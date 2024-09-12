Create Or Replace Package Body "TCMPL_HR"."EMP_GEN_INFO_HR" As

    Procedure sp_nomination_status(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

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
            emp_nomination_status
        Where
            empno = p_empno;

        If v_exists = 1 Then

            Update
                emp_nomination_status
            Set
                submitted = ok,
                modified_by = v_empno,
                modified_on = sysdate
            Where
                empno = p_empno;
            Commit;

            p_message_type := ok;
            p_message_text := 'Nomination status updated successfully.';

        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Nomination status already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_nomination_status;

    Procedure sp_gtli_status(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

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
            emp_nomination_status
        Where
            empno = p_empno;

        If v_exists = 1 Then

            Update
                emp_gtli_status
            Set
                hr_verified = ok,
                modified_by = v_empno,
                modified_on = sysdate
            Where
                empno = p_empno;
            Commit;

            p_message_type := ok;
            p_message_text := 'Nomination status updated successfully.';

        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Nomination status already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_gtli_status;

End emp_gen_info_hr;
/
 Grant Execute On   "TCMPL_HR"."EMP_GEN_INFO_HR"  To "TCMPL_APP_CONFIG";