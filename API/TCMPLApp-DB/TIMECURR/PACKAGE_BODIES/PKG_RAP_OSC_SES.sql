--------------------------------------------------------
--  DDL for Package Body PKG_RAP_OSC_SES
--------------------------------------------------------
 
Create Or Replace Package Body "TIMECURR"."PKG_RAP_OSC_SES" As

    Procedure sp_add_osc_ses(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscm_id          Varchar2,
        p_ses_no           Varchar2,
        p_ses_date         Date,
        p_ses_amount       Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into rap_osc_ses (oscs_id, oscm_id, ses_no, ses_date, ses_amount)
        Values (dbms_random.string('X', 10), p_oscm_id, p_ses_no, p_ses_date, p_ses_amount);

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_osc_ses;

    Procedure sp_update_osc_ses(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscs_id          Varchar2,
        p_oscm_id          Varchar2,
        p_ses_no           Varchar2,
        p_ses_date         Date,
        p_ses_amount       Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update
            rap_osc_ses
        Set
            oscm_id = p_oscm_id,
            ses_no = p_ses_no,
            ses_date = p_ses_date,
            ses_amount = p_ses_amount
        Where
            oscs_id = p_oscs_id;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_osc_ses;

    Procedure sp_delete_osc_ses(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscs_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
            From rap_osc_ses
        Where
            oscs_id = p_oscs_id;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_osc_ses;

End pkg_rap_osc_ses;
/
  Grant Execute On "TIMECURR"."PKG_RAP_OSC_SES" To "TCMPL_APP_CONFIG";