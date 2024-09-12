--------------------------------------------------------
--  DDL for Package Body PKG_RAP_OSC_HOURS
--------------------------------------------------------

Create Or Replace Package Body timecurr.pkg_rap_osc_hours As

    Procedure sp_add_orig_est_hours(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscd_id          Varchar2,
        p_yyyymm           Varchar2,
        p_orig_est_hrs     Number,
        p_cur_est_hrs      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into rap_osc_hours(osch_id, oscd_id, yyyymm, orig_est_hrs, cur_est_hrs)
        Values (dbms_random.string('X', 10), p_oscd_id, p_yyyymm, p_orig_est_hrs, p_cur_est_hrs);

        Commit;

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_orig_est_hours;

    Procedure sp_update_orig_est_hours(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_osch_id          Varchar2,
        p_orig_est_hrs     Number,
        p_cur_est_hrs      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update
            rap_osc_hours
        Set
            orig_est_hrs = p_orig_est_hrs,
            cur_est_hrs = p_cur_est_hrs
        Where
             osch_id = Trim(p_osch_id);

        Commit;

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_orig_est_hours;

    Procedure sp_update_cur_est_hours(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_osch_id          Varchar2,
        p_cur_est_hrs      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update
            rap_osc_hours
        Set
            cur_est_hrs = p_cur_est_hrs
        Where
            osch_id = Trim(p_osch_id);

        Commit;

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_cur_est_hours;

    Procedure sp_delete_hours(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_osch_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
            From rap_osc_hours
        Where
            osch_id = Trim(p_osch_id);

        Commit;

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_hours;

End pkg_rap_osc_hours;
/
Grant Execute On "TIMECURR"."PKG_RAP_OSC_HOURS" To "TCMPL_APP_CONFIG";
