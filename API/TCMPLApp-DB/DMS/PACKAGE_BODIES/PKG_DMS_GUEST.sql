Create Or Replace Package Body "DMS"."PKG_DMS_GUEST" As

    ok     Constant Varchar2(2) := 'OK';
    not_ok Constant Varchar2(2) := 'KO';

    Function fn_generate_guest_empno Return Varchar2 As
        v_guest_empno Varchar2(5);
        v_num         Number;
    Begin
        Select
            gnum
        Into
            v_guest_empno
        From
            (
                Select
                    gnum
                From
                    dm_guestmaster
                Order By gnum Desc
            )
        Where
            Rownum = 1;
        v_num         := (substr(v_guest_empno, 2));
        v_guest_empno := 'G' || lpad(v_num + 1, 4, '0');
        Return v_guest_empno;
    End;
    --
    Procedure sp_dm_adm_add_guest(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_guest_name        Varchar2,
        p_guest_costcode    Varchar2,
        p_guest_projno      Varchar2 Default Null,
        p_guest_target_desk Varchar2,
        p_guest_from_date   Date,
        p_guest_to_date     Date,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_guest_empno Varchar2(5);
        v_empno       Varchar2(5);
        v_exists      Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_guest_name Is Null
            Or p_guest_costcode Is Null
            Or p_guest_projno Is Null
            Or p_guest_from_date Is Null
            Or p_guest_to_date Is Null
        Then
            p_message_type := not_ok;
            p_message_text := 'Err :- Blank values provided. Cannot proceed.';
        End If;
        v_guest_empno  := fn_generate_guest_empno();

        Insert Into dm_guestmaster (
            gnum,
            gname,
            gcostcode,
            gprojnum,
            gfromdate,
            gtodate,
            gdate,
            targetdesk,
            deskloc,

            hod_apprl,
            hod_code,
            hod_date,
            it_apprl,
            it_code,
            it_date,
            itcord_apprl,
            itcord_date,
            gmoddate,
            gmodby

        )
        Values
        (
            v_guest_empno,
            p_guest_name,
            p_guest_costcode,
            p_guest_projno,
            p_guest_from_date,
            p_guest_to_date,
            sysdate,
            p_guest_target_desk,
            p_guest_target_desk,

            1,
            v_empno,
            sysdate,
            1,
            v_empno,
            sysdate,
            1,
            sysdate,
            sysdate,
            v_empno
        );

        If (Sql%rowcount > 0) Then

            Insert Into dm_usermaster (empno, deskid, costcode, dep_flag)
            Values (v_guest_empno, p_guest_target_desk, p_guest_costcode, 0);

            Update
                dm_deskmaster
            Set
                isblocked = 1,
                --remarks = Trim(v_guest_empno || ' - ' || p_guest_name)
                remarks = 'Desk booked for guest : ' || v_guest_empno || ' : '
                || p_guest_name || ', From date (' || p_guest_from_date || ' - '
                || p_guest_to_date || ' )'
            Where
                Trim(deskid) = Trim(p_guest_target_desk);

            Select
                Count(*)
            Into
                v_exists
            From
                dm_desklock
            Where
                Trim(deskid) = Trim(p_guest_target_desk);

            If v_exists = 0 Then
                Insert Into dm_desklock
                (
                    unqid,
                    empno,
                    deskid,
                    targetdesk,
                    blockflag,
                    blockreason
                )
                Values
                (
                    Trim(p_guest_name),
                    v_guest_empno,
                    Trim(p_guest_target_desk),
                    0,
                    1,
                    1
                );
            End If;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Error - Procedure not executed..';
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    --
    Procedure sp_dm_adm_guest_edit(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_guest_empno       Varchar2,
        p_guest_name        Varchar2,
        p_guest_projno      Varchar2 Default Null,
        p_guest_to_date     Date,
        p_guest_target_desk Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_empno    Varchar2(5);
        v_old_desk Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_guest_name Is Null
            Or p_guest_projno Is Null
            Or p_guest_to_date Is Null
        Then
            p_message_type := not_ok;
            p_message_text := 'Err :- Blank values provided. Cannot proceed.';
        End If;

        Select
            targetdesk
        Into
            v_old_desk
        From
            dm_guestmaster
        Where
            gnum = p_guest_empno; 

        --update dm_guestmaster
        Update
            dm_guestmaster
        Set
            gname = p_guest_name,
            gprojnum = p_guest_projno,
            gtodate = p_guest_to_date,
            targetdesk = p_guest_target_desk,
            deskloc = p_guest_target_desk,
            gmoddate = sysdate,
            gmodby = v_empno
        Where
            gnum = p_guest_empno;

        If (Sql%rowcount > 0) Then

            If trim(upper(v_old_desk)) != trim(upper(p_guest_target_desk)) Then
                Update
                    dm_usermaster
                Set
                    deskid = p_guest_target_desk
                Where
                    empno = p_guest_empno;

                Update
                    dm_desklock
                Set                                        
                    deskid = Trim(upper(p_guest_target_desk))
                Where
                    Trim(deskid) = Trim(v_old_desk);
                    
                Update
                    dm_deskmaster
                Set
                    isblocked = 1,
                    remarks = 'Desk booked for guest : ' || p_guest_name || ' : '
                    || p_guest_name || ', To date (' || p_guest_to_date || ' )'
                Where
                    Trim(deskid) = Trim(p_guest_target_desk);

                Update
                    dm_deskmaster
                Set
                    isblocked = 0,
                    remarks = ''
                Where
                    Trim(deskid) = Trim(v_old_desk);

            End If;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Error - Procedure not executed..';
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    ---
    Procedure sp_get_details(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_guest_empno       Varchar2,

        p_guest_name    Out Varchar2,
        p_costcode      Out Varchar2,
        p_projno5       Out Varchar2,
        p_from_date     Out Varchar2,
        p_to_date       Out Varchar2,
        p_target_desk   Out Varchar2,
        p_modified_by   Out Varchar2,
        p_modified_date Out Date,

        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
    ) As
        rec_guest_master dm_guestmaster%rowtype;
        v_empno          Varchar2(5);
    Begin
        v_empno         := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            *
        Into
            rec_guest_master
        From
            dm_guestmaster
        Where
            gnum = p_guest_empno;

        p_guest_name    := rec_guest_master.gname;
        p_costcode      := rec_guest_master.gcostcode;
        p_projno5       := rec_guest_master.gprojnum;
        p_from_date     := rec_guest_master.gfromdate;
        p_to_date       := rec_guest_master.gtodate;
        p_target_desk   := rec_guest_master.targetdesk;
        p_modified_by   := rec_guest_master.gmodby;
        p_modified_date := rec_guest_master.gmoddate;

        p_message_type  := ok;
        p_message_text  := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_dm_adm_guest_delete(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_guest_empno       Varchar2,
        p_guest_target_desk Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_empno  Varchar2(5);
        v_exists Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete dm_guestmaster
        Where
            gnum                        = p_guest_empno
            And Trim(upper(targetdesk)) = Trim(upper(p_guest_target_desk));

        Delete
            From dm_usermaster
        Where
            empno      = p_guest_empno
            And deskid = p_guest_target_desk;

        Update
            dm_deskmaster
        Set
            isblocked = 0,
            remarks = ''
        Where
            Trim(deskid) = Trim(p_guest_target_desk);

        Select
            Count(*)
        Into
            v_exists
        From
            dm_desklock
        Where
            Trim(deskid) = Trim(p_guest_target_desk);

        If v_exists = 1 Then
            Delete
                From dm_desklock
            Where
                Trim(deskid) = Trim(p_guest_target_desk);
        End If;

        Commit;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_dm_adm_guest_desk_release(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_guest_empno       Varchar2,
        p_guest_target_desk Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_empno  Varchar2(5);
        v_exists Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update
            dm_guestmaster
        Set
            deskloc = 'Released:' || to_char(sysdate(), 'DD-Mon-YYYY')
        Where
            gnum                        = p_guest_empno
            And Trim(upper(targetdesk)) = Trim(upper(p_guest_target_desk));

        Update
            dm_deskmaster
        Set
            isblocked = 0,
            remarks = ''
        Where
            Trim(deskid) = Trim(p_guest_target_desk);

        Select
            Count(*)
        Into
            v_exists
        From
            dm_desklock
        Where
            Trim(deskid) = Trim(p_guest_target_desk);

        If v_exists = 1 Then
            Delete
                From dm_desklock
            Where
                Trim(deskid) = Trim(p_guest_target_desk);
        End If;

        Commit;

        Delete
            From dm_usermaster
        Where
            empno      = p_guest_empno
            And deskid = p_guest_target_desk;

        Commit;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err :- ' || sqlcode || ' - ' || sqlerrm;

    End;

End;