--------------------------------------------------------
--  DDL for Package Body PKG_RAP_OSC_DETAIL
--------------------------------------------------------

Create Or Replace Package Body timecurr.pkg_rap_osc_detail As

    Procedure sp_add_costcode(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_oscm_id               Varchar2,
        p_costcode              Varchar2,
        p_lock_orig_budget_desc Varchar2 Default Null,

        p_message_type Out      Varchar2,
        p_message_text Out      Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into rap_osc_detail(oscd_id, oscm_id, costcode, modified_by, modified_on, added_on)
        Values (dbms_random.string('X', 10), p_oscm_id, p_costcode, v_empno, sysdate, Case p_lock_orig_budget_desc
                                                                                          When Null Then
                                                                                              Null
                                                                                          When 'Locked' Then
                                                                                              sysdate
                                                                                      End);

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_costcode;

    Procedure sp_delete_costcode(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscd_id          Varchar2,

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
            oscd_id = Trim(p_oscd_id);

        Delete
            From rap_osc_detail
        Where
            oscd_id = Trim(p_oscd_id);

        Commit;

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_costcode;

End pkg_rap_osc_detail;
/
Grant Execute On "TIMECURR"."PKG_RAP_OSC_DETAIL" To "TCMPL_APP_CONFIG";