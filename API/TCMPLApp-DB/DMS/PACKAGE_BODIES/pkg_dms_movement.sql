Create Or Replace Package Body dms.pkg_dms_movement As

    
    Procedure sp_movement_request_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_session_id       Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists             Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'No employee found';
        End If;
        Select
            Count(*)
        Into
            v_exists
        From
            dm_assetmove_tran
        Where
            Trim(movereqnum) = Trim(p_session_id);

        If v_exists > 0 Then
            Delete
                From dm_sourcedesk
            Where
                Trim(sid) = Trim(p_session_id);

            Delete
                From dm_targetdesk
            Where
                Trim(sid) = Trim(p_session_id);

            Delete
                From dm_assetadd
            Where
                Trim(unqid) = Trim(p_session_id);

            Delete
                From dm_assetmove_tran
            Where
                Trim(movereqnum) = Trim(p_session_id);

            Delete
                From dm_desklock
            Where
                Trim(unqid) = Trim(p_session_id);

            Commit;
            p_message_type := 'OK';
            p_message_text := 'Movement request deleted.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Movement request does not found !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_movement_request_delete;

    Procedure sp_movement_desk_select(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_desk_for         Varchar2,
        p_session_id       Varchar2,
        p_desk_list        Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        If length(p_desk_list) > 0 And length(p_session_id) > 0 Then
            For i In (
                Select
                    Trim(regexp_substr(p_desk_list, '[^!#!]+', 1, level)) deskid
                From
                    dual
                Connect By
                    level <= regexp_count(p_desk_list, '!#!') + 1
            )
            Loop
                If upper(p_desk_for) = 'SOURCE' Then
                    Insert Into dm_sourcedesk (
                        sid,
                        sdate,
                        deskid
                    )
                    Values (
                        p_session_id,
                        sysdate,
                        i.deskid
                    );

                End If;

                If upper(p_desk_for) = 'TARGET' Then
                    Insert Into dm_targetdesk (
                        sid,
                        sdate,
                        deskid
                    )
                    Values (
                        p_session_id,
                        sysdate,
                        i.deskid
                    );

                End If;
                --dbms_output.put_line(i.deskid);
            End Loop;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Values not recognised !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_movement_desk_select;

    Procedure sp_source_desk_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_session_id       Varchar2,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists             Number;
        v_movereq_exists     Number;
        v_desk_master_exists Number;
        v_desklock_exists    Number;
        v_add_exists         Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c_assets             Sys_Refcursor;
        c_empno              Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            p_message_type := 'KO';
            p_message_text := 'No employee found';
        End If;
        If length(p_deskid) > 0 Then
            For i In (
                Select
                    Trim(regexp_substr(p_deskid, '[^,]+', 1, level)) source_desk
                From
                    dual
                Connect By
                    level <= regexp_count(p_deskid, ',') + 1
            )
            Loop
                Select
                    Count(*)
                Into
                    v_exists
                From
                    dm_sourcedesk
                Where
                    Trim(sid)        = Trim(p_session_id)
                    And Trim(deskid) = Trim(i.source_desk);

                If v_exists = 0 Then
                    Insert Into dm_sourcedesk (
                        sid,
                        deskid,
                        sdate
                    )
                    Values (
                        Trim(p_session_id),
                        Trim(i.source_desk),
                        sysdate
                    );

                    /* Create movement request with dummy emplno / desk values */

                    Select
                        Count(*)
                    Into
                        v_movereq_exists
                    From
                        dm_assetmove_tran
                    Where
                        movereqnum = Trim(p_session_id);

                    If v_movereq_exists = 0 Then
                        Insert Into dm_assetmove_tran (
                            movereqnum,
                            movereqdate,
                            empno,
                            currdesk,
                            targetdesk
                        )
                        Values (
                            Trim(p_session_id),
                            sysdate,
                            'ABCDE',
                            'XYZ001',
                            'XYZ001'
                        );

                    End If;

                    /* Lock desk - desk master table */

                    Update
                        dm_deskmaster
                    Set
                        isblocked = 1,
                        remarks = Trim(p_session_id)
                    Where
                        Trim(deskid) = Trim(i.source_desk);

                End If;

            End Loop;

            Commit;
            p_message_type := 'OK';
            p_message_text := 'Source desk(s) selected.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Source desk not selected !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_source_desk_add;

    Procedure sp_source_desk_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_session_id       Varchar2,
        p_desk_id          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists             Number;
        v_desklock_exists    Number;
        v_desk_master_exists Number;
        v_move_req_exists    Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            p_message_type := 'KO';
            p_message_text := 'No employee found';
        End If;
        Select
            Count(*)
        Into
            v_move_req_exists
        From
            dm_assetmove_tran
        Where
            Trim(movereqnum)        = Trim(p_session_id)
            And (Trim(currdesk)     = Trim(p_desk_id)
                Or Trim(targetdesk) = Trim(p_desk_id));

        If v_move_req_exists = 0 Then
            Select
                Count(*)
            Into
                v_exists
            From
                dm_sourcedesk
            Where
                Trim(sid)        = Trim(p_session_id)
                And Trim(deskid) = Trim(p_desk_id);

            If v_exists = 1 Then
                Delete
                    From dm_sourcedesk
                Where
                    Trim(sid)        = Trim(p_session_id)
                    And Trim(deskid) = Trim(p_desk_id);

                /* Lock desk - desk master table */

                Select
                    nvl(isblocked, 0)
                Into
                    v_desk_master_exists
                From
                    dm_deskmaster
                Where
                    Trim(deskid)      = Trim(p_desk_id)
                    And Trim(remarks) = Trim(p_session_id);

                If v_desk_master_exists = 1 Then
                    Update
                        dm_deskmaster
                    Set
                        isblocked = 0,
                        remarks = ''
                    Where
                        Trim(deskid)      = Trim(p_desk_id)
                        And Trim(remarks) = Trim(p_session_id);

                End If;

                Commit;
                p_message_type := 'OK';
                p_message_text := 'Source desk deleted.';
            Else
                p_message_type := 'KO';
                p_message_text := 'Source desk does not found !!!';
            End If;

        Else
            p_message_type := 'KO';
            p_message_text := 'Assigned desk can not be deleted !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_source_desk_delete;

    Procedure sp_target_desk_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_session_id       Varchar2,
        p_desk_id          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists             Number;
        v_movereq_exists     Number;
        v_employee_exists    Number;
        v_desk_master_exists Number;
        v_desklock_exists    Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            p_message_type := 'KO';
            p_message_text := 'No employee found';
        End If;
        If length(p_desk_id) > 0 Then
            For i In (
                Select
                    Trim(regexp_substr(p_desk_id, '[^,]+', 1, level)) target_desk
                From
                    dual
                Connect By
                    level <= regexp_count(p_desk_id, ',') + 1
            )
            Loop
                Select
                    Count(*)
                Into
                    v_exists
                From
                    dm_targetdesk
                Where
                    Trim(sid)        = Trim(p_session_id)
                    And Trim(deskid) = Trim(i.target_desk);

                If v_exists = 0 Then
                    Insert Into dm_targetdesk (
                        sid,
                        deskid,
                        sdate
                    )
                    Values (
                        Trim(p_session_id),
                        Trim(i.target_desk),
                        sysdate
                    );

                    /* Create movement request with dummy emplno / desk values */

                    Select
                        Count(*)
                    Into
                        v_movereq_exists
                    From
                        dm_assetmove_tran
                    Where
                        movereqnum = Trim(p_session_id);

                    If v_movereq_exists = 0 Then
                        Insert Into dm_assetmove_tran (
                            movereqnum,
                            movereqdate,
                            empno,
                            currdesk,
                            targetdesk
                        )
                        Values (
                            Trim(p_session_id),
                            sysdate,
                            'ABCDE',
                            'XYZ001',
                            'XYZ001'
                        );

                    End If;

                    /* Lock desk - desk master table */

                    Update
                        dm_deskmaster
                    Set
                        isblocked = 1,
                        remarks = Trim(p_session_id)
                    Where
                        Trim(deskid) = Trim(i.target_desk);

                End If;

            End Loop;

            p_message_type := 'OK';
            p_message_text := 'Target desk(s) selected.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Target desk(s) not selected !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_target_desk_add;

    Procedure sp_target_desk_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_session_id       Varchar2,
        p_desk_id          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists             Number;
        v_desklock_exists    Number;
        v_desk_master_exists Number;
        v_move_req_exists    Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            p_message_type := 'KO';
            p_message_text := 'No employee found';
        End If;
        Select
            Count(*)
        Into
            v_move_req_exists
        From
            dm_assetmove_tran
        Where
            Trim(movereqnum)        = Trim(p_session_id)
            And (Trim(currdesk)     = Trim(p_desk_id)
                Or Trim(targetdesk) = Trim(p_desk_id));

        If v_move_req_exists = 0 Then
            Select
                Count(deskid)
            Into
                v_exists
            From
                dm_targetdesk
            Where
                Trim(sid)        = Trim(p_session_id)
                And Trim(deskid) = Trim(p_desk_id);

            If v_exists = 1 Then
                Delete
                    From dm_targetdesk
                Where
                    Trim(sid)        = Trim(p_session_id)
                    And Trim(deskid) = Trim(p_desk_id);

                /* Lock desk - desk master table */

                Select
                    nvl(isblocked, 0)
                Into
                    v_desk_master_exists
                From
                    dm_deskmaster
                Where
                    Trim(deskid)      = Trim(p_desk_id)
                    And Trim(remarks) = Trim(p_session_id);

                If v_desk_master_exists = 1 Then
                    Update
                        dm_deskmaster
                    Set
                        isblocked = 0,
                        remarks = ''
                    Where
                        Trim(deskid)      = Trim(p_desk_id)
                        And Trim(remarks) = Trim(p_session_id);

                End If;

                Commit;
                p_message_type := 'OK';
                p_message_text := 'Target desk deleted.';
            Else
                p_message_type := 'KO';
                p_message_text := 'Target desk does not found !!!';
            End If;

        Else
            p_message_type := 'KO';
            p_message_text := 'Assigned desk can not be deleted !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_target_desk_delete;

    Procedure sp_desk_assignment_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_session_id       Varchar2,
        p_desk_id_old      Varchar2,
        p_desk_id          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists              Number;
        v_add_exists          Number;
        v_move_req_exists     Number;
        v_empno               Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_message_type        Varchar2(2);
        v_message_text        Varchar2(200);
        v_desk_disable_exists Number;
        v_desk_visible_exists Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            p_message_type := 'KO';
            p_message_text := 'No employee found';
        End If;

        -- Current desk
        For rec In (
            Select
                empno
            From
                dm_usermaster
            Where
                Trim(deskid) = Trim(p_desk_id_old)
        )
        Loop
            -- Movement requets
            v_move_req_exists := -1;
            Select
                Count(*)
            Into
                v_move_req_exists
            From
                dm_assetmove_tran
            Where
                Trim(movereqnum)     = Trim(p_session_id)
                And Trim(currdesk)   = Trim(p_desk_id_old)
                And Trim(targetdesk) = Trim(p_desk_id)
                And empno            = rec.empno;

            If v_move_req_exists = 0 Then
                Insert Into dm_assetmove_tran (
                    movereqnum,
                    movereqdate,
                    empno,
                    currdesk,
                    targetdesk,
                    assetflag,
                    empflag,
                    it_apprl
                )
                Values (
                    Trim(p_session_id),
                    sysdate,
                    rec.empno,
                    Trim(p_desk_id_old),
                    Trim(p_desk_id),
                    1,
                    1,
                    0
                );

            End If;

            -- Desk lock
            v_exists          := -1;
            Select
                Count(*)
            Into
                v_exists
            From
                dm_desklock
            Where
                Trim(unqid)      = Trim(p_session_id)
                And Trim(deskid) = Trim(p_desk_id_old)
                And targetdesk   = 0
                And upper(empno) = upper(rec.empno);

            If v_exists = 0 Then
                Insert Into dm_desklock (
                    unqid,
                    empno,
                    deskid,
                    targetdesk
                )
                Values (
                    Trim(p_session_id),
                    Trim(rec.empno),
                    Trim(p_desk_id_old),
                    1
                );

            End If;

            For rec_asset In (
                Select
                    assetid
                From
                    dm_deskallocation
                Where
                    Trim(deskid) = Trim(p_desk_id_old)
            )
            Loop
                -- Add assets
                v_add_exists := -1;
                Select
                    Count(*)
                Into
                    v_add_exists
                From
                    dm_assetadd
                Where
                    Trim(unqid)       = Trim(p_session_id)
                    And Trim(deskid)  = Trim(p_desk_id)
                    And Trim(assetid) = Trim(rec_asset.assetid)
                    And empno         = rec.empno;

                If v_add_exists = 0 Then
                    Insert Into dm_assetadd (
                        unqid,
                        deskid,
                        assetid,
                        empno,
                        action_type,
                        action_date
                    )
                    Values (
                        Trim(p_session_id),
                        Trim(p_desk_id),
                        Trim(rec_asset.assetid),
                        rec.empno,
                        5,
                        sysdate
                    );

                End If;

            End Loop;

        End Loop;

        -- Disable flexi status if desk is FLEXI
        Select
            Count(keyid)
        Into
            v_desk_visible_exists
        From
            (
                Select
                    keyid,
                    Dense_Rank() Over(Order By created_on Desc) rn
                From
                    dm_desk_flexi_to_dms
                Where
                    deskid        = p_desk_id_old
                    And isvisible = 1
            )
        Where
            rn = 1;

        If v_desk_visible_exists = 1 Then
            pkg_dms_movement.sp_toggle_flexi_visible_status(p_person_id => p_person_id, p_meta_id => p_meta_id, p_deskid =>
            p_desk_id_old,
                                                            p_action_type => 'DISBALE',
                                                            p_message_type => v_message_type, p_message_text => v_message_text);
        End If;

        -- Tartget desk

        For rec In (
            Select
                empno
            From
                dm_usermaster
            Where
                Trim(deskid) = Trim(p_desk_id)
        )
        Loop
            -- Desk lock
            v_exists := -1;
            Select
                Count(*)
            Into
                v_exists
            From
                dm_desklock
            Where
                Trim(unqid)      = Trim(p_session_id)
                And Trim(deskid) = Trim(p_desk_id)
                And targetdesk   = 1
                And upper(empno) = upper(rec.empno);

            If v_exists = 0 Then
                Insert Into dm_desklock (
                    unqid,
                    empno,
                    deskid,
                    targetdesk
                )
                Values (
                    Trim(p_session_id),
                    Trim(rec.empno),
                    Trim(p_desk_id),
                    0
                );

            End If;

        End Loop;

        -- Disable flexi status if desk is FLEXI
        Select
            Count(keyid)
        Into
            v_desk_visible_exists
        From
            (
                Select
                    keyid,
                    Dense_Rank() Over(Order By created_on Desc) rn
                From
                    dm_desk_flexi_to_dms
                Where
                    deskid        = p_desk_id
                    And isvisible = 1
            )
        Where
            rn = 1;

        If v_desk_visible_exists = 1 Then
            pkg_dms_movement.sp_toggle_flexi_visible_status(p_person_id => p_person_id, p_meta_id => p_meta_id, p_deskid =>
            p_desk_id,
                                                            p_action_type => 'DISBALE',
                                                            p_message_type => v_message_type, p_message_text => v_message_text);
        End If;

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Desk assignment completed !!';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_desk_assignment_add;

    Procedure sp_desk_assignment_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_session_id       Varchar2,
        p_deskid_old       Varchar2,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno               Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_message_type        Varchar2(2);
        v_message_text        Varchar2(200);
        v_desk_disable_exists Number;
        v_desk_visible_exists Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            p_message_type := 'KO';
            p_message_text := 'No employee found';
        End If;

        -- Movement request

        Delete
            From dm_assetmove_tran
        Where
            movereqnum     = Trim(p_session_id)
            And currdesk   = Trim(p_deskid_old)
            And targetdesk = Trim(p_deskid);

        -- Current desk

        Update
            dm_deskmaster
        Set
            isblocked = 0,
            remarks = ''
        Where
            Trim(deskid)      = Trim(p_deskid)
            And Trim(remarks) = Trim(p_session_id);

        Delete
            From dm_desklock
        Where
            Trim(unqid)      = Trim(p_session_id)
            And Trim(deskid) = Trim(p_deskid)
            And targetdesk   = 0;

        Delete
            From dm_assetadd
        Where
            Trim(unqid)      = Trim(p_session_id)
            And Trim(deskid) = Trim(p_deskid);

        -- Visible flexi status if desk is FLEXI
        Select
            Count(keyid)
        Into
            v_desk_disable_exists
        From
            (
                Select
                    keyid,
                    Dense_Rank() Over(Order By created_on Desc) rn
                From
                    dm_desk_flexi_to_dms
                Where
                    deskid        = p_deskid_old
                    And isvisible = 0
            )
        Where
            rn = 1;

        If v_desk_disable_exists = 1 Then
            pkg_dms_movement.sp_toggle_flexi_visible_status(p_person_id => p_person_id, p_meta_id => p_meta_id, p_deskid =>
            p_deskid_old,
                                                            p_action_type => 'VISIBLE',
                                                            p_message_type => v_message_type, p_message_text => v_message_text);
        End If;

        -- Tartget desk

        Update
            dm_deskmaster
        Set
            isblocked = 0,
            remarks = ''
        Where
            Trim(deskid)      = Trim(p_deskid_old)
            And Trim(remarks) = Trim(p_session_id);

        Delete
            From dm_desklock
        Where
            Trim(unqid)      = Trim(p_session_id)
            And Trim(deskid) = Trim(p_deskid_old)
            And targetdesk   = 1;

        Delete
            From dm_assetadd
        Where
            Trim(unqid)      = Trim(p_session_id)
            And Trim(deskid) = Trim(p_deskid_old);

        -- Visible flexi status if desk is FLEXI
        Select
            Count(keyid)
        Into
            v_desk_disable_exists
        From
            (
                Select
                    keyid,
                    Dense_Rank() Over(Order By created_on Desc) rn
                From
                    dm_desk_flexi_to_dms
                Where
                    deskid        = p_deskid
                    And isvisible = 0
            )
        Where
            rn = 1;

        If v_desk_disable_exists = 1 Then
            pkg_dms_movement.sp_toggle_flexi_visible_status(p_person_id => p_person_id, p_meta_id => p_meta_id, p_deskid =>
            p_deskid,
                                                            p_action_type => 'VISIBLE',
                                                            p_message_type => v_message_type, p_message_text => v_message_text);
        End If;

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Desk assignment deleted !!';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_desk_assignment_delete;

    Procedure sp_asset_assignment_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_session_id       Varchar2,
        p_deskid_old       Varchar2,
        p_movetype         Varchar2,
        p_desk_id          Varchar2,
        p_asset_id         Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_desklock_exists    Number;
        v_exists_req         Number;
        v_add_exists         Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            p_message_type := 'KO';
            p_message_text := 'No employee found';
        End If;

        -- Current desk
        If p_movetype = 'A' Then
            For rec In (
                Select
                    empno
                From
                    dm_usermaster
                Where
                    Trim(deskid) = Trim(p_deskid_old)
            )
            Loop
                /* Desk lock */
                Select
                    Count(*)
                Into
                    v_desklock_exists
                From
                    dm_desklock
                Where
                    Trim(unqid)      = Trim(p_session_id)
                    And Trim(deskid) = Trim(p_deskid_old)
                    And Trim(empno)  = Trim(rec.empno);

                If v_desklock_exists = 0 Then
                    Insert Into dm_desklock (
                        unqid,
                        empno,
                        deskid,
                        targetdesk
                    )
                    Values (
                        Trim(p_session_id),
                        Trim(rec.empno),
                        Trim(p_deskid_old),
                        1
                    );

                End If;

                /* Asset add */
                Select
                    Count(*)
                Into
                    v_add_exists
                From
                    dm_assetadd
                Where
                    Trim(unqid)       = Trim(p_session_id)
                    And Trim(deskid)  = Trim(p_desk_id)
                    And Trim(assetid) = Trim(p_asset_id)
                    And Trim(empno)   = Trim(rec.empno);

                If v_add_exists = 0 Then
                    Insert Into dm_assetadd (
                        unqid,
                        deskid,
                        assetid,
                        empno,
                        action_type,
                        action_date
                    )
                    Values (
                        Trim(p_session_id),
                        Trim(p_desk_id),
                        Trim(p_asset_id),
                        Trim(rec.empno),
                        5,
                        sysdate
                    );

                End If;

                /* Move request */
                Select
                    Count(*)
                Into
                    v_exists_req
                From
                    dm_assetmove_tran
                Where
                    Trim(movereqnum)     = Trim(p_session_id)
                    And upper(empno)     = Trim(rec.empno)
                    And Trim(currdesk)   = Trim(p_deskid_old)
                    And Trim(targetdesk) = Trim(p_desk_id);

                If v_exists_req = 0 Then
                    Insert Into dm_assetmove_tran (
                        movereqnum,
                        movereqdate,
                        empno,
                        currdesk,
                        targetdesk,
                        assetflag,
                        it_apprl
                    )
                    Values (
                        Trim(p_session_id),
                        sysdate,
                        Trim(rec.empno),
                        Trim(p_deskid_old),
                        Trim(p_desk_id),
                        1,
                        0
                    );

                Else
                    Update
                        dm_assetmove_tran
                    Set
                        assetflag = 1
                    Where
                        Trim(movereqnum)     = Trim(p_session_id)
                        And upper(empno)     = Trim(rec.empno)
                        And Trim(currdesk)   = Trim(p_deskid_old)
                        And Trim(targetdesk) = Trim(p_desk_id);

                End If;

            End Loop;
        End If;

        If p_movetype = 'E' Then
            /* Desk lock */
            Select
                Count(*)
            Into
                v_desklock_exists
            From
                dm_desklock
            Where
                Trim(unqid)      = Trim(p_session_id)
                And Trim(deskid) = Trim(p_deskid_old)
                And Trim(empno)  = Trim(p_asset_id);

            If v_desklock_exists = 0 Then
                Insert Into dm_desklock (
                    unqid,
                    empno,
                    deskid,
                    targetdesk
                )
                Values (
                    Trim(p_session_id),
                    Trim(p_asset_id),
                    Trim(p_deskid_old),
                    1
                );

            End If;

            /* Move request */
            Select
                Count(*)
            Into
                v_exists_req
            From
                dm_assetmove_tran
            Where
                Trim(movereqnum)     = Trim(p_session_id)
                And upper(empno)     = Trim(p_asset_id)
                And Trim(currdesk)   = Trim(p_deskid_old)
                And Trim(targetdesk) = Trim(p_desk_id);

            If v_exists_req = 0 Then
                Insert Into dm_assetmove_tran (
                    movereqnum,
                    movereqdate,
                    empno,
                    currdesk,
                    targetdesk,
                    empflag,
                    it_apprl
                )
                Values (
                    Trim(p_session_id),
                    sysdate,
                    Trim(p_asset_id),
                    Trim(p_deskid_old),
                    Trim(p_desk_id),
                    1,
                    0
                );

            Else
                Update
                    dm_assetmove_tran
                Set
                    empflag = 1
                Where
                    Trim(movereqnum)     = Trim(p_session_id)
                    And upper(empno)     = Trim(p_asset_id)
                    And Trim(currdesk)   = Trim(p_deskid_old)
                    And Trim(targetdesk) = Trim(p_desk_id);

            End If;

        End If;

        p_message_type := 'OK';
        p_message_text := 'Asset assignment completed !!';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_asset_assignment_add;

    Procedure sp_asset_assignment_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_session_id       Varchar2,
        p_deskid_old       Varchar2,
        p_deskid           Varchar2,
        p_asset_id         Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists             Number;
        v_add_exists         Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            p_message_type := 'KO';
            p_message_text := 'No employee found';
        End If;

        -- Current desk

        Delete
            From dm_assetadd
        Where
            Trim(unqid)       = Trim(p_session_id)
            And Trim(deskid)  = Trim(p_deskid_old)
            And Trim(assetid) = Trim(p_asset_id);

        Select
            Count(*)
        Into
            v_exists
        From
            dm_assetadd
        Where
            Trim(unqid)      = Trim(p_session_id)
            And Trim(deskid) = Trim(p_deskid_old);

        If v_add_exists = 0 Then
            Delete
                From dm_desklock
            Where
                Trim(unqid)      = Trim(p_session_id)
                And Trim(deskid) = Trim(p_deskid_old)
                And targetdesk   = 0;

        End If;

        -- Tartget desk

        Delete
            From dm_assetadd
        Where
            Trim(unqid)       = Trim(p_session_id)
            And Trim(deskid)  = Trim(p_deskid)
            And Trim(assetid) = Trim(p_asset_id);

        Select
            Count(*)
        Into
            v_exists
        From
            dm_assetadd
        Where
            Trim(unqid)      = Trim(p_session_id)
            And Trim(deskid) = Trim(p_deskid);

        If v_add_exists = 0 Then
            Delete
                From dm_desklock
            Where
                Trim(unqid)      = Trim(p_session_id)
                And Trim(deskid) = Trim(p_deskid)
                And targetdesk   = 1;

        End If;

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Asset assignment deleted !!';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_asset_assignment_delete;

    Procedure sp_desk_assignment_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_session_id       Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_curr_history_exists   Number;
        v_target_history_exists Number;
        v_allocation_exists     Number;
        v_user_exists           Number;
        v_message_type          Varchar2(2);
        v_message_text          Varchar2(200);
        v_empno                 Varchar2(5);
        v_desk_list             Varchar2(2000);
        e_employee_not_found    Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'No employee found';
        End If;

        /* - - - - - - - - - - - delete dummy record - - - - - - - - - - - */
        Delete
            From dm_assetmove_tran
        Where
            Trim(movereqnum)     = Trim(p_session_id)
            And upper(empno)     = 'ABCDE'
            And Trim(currdesk)   = 'XYZ001'
            And Trim(targetdesk) = 'XYZ001';

        /* - - - - - - - - - - - Updating movement history - - - - - - - - - - - */
        For rec_history In (
            Select
                movereqnum,
                empno,
                currdesk,
                targetdesk,
                assetflag,
                empflag
            From
                dm_assetmove_tran
            Where
                Trim(movereqnum) = Trim(p_session_id)
        )
        Loop
            -- Update current desk history
            sp_update_move_history(trim(p_session_id), rec_history.empno, trim(rec_history.currdesk), 'C');

            -- Update target desk history
            sp_update_move_history(trim(p_session_id), rec_history.empno, trim(rec_history.targetdesk), 'T');

        End Loop;

        /* - - - - - - - - - - - Deleting desk allocation - - - - - - - - - - - */
        For rec_del In (
            Select
                movereqnum,
                empno,
                currdesk,
                targetdesk,
                assetflag,
                empflag
            From
                dm_assetmove_tran
            Where
                Trim(movereqnum) = Trim(p_session_id)
        )
        Loop
            -- Only asset moevement
            If rec_del.assetflag = 1 And rec_del.empflag = 0 Then
                -- Delete Existing Desk Allocation (Current Desk)
                Delete
                    From dm_deskallocation
                Where
                    deskid = Trim(rec_del.currdesk);
                -- Delete Existing Desk Allocation (Target Desk)
                Delete
                    From dm_deskallocation
                Where
                    deskid = Trim(rec_del.targetdesk);

            End If;

            -- Only employee moevement
            If rec_del.assetflag = 0 And rec_del.empflag = 1 Then
                -- Delete from Usermaster (Current Desk)
                Delete
                    From dm_usermaster
                Where
                    deskid    = Trim(rec_del.currdesk)
                    And empno = rec_del.empno;
                -- Delete from Usermaster (Target Desk)
                Delete
                    From dm_usermaster
                Where
                    deskid = Trim(rec_del.targetdesk);

            End If;

            -- Asset and employee moevement
            If rec_del.assetflag = 1 And rec_del.empflag = 1 Then
                -- Delete Existing Desk Allocation (Current Desk)
                Delete
                    From dm_deskallocation
                Where
                    deskid = Trim(rec_del.currdesk);
                -- Delete Existing Desk Allocation (Target Desk)
                Delete
                    From dm_deskallocation
                Where
                    deskid = Trim(rec_del.targetdesk);
                -- Delete from Usermaster (Current Desk)
                Delete
                    From dm_usermaster
                Where
                    deskid = Trim(rec_del.currdesk);
                -- Delete from Usermaster (Target Desk)
                Delete
                    From dm_usermaster
                Where
                    deskid = Trim(rec_del.targetdesk);

            End If;

        End Loop;

        /* - - - - - - - - - - - Update transaction in database - - - - - - - - - - - */
        For rec_tran In (
            Select
                movereqnum,
                empno,
                currdesk,
                targetdesk,
                assetflag,
                empflag
            From
                dm_assetmove_tran
            Where
                Trim(movereqnum) = Trim(p_session_id)
        )
        Loop
            -- Asset moevement
            If rec_tran.assetflag = 1 Then
                For rec_asset1 In (
                    Select
                        unqid,
                        deskid,
                        assetid,
                        empno
                    From
                        dm_assetadd
                    Where
                        Trim(unqid)      = Trim(p_session_id)
                        And upper(empno) = upper(rec_tran.empno)
                        And Trim(deskid) = Trim(rec_tran.targetdesk)
                )
                Loop
                    v_allocation_exists := 0;
                    Select
                        Count(*)
                    Into
                        v_allocation_exists
                    From
                        dm_deskallocation
                    Where
                        Trim(deskid)      = Trim(rec_asset1.deskid)
                        And Trim(assetid) = Trim(rec_asset1.assetid);

                    /* Update desk allocation */
                    If v_allocation_exists = 0 Then
                        Insert Into dm_deskallocation (
                            deskid,
                            assetid
                        )
                        Values (
                            Trim(rec_asset1.deskid),
                            Trim(rec_asset1.assetid)
                        );

                    End If;

                End Loop;
            End If;

            -- Employee moevement
            If rec_tran.empflag = 1 Then
                Select
                    Count(*)
                Into
                    v_user_exists
                From
                    dm_usermaster
                Where
                    Trim(empno)      = Trim(rec_tran.empno)
                    And Trim(deskid) = Trim(rec_tran.targetdesk);

                /* Update desk user */
                If v_user_exists = 0 Then
                    Insert Into dm_usermaster (
                        empno,
                        deskid,
                        costcode
                    )
                    Values (
                        Trim(rec_tran.empno),
                        Trim(rec_tran.targetdesk),
                        pkg_dms_general.fn_get_assign_costcode(Trim(rec_tran.empno))
                    );

                End If;

            End If;

            -- Add in exclude employee list
            /*sp_update_exclude_emp_from_moc5(p_person_id => p_person_id, p_meta_id => p_meta_id, p_deskid => Trim(rec_tran.targetdesk)
            , p_empno => Trim(rec_tran.empno),
                                           p_message_type => v_message_type, p_message_text => v_message_text);*/

            -- Set flexi booking for next 2 days
            /*sp_create_flexi_booking(p_person_id => p_person_id, p_meta_id => p_meta_id, p_deskid => Trim(rec_tran.targetdesk), p_empno => Trim
            (rec_tran.empno),
                                   p_message_type => v_message_type, p_message_text => v_message_text);*/

            -- change area based on zone
            /*sp_set_zone_for_area(p_person_id => p_person_id, p_meta_id => p_meta_id, p_deskid => Trim(rec_tran.targetdesk), p_message_type => v_message_type
            ,
                                p_message_text => v_message_text);*/
                                
            if length(v_desk_list) = 0 then
                v_desk_list := Trim(rec_tran.targetdesk);
            else
                v_desk_list := v_desk_list || ',' || Trim(rec_tran.targetdesk);
            end if;          

        End Loop;
        
        -- Flexi booking 
       
            begin
                desk_book.pkg_flexi_desk_to_dms.sp_move_to_flexi_json(
                    p_person_id        => p_person_id,
                    p_meta_id          => p_meta_id,
                    p_parameter_json   => v_desk_list,
                    p_message_type     => v_message_type,
                    p_message_text     => v_message_text
                );
            end;
       
        
        For rec_clear In (
            Select
                movereqnum,
                empno,
                currdesk,
                targetdesk,
                assetflag,
                empflag
            From
                dm_assetmove_tran
            Where
                Trim(movereqnum) = Trim(p_session_id)
        )
        Loop
            /* Remove from desk lock */
            Delete
                From dm_desklock
            Where
                Trim(unqid)      = Trim(p_session_id)
                And Trim(deskid) = Trim(rec_clear.targetdesk)
                And empno        = rec_clear.empno;

            Delete
                From dm_desklock
            Where
                Trim(unqid)      = Trim(p_session_id)
                And Trim(deskid) = Trim(rec_clear.currdesk)
                And empno        = rec_clear.empno;

            /* Update desk master */
            Update
                dm_deskmaster
            Set
                isblocked = 0,
                remarks = ''
            Where
                Trim(deskid) = Trim(rec_clear.targetdesk);

            /* Remove from asset add */
            Delete
                From dm_assetadd
            Where
                Trim(unqid)      = Trim(p_session_id)
                And Trim(deskid) = Trim(rec_clear.targetdesk)
                And Trim(empno)  = Trim(rec_clear.empno);

            /* Update movement trans */
            Update
                dm_assetmove_tran
            Set
                it_cord_apprl = 1,
                it_cord_date = sysdate
            Where
                Trim(movereqnum) = Trim(p_session_id)
                And Trim(empno)  = Trim(rec_clear.empno);

            /* Delete source desk list */
            Delete
                From dm_sourcedesk
            Where
                Trim(sid) = Trim(p_session_id);

            /* Delete target desk list */
            Delete
                From dm_targetdesk
            Where
                Trim(sid) = Trim(p_session_id);

        End Loop;

        /* - - - - - - - - - - - Release all unused desks - - - - - - - - - - - */

        /* Remove from desk lock */
        Delete
            From dm_desklock
        Where
            Trim(unqid) = Trim(p_session_id);

        /* Update desk master */
        Update
            dm_deskmaster
        Set
            isblocked = 0,
            remarks = ''
        Where
            Trim(remarks) = Trim(p_session_id);

        p_message_type := 'OK';
        p_message_text := 'Movements successfully done !!';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_desk_assignment_approval;

    Procedure sp_update_move_history(
        p_session_id Varchar2,
        p_empno      Varchar2 Default Null,
        p_deskid     Varchar2,
        p_desk_type  Varchar2
    ) As

        Type cur_typ Is Ref Cursor;
        v_cur            cur_typ;
        v_sql_stat       Varchar2(1000);
        v_history_exists Number;
        v_deskid         Varchar2(7);
        v_assetid        Varchar2(20);
    Begin
        If p_desk_type = 'T' Then
            v_sql_stat := ' select deskid, assetid from dm_assetadd where trim(unqid) = trim(''' || p_session_id || ''')
                            and empno = ''' ||
                          trim(p_empno)
                          || ''' and Trim(deskid) = Trim(''' || p_deskid || ''')';
        Else
            v_sql_stat := 'select deskid, assetid from dm_deskallocation where trim(deskid) = Trim(''' || p_deskid || ''')';
        End If;

        Open v_cur For v_sql_stat;

        Loop
            Fetch v_cur Into v_deskid,
                             v_assetid;
            Exit When v_cur%notfound;
            v_history_exists := 0;
            Select
                Count(*)
            Into
                v_history_exists
            From
                dm_assetmove_tran_history
            Where
                Trim(movereqnum)  = Trim(p_session_id)
                And empno         = p_empno
                And Trim(deskid)  = Trim(v_deskid)
                And desk_flag     = p_desk_type
                And Trim(assetid) = Trim(v_assetid);

            If v_history_exists = 0 Then
                Insert Into dm_assetmove_tran_history (
                    movereqnum,
                    empno,
                    deskid,
                    desk_flag,
                    assetid,
                    historydate
                )
                Values (
                    Trim(p_session_id),
                    p_empno,
                    Trim(v_deskid),
                    p_desk_type,
                    Trim(v_assetid),
                    sysdate
                );

            End If;

        End Loop;

        Close v_cur;
    End sp_update_move_history;

    Procedure sp_add_desklock_status(
        p_session_id    Varchar2,
        p_empno         Varchar2,
        p_deskid        Varchar2,
        p_is_targetdesk Number Default 0
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(*)
        Into
            v_exists
        From
            dm_desklock
        Where
            Trim(unqid)      = Trim(p_session_id)
            And Trim(deskid) = Trim(p_deskid)
            And Trim(empno)  = Trim(p_empno)
            And targetdesk   = p_is_targetdesk;

        If v_exists = 0 Then
            Insert Into dm_desklock (
                unqid,
                empno,
                deskid,
                targetdesk
            )
            Values (
                Trim(p_session_id),
                Trim(p_empno),
                Trim(p_deskid),
                p_is_targetdesk
            );

            Update
                dm_deskmaster
            Set
                isblocked = 1,
                remarks = Trim(p_session_id)
            Where
                Trim(deskid) = Trim(p_deskid);

        End If;

    End sp_add_desklock_status;

    Procedure sp_insert_assets_to_assetadd(
        p_session_id     Varchar2,
        p_empno          Varchar2,
        p_deskid_current Varchar2,
        p_deskid_target  Varchar2
    ) As
        v_exists Number := 0;
    Begin
        For rec_asset In (
            Select
                assetid
            From
                dm_deskallocation
            Where
                Trim(deskid) = Trim(p_deskid_current)
        )
        Loop
            Select
                Count(*)
            Into
                v_exists
            From
                dm_assetadd
            Where
                Trim(unqid)       = Trim(p_session_id)
                And Trim(deskid)  = Trim(p_deskid_target)
                And Trim(empno)   = Trim(p_empno)
                And Trim(assetid) = Trim(rec_asset.assetid);

            If v_exists = 0 Then
                Insert Into dm_assetadd (
                    unqid,
                    deskid,
                    empno,
                    assetid,
                    action_type,
                    action_date
                )
                Values (
                    Trim(p_session_id),
                    Trim(p_deskid_target),
                    Trim(p_empno),
                    Trim(rec_asset.assetid),
                    5,
                    sysdate
                );

            End If;

        End Loop;
    End sp_insert_assets_to_assetadd;

    Procedure sp_import_movements(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,
        p_movements            typ_tab_string,
        p_session_id           Varchar2,
        p_movements_errors Out typ_tab_string,
        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As

        v_empno             Varchar2(5);
        v_currdesk          Varchar2(7);
        v_targetdesk        Varchar2(7);
        v_assetflag         Number := 0;
        v_empflag           Number := 0;
        v_move_req_exists   Number := 0;
        v_valid_move_cntr   Number := 0;
        tab_valid_movements typ_tab_movements;
        v_rec_movement      rec_movement;
        v_err_num           Number;
        is_error_in_row     Boolean;
        v_count             Number;
        v_msg_text          Varchar2(200);
        v_msg_type          Varchar2(10);
    Begin
        v_err_num := 0;

        /* - - - - - - - - - - - Validate data - - - - - - - - - - - */
        For i In 1..p_movements.count
        Loop
            is_error_in_row := False;
            With
                csv As (
                    Select
                        p_movements(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 1, Null, 1))         empno,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 2, Null, 1))         currdesk,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 3, Null, 1))         targetdesk,
                nvl(Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 4, Null, 1)), 0) assetflag,
                nvl(Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 5, Null, 1)), 0) empflag
            Into
                v_empno,
                v_currdesk,
                v_targetdesk,
                v_assetflag,
                v_empflag
            From
                csv;

            -- Empno
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                upper(Trim(empno)) = upper(Trim(v_empno));

            If v_count = 0 Then
                v_err_num                     := v_err_num + 1;
                p_movements_errors(v_err_num) := v_err_num || '~!~' ||
                                                 --ID
                                                 '' || '~!~'
                                                 ||
                                                 --Section
                                                 i || '~!~' ||
                                                 --XL row number
                                                 'Empno'
                                                 || '~!~' ||
                                                 --FieldName
                                                 '0' || '~!~'
                                                 ||
                                                 --ErrorType
                                                 'Critical' || '~!~' ||
                                                 --ErrorTypeString
                                                 'Empno not found';
                --Message
                is_error_in_row               := True;
            End If;

            -- Current desk
            Select
                Count(*)
            Into
                v_count
            From
                dm_deskmaster
            Where
                upper(Trim(deskid)) = upper(Trim(v_currdesk));

            If v_count = 0 Then
                v_err_num                     := v_err_num + 1;
                p_movements_errors(v_err_num) := v_err_num || '~!~' ||
                                                 --ID
                                                 '' || '~!~'
                                                 ||
                                                 --Section
                                                 i || '~!~' ||
                                                 --XL row number
                                                 'Deskid'
                                                 || '~!~' ||
                                                 --FieldName
                                                 '0' || '~!~'
                                                 ||
                                                 --ErrorType
                                                 'Critical' || '~!~' ||
                                                 --ErrorTypeString
                                                 'Current desk not found';
                --Message
                is_error_in_row               := True;
            End If;

            -- Target desk
            Select
                Count(*)
            Into
                v_count
            From
                dm_deskmaster
            Where
                upper(Trim(deskid)) = upper(Trim(v_targetdesk));

            If v_count = 0 Then
                v_err_num                     := v_err_num + 1;
                p_movements_errors(v_err_num) := v_err_num || '~!~' ||
                                                 --ID
                                                 '' || '~!~'
                                                 ||
                                                 --Section
                                                 i || '~!~' ||
                                                 --XL row number
                                                 'Deskid'
                                                 || '~!~' ||
                                                 --FieldName
                                                 '0' || '~!~'
                                                 ||
                                                 --ErrorType
                                                 'Critical' || '~!~' ||
                                                 --ErrorTypeString
                                                 'Target desk not found';
                --Message
                is_error_in_row               := True;
            End If;

            -- Asset / employee flag
            If v_assetflag = 0 And v_empflag = 0 Then
                v_err_num                     := v_err_num + 1;
                p_movements_errors(v_err_num) := v_err_num || '~!~' ||
                                                 --ID
                                                 '' || '~!~'
                                                 ||
                                                 --Section
                                                 i || '~!~' ||
                                                 --XL row number
                                                 'Assetflag / Empflag'
                                                 || '~!~' ||
                                                 --FieldName
                                                 '0' || '~!~'
                                                 ||
                                                 --ErrorType
                                                 'Critical' || '~!~' ||
                                                 --ErrorTypeString
                                                 'Asset / employee movement not defined';
                --Message
                is_error_in_row               := True;
            End If;

            If is_error_in_row = false Then
                v_valid_move_cntr                                 := nvl(v_valid_move_cntr, 0) + 1;
                tab_valid_movements(v_valid_move_cntr).empno      := v_empno;
                tab_valid_movements(v_valid_move_cntr).currdesk   := v_currdesk;
                tab_valid_movements(v_valid_move_cntr).targetdesk := v_targetdesk;
                tab_valid_movements(v_valid_move_cntr).assetflag  := v_assetflag;
                tab_valid_movements(v_valid_move_cntr).empflag    := v_empflag;
            End If;

        End Loop;

        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';
            Return;
        End If;

        /* - - - - - - - - - - - Update database - - - - - - - - - - - */
        Select
            Count(*)
        Into
            v_move_req_exists
        From
            dm_assetmove_tran
        Where
            movereqnum = p_session_id;

        If v_move_req_exists > 0 Then
            Delete
                From dm_assetmove_tran
            Where
                movereqnum = p_session_id;

        End If;
        For i In 1..v_valid_move_cntr
        Loop
            Insert Into dm_assetmove_tran (
                movereqnum,
                movereqdate,
                empno,
                currdesk,
                targetdesk,
                assetflag,
                empflag,
                it_apprl
            )
            Values (
                Trim(p_session_id),
                sysdate,
                Trim(tab_valid_movements(i).empno),
                Trim(tab_valid_movements(i).currdesk),
                Trim(tab_valid_movements(i).targetdesk),
                tab_valid_movements(i).assetflag,
                tab_valid_movements(i).empflag,
                1
            );

            sp_import_movement_add(p_session_id => p_session_id, p_empno => tab_valid_movements(i).empno, p_currdesk => tab_valid_movements(i).
            currdesk, p_targetdesk => tab_valid_movements(i).targetdesk,
                                   p_assetflag => tab_valid_movements(i).assetflag, p_empflag => tab_valid_movements(i).empflag,
                                   p_success => v_msg_type,
                                   p_message => v_msg_text);

            If v_msg_type <> 'OK' Then
                v_err_num                     := v_err_num + 1;
                p_movements_errors(v_err_num) := v_err_num || '~!~' ||
                                                 --ID
                                                 '' || '~!~'
                                                 ||
                                                 --Section
                                                 i || '~!~' ||
                                                 --XL row number
                                                 'Empno'
                                                 || '~!~' ||
                                                 --FieldName
                                                 '0' || '~!~'
                                                 ||
                                                 --ErrorType
                                                 'Critical' || '~!~' ||
                                                 --ErrorTypeString
                                                 v_msg_text;
                --Message
            End If;

        End Loop;

        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';
        Else
            p_message_type := 'OK';
            p_message_text := 'File imported successfully.';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End sp_import_movements;

    Procedure sp_import_movement_add(
        p_session_id  Varchar2,
        p_empno       Varchar2,
        p_currdesk    Varchar2,
        p_targetdesk  Varchar2,
        p_assetflag   Number,
        p_empflag     Number,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
        v_current_desk_lock Number := 0;
        v_target_desk_lock  Number := 0;
    Begin
        -- Current desk
        sp_add_desklock_status(p_session_id => p_session_id, p_empno => Trim(p_empno), p_deskid => Trim(p_currdesk), p_is_targetdesk => 0
        );

        -- Target desk
        sp_add_desklock_status(p_session_id => p_session_id, p_empno => Trim(p_empno), p_deskid => Trim(p_targetdesk), p_is_targetdesk => 1
        );

        If p_assetflag = 1 Then
            sp_insert_assets_to_assetadd(p_session_id => p_session_id, p_empno => Trim(p_empno), p_deskid_current => Trim(
            p_currdesk),
                                         p_deskid_target => Trim(p_targetdesk));
        End If;

        sp_del_ghost_src_tar_desk(p_success => p_success, p_message => p_message);
        p_success := 'OK';
        p_message := 'Movement added successfully';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_import_movement_add;

    Procedure sp_del_ghost_src_tar_desk(
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
    Begin
        --Delete ghost entries from Source desk

        Delete
            From dm_sourcedesk
        Where
            sid Not In (
                Select
                    movereqnum
                From
                    dm_assetmove_tran
                Where
                    nvl(it_cord_apprl, 0) = 0
            );

        ---XXXXXXXXXXXXXXXXXXX

        Delete
            From dm_targetdesk
        Where
            sid Not In (
                Select
                    movereqnum
                From
                    dm_assetmove_tran
                Where
                    nvl(it_cord_apprl, 0) = 0
            );

        p_success := ok;
        p_message := 'Procedure executed successfully';
    Exception
        When Others Then
            p_success := not_ok;
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_flexi_to_dms_import_json(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_parameter_json   Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_message_text Varchar2(200);
        Cursor cur_json Is
            Select
                jt.*
            From
                Json_Table (p_parameter_json Format Json, '$[*]'
                    Columns (
                        deskid Varchar2 (5) Path '$.Deskid'
                    )
                )
                As jt;

    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        tcmpl_app_config.task_scheduler.sp_log_success(
            p_proc_name     => 'sp_flexi_to_dms',
            p_business_name => 'sp_flexi_to_dms',
            p_message       => p_parameter_json
        );

        For c1 In cur_json
        Loop
            Begin
                pkg_dms_movement.sp_flexi_to_dms_add(p_person_id => p_person_id, p_meta_id => p_meta_id, p_deskid => c1.deskid,
                                                     p_message_type => v_message_type,
                                                     p_message_text => v_message_text);

            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
            End;
        End Loop;

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_flexi_to_dms_import_json;

    Procedure sp_flexi_to_dms_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists             Number      := Null;
        v_deskid_exists      Number      := Null;
        v_empno_exists       Number      := Null;
        v_flexi_empno        Varchar2(5) := Null;
        v_empno              Varchar2(5) := Null;
        v_key_id             Varchar2(5) := Null;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_previous_area_id   Varchar2(3) := Null;
        v_area_id            Varchar2(3) := 'A55';
        v_message_type       Varchar2(2);
        v_message_text       Varchar2(200);
    Begin
        v_empno            := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'No employee found';
        End If;

        v_previous_area_id := Null;
        Select
            area_key_id
        Into
            v_previous_area_id
        From
            dm_desk_areas da,
            dm_deskmaster dm
        Where
            dm.work_area  = da.area_key_id
            And dm.deskid = p_deskid;

        v_deskid_exists    := Null;

        Select
            nvl(Count(deskid), 0)
        Into
            v_deskid_exists
        From
            dm_desk_flexi_to_dms
        Where
            isvisible  = 1
            And deskid = p_deskid;

        If v_deskid_exists = 0 Then

            v_flexi_empno  := Null;

            Select
                nvl(desk_book.pkg_deskbook_select_list_qry.fn_get_empno(p_person_id, p_meta_id, p_deskid, sysdate),
                    '')
            Into
                v_flexi_empno
            From
                dual;

            -- insert into flexi to dms
            Insert Into dm_desk_flexi_to_dms (
                keyid,
                deskid,
                previous_area_id,
                area_id,
                isvisible,
                empno,
                created_on,
                created_by
            )
            Values (
                dbms_random.string('X', 8),
                p_deskid,
                v_previous_area_id,
                v_area_id,
                1,
                v_flexi_empno,
                sysdate,
                v_empno
            );

            -- update deskmaster
            Update
                dm_deskmaster
            Set
                work_area = v_area_id
            Where
                deskid = p_deskid;

            -- Delete desk area mapping
            Delete
                From dm_area_type_user_desk_mapping
            Where
                desk_id = p_deskid;

            If length(v_flexi_empno) > 0 Then
                -- insert in usermaster

                v_empno_exists := Null;
                Select
                    nvl(Count(empno), 0)
                Into
                    v_empno_exists
                From
                    dm_usermaster
                Where
                    empno      = v_flexi_empno
                    And deskid = p_deskid;

                If v_empno_exists = 0 Then
                    Insert Into dm_usermaster (
                        empno,
                        deskid,
                        costcode,
                        dep_flag
                    )
                    Values (
                        v_flexi_empno,
                        p_deskid,
                        pkg_dms_general.fn_get_assign_costcode(v_flexi_empno),
                        0
                    );

                End If;

                -- Remove emplyee flexi booking
                Begin
                    desk_book.pkg_flexi_desk_to_dms.sp_action_on_desk_booking(p_person_id => p_person_id, p_meta_id => p_meta_id,
                                                                              p_deskid => Trim (upper(p_deskid)), p_empno =>
                                                                              Trim(upper(v_flexi_empno)),
                                                                              p_date => sysdate, p_action_type => 'DEL', p_message_type =>
                                                                              v_message_type,
                                                                              p_message_text => v_message_text);
                Exception
                    When no_data_found Then
                        v_message_type := ok;
                End;

                If v_message_type = ok Then
                    -- Manage docking station movement
                 /*   pkg_dms_movement.sp_flexi_to_dms_transfer_ds_to_emp(p_person_id => p_person_id, p_meta_id => p_meta_id,
                                                                        p_deskid => p_deskid,
                                                                        p_empno => v_flexi_empno,
                                                                        p_message_type => v_message_type, p_message_text =>
                                                                        v_message_text
                    ); */
                    -- Remove employee mapping

                    v_key_id := Null;
                    Begin
                        Select
                            key_id
                        Into
                            v_key_id
                        From
                            dm_area_type_user_desk_mapping
                        Where
                            empno = v_flexi_empno;

                    Exception
                        When Others Then
                            Null;
                    End;

                    If v_key_id Is Not Null Then
                        pkg_dm_area_type_emp_mapping.sp_delete_area_n_desk_emp_mapping(p_person_id => p_person_id, p_meta_id =>
                        p_meta_id,
                                                                                       p_key_id => v_key_id, p_message_type =>
                                                                                       v_message_type,
                                                                                       p_message_text => v_message_text);

                        If v_message_type = not_ok Then
                            p_message_type := not_ok;
                            p_message_text := 'Procedure not executed. Employee Desk Mapping ';
                            Return;
                        End If;
                    End If;

                    Begin
                        v_key_id := Null;

                        Select
                            key_id
                        Into
                            v_key_id
                        From
                            dm_area_type_user_mapping
                        Where
                            empno = v_flexi_empno;

                    Exception
                        When Others Then
                            Null;
                    End;

                    If v_key_id Is Not Null Then
                        pkg_dm_area_type_user_mapping.sp_delete_area_type_user_mapping(p_person_id => p_person_id, p_meta_id =>
                        p_meta_id,
                                                                                       p_key_id => v_key_id, p_message_type =>
                                                                                       v_message_type, p_message_text =>
                                                                                       v_message_text);

                        If v_message_type = not_ok Then
                            p_message_type := not_ok;
                            p_message_text := 'Procedure not executed. Employee Area Mapping ';
                            Return;
                        End If;

                    End If;

                End If;

            End If;

            Commit;
            p_message_type := 'OK';
            p_message_text := 'Desk converted to dms';
        Else
            p_message_type := 'KO';
            p_message_text := 'Desk already in dms !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_flexi_to_dms_add;

    Procedure sp_flexi_to_dms_rollback(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists             Number      := Null;
        v_keyid_exists       Number      := Null;
        v_deskid             Varchar2(7) := Null;
        v_empno              Varchar2(5) := Null;
        v_office             Varchar2(4) := Null;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_previous_area_id   Varchar2(3) := Null;
        v_previous_empno     Varchar2(5) := Null;
        v_message_type       Varchar2(2);
        v_message_text       Varchar2(200);
    Begin
        v_empno            := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            p_message_type := 'KO';
            p_message_text := 'No employee found';
        End If;

        v_deskid           := Null;
        v_previous_area_id := Null;
        v_previous_empno   := Null;

        Select
            deskid,
            previous_area_id,
            empno
        Into
            v_deskid,
            v_previous_area_id,
            v_previous_empno
        From
            dm_desk_flexi_to_dms
        Where
            keyid = p_key_id;

        If length(v_deskid) > 0 Then

            -- Update desk master
            Update
                dm_deskmaster
            Set
                work_area = v_previous_area_id
            Where
                deskid = v_deskid;

            If v_previous_empno Is Not Null Or v_previous_empno != '' Then
                --dbms_output.put_line('p_key_id=' || p_key_id);
                --dbms_output.put_line('deskid=' || v_deskid);

                v_office       := Null;

                Select
                    office
                Into
                    v_office
                From
                    dm_deskmaster
                Where
                    deskid = v_deskid;

                -- Add emplyee flexi booking
                Begin
                    desk_book.pkg_flexi_desk_to_dms.sp_action_on_desk_booking(p_person_id => p_person_id, p_meta_id => p_meta_id,
                                                                              p_deskid => v_deskid,
                                                                              p_empno => v_previous_empno,
                                                                              p_date => sysdate, p_action_type => 'ADD', p_message_type =>
                                                                              v_message_type,
                                                                              p_message_text => v_message_text);

                Exception
                    When no_data_found Then
                        v_message_type := ok;
                End;

                -- add employee mapping
                If v_message_type = ok Then
                    Begin
                        pkg_dm_area_type_emp_mapping.sp_add_area_n_desk_emp_mapping(p_person_id => p_person_id, p_meta_id =>
                        p_meta_id,
                                                                                    p_area_id => v_previous_area_id, p_empno =>
                                                                                    v_previous_empno,
                                                                                    p_desk_id => v_deskid, p_office_code =>
                                                                                    v_office, p_start_date => sysdate,
                                                                                    p_message_type => v_message_type,
                                                                                    p_message_text => v_message_text);

                    Exception
                        When Others Then
                            If sqlerrm = 'Employee desk area type mapping already exists !!!' Then
                                v_message_type := ok;
                            End If;
                    End;
                End If;

                -- Manage docking station movement
               /*               
               If v_message_type = ok Then
                    Begin
                        pkg_dms_movement.sp_dms_to_flexi_transfer_ds_to_desk(p_person_id => p_person_id, p_meta_id => p_meta_id,
                                                                             p_deskid => v_deskid,
                                                                             p_empno => v_previous_empno,
                                                                             p_message_type => v_message_type, p_message_text =>
                                                                             v_message_text
                        );

                    Exception
                        When Others Then
                            v_message_type := not_ok;
                    End;
                End If;
                */
                p_message_type := 'OK';
                p_message_text := 'Desk status rollbacked to flexi';
            Else
                p_message_type := 'OK';
                p_message_text := 'Desk status rollbacked to flexi wthout employee !!!';
            End If;
          
            -- Remove user master
            Delete
                From dm_usermaster
            Where
                empno      = v_previous_empno
                And deskid = v_deskid;

            -- Update flexi status to visible = false
            Update
                dm_desk_flexi_to_dms
            Set
                isvisible = 0,
                modified_on = sysdate,
                modified_by = v_empno
            Where
                keyid = p_key_id;

            Commit;
        Else
            p_message_type := 'KO';
            p_message_text := 'No such desk found !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_flexi_to_dms_rollback;

    Procedure sp_toggle_flexi_visible_status(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_deskid           Varchar2,
        p_action_type      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If (trim(upper(p_action_type)) = 'VISIBLE') Then
            Update
                dm_desk_flexi_to_dms
            Set
                isvisible = 1,
                modified_on = sysdate,
                modified_by = v_empno
            Where
                keyid In (
                    Select
                        keyid
                    From
                        (
                            Select
                                keyid, Dense_Rank() Over(Order By created_on Desc) rn
                            From
                                dm_desk_flexi_to_dms
                            Where
                                deskid        = p_deskid
                                And isvisible = 0
                        )
                    Where
                        rn = 1
                );

        End If;

        If (trim(upper(p_action_type)) = 'DISABLE') Then
            Update
                dm_desk_flexi_to_dms
            Set
                isvisible = 0,
                modified_on = sysdate,
                modified_by = v_empno
            Where
                keyid In (
                    Select
                        keyid
                    From
                        (
                            Select
                                keyid, Dense_Rank() Over(Order By created_on Desc) rn
                            From
                                dm_desk_flexi_to_dms
                            Where
                                deskid        = p_deskid
                                And isvisible = 1
                        )
                    Where
                        rn = 1
                );

        End If;

        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_toggle_flexi_visible_status;

    -- ds: means docking sttation - transfer to employee
    Procedure sp_flexi_to_dms_transfer_ds_to_emp(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_deskid           Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_ds_assetid         Varchar2(13);
        v_ds_asset_model     Varchar2(60);
        v_key_id             Varchar2(10);
        v_get_trans_id       Varchar2(10);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            dd.assetid,
            da.model
        Into
            v_ds_assetid,
            v_ds_asset_model
        From
            dm_deskallocation dd,
            dm_assetcode      da
        Where
            Trim(da.barcode) = Trim(dd.assetid)
            And dd.assetid Like '%DS%'
            And dd.deskid    = p_deskid;

        If length(v_ds_assetid) > 0 Then
            dms.pkg_inv_transactions.sp_add_transaction(p_person_id => p_person_id, p_meta_id => p_meta_id, p_trans_id =>
            Null, p_trans_date => sysdate,
                                                        p_empno => p_empno, p_trans_type_id => const_transtype_reserve, p_remarks =>
                                                        Null,
                                                        p_item_id => v_ds_assetid,
                                                        p_item_usable => 'U', p_get_trans_id => v_get_trans_id, p_message_type =>
                                                        p_message_type,
                                                        p_message_text => p_message_text);

            If p_message_type = ok And v_get_trans_id Is Not Null Then
                dms.pkg_inv_transactions.sp_issue_transaction(p_person_id => p_person_id, p_meta_id => p_meta_id, p_trans_id =>
                v_get_trans_id,
                                                              p_trans_type_id => const_transtype_issue,
                                                              p_message_type => p_message_type, p_message_text => p_message_text);

            End If;

            Delete
                From dm_deskallocation
            Where
                deskid      = p_deskid
                And assetid = v_ds_assetid;

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := ok;
            p_message_text := 'No docking station available';
        End If;

    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_flexi_to_dms_transfer_ds_to_emp;

    -- ds: means docking sttation - transfer to desk
    Procedure sp_dms_to_flexi_transfer_ds_to_desk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_deskid           Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_ds_assetid         Varchar2(13);
        v_ds_asset_model     Varchar2(60);
        v_keyid              Varchar2(10);
        v_get_trans_id       Varchar2(10);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        -- get docking station assetid
        Select
            ieim.item_id,
            da.model
        Into
            v_ds_assetid,
            v_ds_asset_model
        From
            inv_emp_item_mapping ieim,
            dm_assetcode         da
        Where
            da.barcode     = ieim.item_id
            And ieim.item_id Like '%DS%'
            And ieim.empno = p_empno;

        If length(v_ds_assetid) > 0 Then

            dms.pkg_inv_transactions.sp_add_transaction(
                p_person_id     => p_person_id,
                p_meta_id       => p_meta_id,
                p_trans_id      => Null,
                p_trans_date    => sysdate,
                p_empno         => p_empno,
                p_trans_type_id => const_transtype_receive,
                p_remarks       => Null,
                p_item_id       => v_ds_assetid,
                p_item_usable   => 'U',
                p_get_trans_id  => v_get_trans_id,
                p_message_type  => p_message_type,
                p_message_text  => p_message_text
            );

            If p_message_type = ok And v_get_trans_id Is Not Null Then
                dms.pkg_inv_transactions.sp_issue_transaction(
                    p_person_id     => p_person_id,
                    p_meta_id       => p_meta_id,
                    p_trans_id      => v_get_trans_id,
                    p_trans_type_id => const_transtype_receive,
                    p_message_type  => p_message_type,
                    p_message_text  => p_message_text
                );

            End If;

            Insert Into dm_deskallocation (
                deskid,
                assetid
            )
            Values (
                p_deskid,
                v_ds_assetid
            );

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';

        Else
            p_message_type := ok;
            p_message_text := 'No docking station available';
        End If;

    End sp_dms_to_flexi_transfer_ds_to_desk;

    Procedure sp_update_exclude_emp_from_moc5(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_deskid           Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_office             Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            upper(office)
        Into
            v_office
        From
            dm_deskmaster
        Where
            deskid = p_deskid;

        If v_office = 'MOC5' Then
            Insert Into emp_exclude_from_moc5 (
                empno,
                modified_by,
                modified_on
            )
            Values (
                p_empno,
                v_empno,
                sysdate
            );

            p_message_type := ok;
            p_message_text := 'Done';
        Else
            p_message_type := not_ok;
            p_message_text := 'Invalid office, no record updated';
        End If;

    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_exclude_emp_from_moc5;

    Procedure sp_create_flexi_booking(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_deskid           Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_office             Varchar2(5);
        v_message_type       Varchar2(2);
        v_message_text       Varchar2(200);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            upper(office)
        Into
            v_office
        From
            dm_deskmaster
        Where
            deskid = p_deskid;

        If v_office = 'MOC4' Then
            -- Add emplyee flexi booking
            desk_book.pkg_flexi_desk_to_dms.sp_action_on_desk_booking(p_person_id => p_person_id, p_meta_id => p_meta_id,
                                                                      p_deskid => p_deskid,
                                                                      p_empno => p_empno,
                                                                      p_date => sysdate, p_action_type => 'ADD', p_message_type =>
                                                                      v_message_type,
                                                                      p_message_text => v_message_text);

            If v_message_type = ok Then
                p_message_type := ok;
                p_message_text := 'Done';
            Else
                p_message_type := not_ok;
                p_message_text := v_message_text;
            End If;

        Else
            p_message_type := not_ok;
            p_message_text := 'Invalid office, no record updated';
        End If;

    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_create_flexi_booking;
   
End pkg_dms_movement;
/

Grant Execute On dms.pkg_dms_movement To tcmpl_app_config;