--------------------------------------------------------
--  DDL for Package IOT_SWP_ACTION
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."IOT_SWP_DMS" As

    /*  p_unqid := 'SWPF'  -- fixed desk
        p_unqid := 'SWPV'  -- variable desk     */

    c_empno_swpv       Constant Varchar2(4)  := 'SWPV';
    c_blockdesk_4_swpv Constant Number(1)    := 7;
    c_unqid_swpv       Constant Varchar2(20) := 'Desk block SWPV';

    Procedure sp_add_desk_user(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_deskid           Varchar2,
        p_parent           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists Number;
    Begin
        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            p_message_type := 'KO';
            p_message_text := 'Planning not allowed for employee assign code.';
            Return;
        End If;
        Select
            Count(du.empno)
        Into
            v_exists
        From
            dms.dm_usermaster_swp_plan du
        Where
            du.empno        = p_empno
            And du.deskid   = p_deskid
            And du.costcode = p_parent;

        If v_exists = 0 Then
            Insert Into dms.dm_usermaster_swp_plan(empno, deskid, costcode, dep_flag)
            Values
                (p_empno, p_deskid, p_parent, 0);
        Else
            p_message_type := 'KO';
            p_message_text := 'Err : User already assigned desk in DMS';
            Return;
        End If;
        
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_desk_user;

    Procedure sp_remove_desk_user(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_empno     Varchar2,
        p_deskid    Varchar2
    ) As
        v_pk              Varchar2(20);
        v_create_by_empno Varchar2(5);
    Begin

        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            Return;
        End If;

        v_create_by_empno := get_empno_from_meta_id(p_meta_id);

        sp_clear_desk(
            p_person_id => p_person_id,
            p_meta_id   => p_meta_id,

            p_deskid    => p_deskid
        );

        Delete
            From dms.dm_usermaster_swp_plan du
        Where
            du.empno      = p_empno
            And du.deskid = p_deskid;
        /*
        If p_unqid = 'SWPV' Then
            --send assets to orphan table

            v_pk := dbms_random.string('X', 20);

            Insert Into dms.dm_orphan_asset(unqid, empno, deskid, assetid, createdon, createdby, confirmed)
            Select
                v_pk,
                p_empno,
                deskid,
                assetid,
                sysdate,
                v_create_by_empno,
                0
            From
                dms.dm_deskallocation
            Where
                deskid = p_deskid;

            -- release assets of desk from dm_deskallocation table 

            Delete
                From dms.dm_deskallocation
            Where
                deskid = p_deskid;
        End If;
        */
    End sp_remove_desk_user;

    Procedure sp_lock_desk(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_deskid    Varchar2
    ) As
        v_exists Number;
    Begin

        Select
            Count(dl.empno)
        Into
            v_exists
        From
            dms.dm_desklock_swp_plan dl
        Where
            dl.empno      = c_empno_swpv
            And dl.deskid = p_deskid;

        If v_exists = 0 Then
            Insert Into dms.dm_desklock_swp_plan(unqid, empno, deskid, targetdesk, blockflag, blockreason)
            Values
                (c_unqid_swpv, c_empno_swpv, p_deskid, 0, 1, c_blockdesk_4_swpv);
        Else
            Update
                dms.dm_desklock_swp_plan
            Set
                unqid = c_unqid_swpv,
                targetdesk = 0,
                blockflag = 1,
                blockreason = c_blockdesk_4_swpv
            Where
                empno      = c_empno_swpv
                And deskid = p_deskid;
        End If;
    End sp_lock_desk;

    Procedure sp_unlock_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_deskid      Varchar2,
        p_week_key_id Varchar2
    ) As
        v_count Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            swp_smart_attendance_plan
        Where
            Trim(deskid)    = Trim(p_deskid)
            And week_key_id = p_week_key_id;
            
        --
        If v_count > 0 Then
            Return;
        End If;
        Delete
            From dms.dm_desklock_swp_plan dl
        Where
            Trim(dl.empno)      = Trim(c_empno_swpv)
            And Trim(dl.deskid) = Trim(p_deskid)
            And Trim(dl.unqid)  = Trim(c_unqid_swpv);
    End sp_unlock_desk;

    Procedure sp_clear_desk(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_deskid    Varchar2
    ) As
        v_pk              Varchar2(20);
        v_create_by_empno Varchar2(5);
        v_desk_empno      Varchar2(5);
    Begin
        v_create_by_empno := get_empno_from_meta_id(p_meta_id);
        
        /* send assets to orphan table */

        v_pk              := dbms_random.string('X', 20);
        Begin
            Select
                empno
            Into
                v_desk_empno
            From
                dms.dm_usermaster_swp_plan
            Where
                deskid = Trim(p_deskid);
        Exception
            When Others Then
                Null;
        End;
        Insert Into dms.dm_orphan_asset(unqid, empno, deskid, assetid, createdon, createdby, confirmed)
        Select
            v_pk,
            v_desk_empno,
            deskid,
            assetid,
            sysdate,
            v_create_by_empno,
            0
        From
            dms.dm_deskallocation_swp_plan
        Where
            deskid = p_deskid;

        /* release assets of desk from dm_deskallocation table */

        Delete
            From dms.dm_deskallocation_swp_plan
        Where
            deskid = p_deskid;

    End sp_clear_desk;

End iot_swp_dms;
/

Grant Execute On "SELFSERVICE"."IOT_SWP_DMS" To "TCMPL_APP_CONFIG";