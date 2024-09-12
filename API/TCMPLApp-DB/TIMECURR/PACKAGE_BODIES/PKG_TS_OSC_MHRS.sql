--------------------------------------------------------
--  DDL for Package Body PKG_TS_OSC_MHRS
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."PKG_TS_OSC_MHRS" As

    Procedure sp_get_timesheet_meta_props(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscm_id          Varchar2,
        p_oscd_id          Varchar2 Default Null,

        p_assign       Out Varchar2,
        p_empno        Out Varchar2,
        p_projno       Out Varchar2,
        p_wpcode       Out Varchar2,
        p_activity     Out Varchar2,
        p_hours        Out Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_oscd_id Is Not Null Then
            Select
                tomm.assign, tomm.empno, tomd.projno, tomd.wpcode, tomd.activity, tomd.hours
            Into
                p_assign, p_empno, p_projno, p_wpcode, p_activity, p_hours
            From
                ts_osc_mhrs_master tomm,
                ts_osc_mhrs_detail tomd
            Where
                tomm.oscm_id     = tomd.oscm_id
                And tomm.oscm_id = Trim(p_oscm_id)
                And tomd.oscd_id = Trim(p_oscd_id);
        Else
            Select
                tomm.assign, tomm.empno, tomd.projno, tomd.wpcode, tomd.activity, tomd.hours
            Into
                p_assign, p_empno, p_projno, p_wpcode, p_activity, p_hours
            From
                ts_osc_mhrs_master tomm,
                ts_osc_mhrs_detail tomd
            Where
                tomm.oscm_id     = tomd.oscm_id
                And Rownum       = 1
                And tomm.oscm_id = Trim(p_oscm_id);
        End If;
        p_message_type := ok;
        p_message_text := 'Data is valid.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_get_timesheet_meta_props;

    Procedure sp_validate_costcode_data(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno    Varchar2(5);
        v_costcode costmast.costcode%Type;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
        Distinct c.costcode
        Into
            v_costcode
        From
            costmast  c,
            deptphase dp
        Where
            c.active         = 1
            And c.costcode   = dp.costcode
            And dp.isprimary = 1
            And c.costcode In
            (
                Select
                    costcode
                From
                    costmast
                Where
                    hod          = Trim(v_empno)
                    Or secretary = Trim(v_empno)
                Union All
                Select
                    costcode
                From
                    time_secretary
                Where
                    empno = Trim(v_empno)
            )
            And c.costcode   = Trim(p_costcode);

        p_message_type := ok;
        p_message_text := 'Assign is valid.';

    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'Assign is not valid. !!! ';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_costcode_data;

    Procedure sp_validate_empno_data(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_empno            Varchar2,
        p_mode_type        Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno  Varchar2(5);
        v_empno1 emplmast.empno%Type;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_mode_type = 'UNLOCK' Then
            Select
                e.empno
            Into
                v_empno1
            From
                emplmast    e,
                costmast    c,
                emptypemast etm,
                deptphase   dp
            Where
                e.assign         = c.costcode
                And e.status     = 1
                And c.active     = 1
                And e.emptype    = etm.emptype
                And e.emptype    = 'O'
                And e.assign     = dp.costcode
                And dp.isprimary = 1
                And (e.empno, p_costcode) In (
                    Select
                        tomm.empno, tomm.assign
                    From
                        ts_osc_mhrs_master tomm,
                        tsconfig           t
                    Where
                        tomm.is_lock  = 'OK'
                        And tomm.yymm = t.pros_month
                )
                And e.empno      = Trim(p_empno);
        Else
            Select
                e.empno
            Into
                v_empno1
            From
                emplmast    e,
                costmast    c,
                emptypemast etm,
                deptphase   dp
            Where
                e.assign         = c.costcode
                And e.status     = 1
                And c.active     = 1
                And e.emptype    = etm.emptype
                And e.emptype    = 'O'
                And e.assign     = dp.costcode
                And dp.isprimary = 1
                And (e.empno, p_costcode) Not In (
                    Select
                        tomm.empno, tomm.assign
                    From
                        ts_osc_mhrs_master tomm,
                        tsconfig           t
                    Where
                        tomm.is_lock  = 'OK'
                        And tomm.yymm = t.pros_month
                )
                And e.empno      = Trim(p_empno);
        End If;
        p_message_type := ok;
        p_message_text := 'OSC No is valid.';

    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'OSC No is not valid.';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_empno_data;

    Procedure sp_validate_projno_data(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_projno           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno  Varchar2(5);
        v_projno projmast.projno%Type;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            p.projno
        Into
            v_projno
        From
            projmast             p, tsconfig t
        Where
            p.active            = 1
            And p.block_booking = 0
            And To_Number(to_char(p.revcdate, 'YYYYMM')) >= To_Number(t.pros_month)
            And substr(p.projno, 6, 2) In (
                Select
                    phase
                From
                    deptphase
                Where
                    costcode = Trim(p_costcode)
            )
            And
            p.projno Not In (
                Select
                    projno
                From
                    job_lock
            )
            And
            substr(p.projno, 1, 5) Not In (
                Select
                    projno
                From
                    tm_leave
            )
            And p.projno        = Trim(p_projno);

        p_message_type := ok;
        p_message_text := 'Project is valid.';

    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'Project is not valid.';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_projno_data;

    Procedure sp_validate_wpcode_data(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_wpcode           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno  Varchar2(5);
        v_wpcode time_wpcode.wpcode%Type;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            wpcode
        Into
            v_wpcode
        From
            time_wpcode
        Where
            wpcode = Trim(p_wpcode);

        p_message_type := ok;
        p_message_text := 'WP code is valid.';
    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'WP code is not valid.';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_wpcode_data;

    Procedure sp_validate_activity_data(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_activity         Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno    Varchar2(5);
        v_activity act_mast.activity%Type;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            activity
        Into
            v_activity
        From
            act_mast
        Where
            costcode     = Trim(p_costcode)
            And active   = 1
            And activity = p_activity;

        p_message_type := ok;
        p_message_text := 'Activity is valid.';

    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'Activity is not valid.';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_activity_data;

    Procedure sp_validate_hours_data(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_hours            Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_hours = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Hours cannot be zero.';
        End If;
        p_message_type := ok;
        p_message_text := 'Hours is valid.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_hours_data;

    Procedure sp_validate_data(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_empno            Varchar2,
        p_projno           Varchar2,
        p_wpcode           Varchar2,
        p_activity         Varchar2,
        p_hours            Number,
        p_mode_type        Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        sp_validate_costcode_data(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_costcode     => p_costcode,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        sp_validate_empno_data(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_costcode     => p_costcode,
            p_empno        => p_empno,
            p_mode_type    => p_mode_type,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        sp_validate_projno_data(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_costcode     => p_costcode,
            p_projno       => p_projno,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        sp_validate_wpcode_data(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_wpcode       => p_wpcode,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        sp_validate_activity_data(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_costcode     => p_costcode,
            p_activity     => p_activity,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        sp_validate_hours_data(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_hours        => p_hours,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        p_message_type := ok;
        p_message_text := 'Data is valid.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_data;

    Procedure sp_get_status(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_oscm_id            Varchar2,

        p_is_lock        Out Varchar2,
        p_is_hod_approve Out Varchar2,
        p_is_post        Out Varchar2,
        p_yymm           Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin        
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_is_lock        := ' ';
            p_is_hod_approve := ' ';
            p_is_post        := ' ';
            p_yymm           := ' ';
            p_message_type   := not_ok;
            p_message_text   := 'Invalid employee number';
            Return;
        End If;       

        Select
            is_lock, is_hod_approve, is_post, yymm
        Into
            p_is_lock, p_is_hod_approve, p_is_post, p_yymm
        From
            ts_osc_mhrs_master
        Where
            oscm_id = Trim(p_oscm_id);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_is_lock        := ' ';
            p_is_hod_approve := ' ';
            p_is_post        := ' ';
            p_yymm           := ' ';
            p_message_type   := not_ok;
            p_message_text   := 'ERR :- ' || nvl(p_oscm_id, 'NO-OSCMID') || ' - ' || sqlcode || ' - ' || sqlerrm;
    End sp_get_status;

    Procedure sp_check_processing_month(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno      Varchar2(5);
        v_pros_month tsconfig.pros_month%Type;
    Begin        
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;        

        Select
            pros_month
        Into
            v_pros_month
        From
            tsconfig;

        If To_Number(v_pros_month) != To_Number(p_yymm) Then
            p_message_type := not_ok;
            p_message_text := 'Invalid month for Subcontract manhours processing !!!.';
            Return;
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_check_processing_month;

    Procedure sp_insert_into_timetran(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        
        p_oscm_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_is_lock        ts_osc_mhrs_master.is_lock%Type;
        v_is_hod_approve ts_osc_mhrs_master.is_hod_approve%Type;
        v_is_post        ts_osc_mhrs_master.is_post%Type;
        v_yymm           ts_osc_mhrs_master.yymm%Type;
        v_empno          Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;        
        
        sp_get_status(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,

            p_oscm_id        => p_oscm_id,

            p_is_lock        => v_is_lock,
            p_is_hod_approve => v_is_hod_approve,
            p_is_post        => v_is_post,
            p_yymm           => v_yymm,
            p_message_type   => p_message_type,
            p_message_text   => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        sp_check_processing_month(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,
        
            p_yymm         => v_yymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If v_is_lock = ok And v_is_hod_approve = ok And v_is_post = ok Then
            Insert Into timetran (
                yymm,
                empno,
                costcode,
                projno,
                wpcode,
                activity,
                grp,
                hours,
                othours,
                company,
                loaded,
                yymm_inv,
                parent)
            Select
                tomm.yymm,
                tomm.empno,
                tomm.assign,
                tomd.projno,
                tomd.wpcode,
                tomd.activity,
                c.tma_grp,
                tomd.hours,
                0,
                'TICB',
                Null,
                Null,
                tomm.parent
            From
                ts_osc_mhrs_master tomm,
                ts_osc_mhrs_detail tomd,
                costmast           c
            Where
                tomm.oscm_id     = tomd.oscm_id
                And c.costcode   = tomm.assign
                And tomm.oscm_id = Trim(p_oscm_id);

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := ok;
            p_message_text := 'Cannot process into Timetran.';
        End If;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_insert_into_timetran;

    Procedure sp_delete_from_timetran(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        
        p_oscm_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_is_lock        ts_osc_mhrs_master.is_lock%Type;
        v_is_hod_approve ts_osc_mhrs_master.is_hod_approve%Type;
        v_is_post        ts_osc_mhrs_master.is_post%Type;
        v_yymm           ts_osc_mhrs_master.yymm%Type;
        v_empno          Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;     
    
        sp_get_status(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,

            p_oscm_id        => p_oscm_id,

            p_is_lock        => v_is_lock,
            p_is_hod_approve => v_is_hod_approve,
            p_is_post        => v_is_post,
            p_yymm           => v_yymm,
            p_message_type   => p_message_type,
            p_message_text   => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        sp_check_processing_month(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,
            
            p_yymm         => v_yymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If v_is_lock = ok And v_is_hod_approve = ok And v_is_post = not_ok Then
            Delete
                From timetran
            Where
                (yymm, empno, parent, costcode) In
                (
                    Select
                        yymm,
                        empno,
                        parent,
                        assign
                    From
                        ts_osc_mhrs_master
                    Where
                        oscm_id = Trim(p_oscm_id)
                );

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := ok;
            p_message_text := 'Cannot delete Timetran data.';
        End If;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_from_timetran;

    Procedure sp_update_osc_mhrs_master(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscm_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_hours ts_osc_mhrs_master.hours%Type;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Sum(hours)
        Into
            v_hours
        From
            ts_osc_mhrs_detail
        Where
            oscm_id = Trim(p_oscm_id);

        Update
            ts_osc_mhrs_master
        Set
            hours = v_hours,
            modified_on = sysdate,
            modified_by = Trim(v_empno)
        Where
            oscm_id = Trim(p_oscm_id);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_osc_mhrs_master;

    Procedure sp_add_osc_mhrs_master(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,
        p_empno            Varchar2,
        p_parent           Varchar2,
        p_assign           Varchar2,
        p_hours            Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into ts_osc_mhrs_master(
            oscm_id,
            yymm,
            empno,
            parent,
            assign,
            hours,
            modified_on,
            modified_by)
        Values (
            dbms_random.string('X', 10),
            Trim(p_yymm),
            Trim(p_empno),
            Trim(p_parent),
            Trim(p_assign),
            p_hours,
            sysdate,
            Trim(v_empno));

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_osc_mhrs_master;

    Procedure sp_add_osc_mhrs_detail(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscm_id          Varchar2,
        p_projno           Varchar2,
        p_wpcode           Varchar2,
        p_activity         Varchar2,
        p_hours            Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into ts_osc_mhrs_detail(
            oscm_id,
            oscd_id,
            projno,
            wpcode,
            activity,
            hours,
            modified_on,
            modified_by)
        Values (p_oscm_id,
            dbms_random.string('X', 10),
            Trim(p_projno),
            Trim(p_wpcode),
            Trim(p_activity),
            p_hours,
            sysdate,
            Trim(v_empno));

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_osc_mhrs_detail;

    Procedure sp_add_osc_mhrs(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,
        p_empno            Varchar2,
        p_parent           Varchar2,
        p_assign           Varchar2,
        p_projno           Varchar2,
        p_wpcode           Varchar2,
        p_activity         Varchar2,
        p_hours            Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno      Varchar2(5);
        v_oscm_id    ts_osc_mhrs_master.oscm_id%Type;
        v_pros_month tsconfig.pros_month%Type;
        v_is_lock    ts_osc_mhrs_master.is_lock%Type;
        v_count      Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        sp_check_processing_month(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_yymm         => p_yymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        Begin
            Select
                oscm_id, is_lock
            Into
                v_oscm_id, v_is_lock
            From
                ts_osc_mhrs_master
            Where
                yymm       = Trim(p_yymm)
                And empno  = Trim(p_empno)
                And parent = Trim(p_parent)
                And assign = Trim(p_assign);

            If v_is_lock = ok Then
                p_message_type := not_ok;
                p_message_text := 'Subcontract manhours booking is already locked !!!.';
                Return;
            Else
                Select
                    Count(oscd_id)
                Into
                    v_count
                From
                    ts_osc_mhrs_detail
                Where
                    projno       = Trim(p_projno)
                    And wpcode   = Trim(p_wpcode)
                    And activity = p_activity
                    And oscm_id  = Trim(v_oscm_id);
                If v_count > 0 Then
                    p_message_type := not_ok;
                    p_message_text := 'Subcontract manhours already exists !!!.';
                    Return;
                Else
                    sp_validate_data(
                        p_person_id    => p_person_id,
                        p_meta_id      => p_meta_id,

                        p_costcode     => p_assign,
                        p_empno        => p_empno,
                        p_projno       => p_projno,
                        p_wpcode       => p_wpcode,
                        p_activity     => p_activity,
                        p_hours        => p_hours,
                        p_mode_type    => 'ADD',

                        p_message_type => p_message_type,
                        p_message_text => p_message_text
                    );
                    If p_message_type = not_ok Then
                        p_message_type := p_message_type;
                        p_message_text := p_message_text;
                        Return;
                    End If;

                    sp_add_osc_mhrs_detail(
                        p_person_id    => p_person_id,
                        p_meta_id      => p_meta_id,

                        p_oscm_id      => v_oscm_id,
                        p_projno       => p_projno,
                        p_wpcode       => p_wpcode,
                        p_activity     => p_activity,
                        p_hours        => p_hours,

                        p_message_type => p_message_type,
                        p_message_text => p_message_text
                    );

                    sp_update_osc_mhrs_master(
                        p_person_id    => p_person_id,
                        p_meta_id      => p_meta_id,

                        p_oscm_id      => v_oscm_id,

                        p_message_type => p_message_type,
                        p_message_text => p_message_text
                    );
                End If;
            End If;
        Exception
            When no_data_found Then
                sp_validate_data(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_costcode     => p_assign,
                    p_empno        => p_empno,
                    p_projno       => p_projno,
                    p_wpcode       => p_wpcode,
                    p_activity     => p_activity,
                    p_hours        => p_hours,
                    p_mode_type    => 'ADD',

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
                If p_message_type = not_ok Then
                    p_message_type := p_message_type;
                    p_message_text := p_message_text;
                    Return;
                End If;

                sp_add_osc_mhrs_master(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_yymm         => p_yymm,
                    p_empno        => p_empno,
                    p_parent       => p_parent,
                    p_assign       => p_assign,
                    p_hours        => p_hours,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );

                Select
                    oscm_id
                Into
                    v_oscm_id
                From
                    ts_osc_mhrs_master
                Where
                    yymm       = Trim(p_yymm)
                    And empno  = Trim(p_empno)
                    And parent = Trim(p_parent)
                    And assign = Trim(p_assign);

                sp_add_osc_mhrs_detail(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_oscm_id      => v_oscm_id,
                    p_projno       => p_projno,
                    p_wpcode       => p_wpcode,
                    p_activity     => p_activity,
                    p_hours        => p_hours,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );

        End;

        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_osc_mhrs;

    Procedure sp_update_osc_mhrs_detail(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscm_id          Varchar2,
        p_oscd_id          Varchar2,
        p_projno           Varchar2,
        p_wpcode           Varchar2,
        p_activity         Varchar2,
        p_hours            Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno          Varchar2(5);
        v_is_lock        ts_osc_mhrs_master.is_lock%Type;
        v_is_hod_approve ts_osc_mhrs_master.is_hod_approve%Type;
        v_is_post        ts_osc_mhrs_master.is_post%Type;
        v_yymm           ts_osc_mhrs_master.yymm%Type;
        v_count          Number;
        v_empno1         ts_osc_mhrs_master.empno%Type;
        v_assign         ts_osc_mhrs_master.assign%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        sp_get_status(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,

            p_oscm_id        => p_oscm_id,

            p_is_lock        => v_is_lock,
            p_is_hod_approve => v_is_hod_approve,
            p_is_post        => v_is_post,
            p_yymm           => v_yymm,
            p_message_type   => p_message_type,
            p_message_text   => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        sp_check_processing_month(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_yymm         => v_yymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If v_is_lock = not_ok Then
            Select
                empno, assign
            Into
                v_empno1, v_assign
            From
                ts_osc_mhrs_master
            Where
                oscm_id = Trim(p_oscm_id);
            sp_validate_data(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_costcode     => v_assign,
                p_empno        => v_empno1,
                p_projno       => p_projno,
                p_wpcode       => p_wpcode,
                p_activity     => p_activity,
                p_hours        => p_hours,
                p_mode_type    => 'UPDATE',

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;

            Select
                Count(oscd_id)
            Into
                v_count
            From
                ts_osc_mhrs_detail
            Where
                projno       = Trim(p_projno)
                And wpcode   = Trim(p_wpcode)
                And activity = p_activity
                And oscm_id  = Trim(p_oscm_id)
                And oscd_id != Trim(p_oscd_id);
            If v_count > 0 Then
                p_message_type := not_ok;
                p_message_text := 'Subcontract manhours already exists !!!.';
                Return;
            Else
                Update
                    ts_osc_mhrs_detail
                Set
                    projno = p_projno,
                    wpcode = p_wpcode,
                    activity = p_activity,
                    hours = p_hours,
                    modified_on = sysdate,
                    modified_by = Trim(v_empno)
                Where
                    oscd_id = Trim(p_oscd_id);

                sp_update_osc_mhrs_master(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_oscm_id      => p_oscm_id,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );

                Commit;

                p_message_type := ok;
                p_message_text := 'Procedure executed successfully.';
            End If;
        Else
            p_message_type := not_ok;
            p_message_text := 'Invalid month for Subcontract manhours updation !!!.';
        End If;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_osc_mhrs_detail;

    Procedure sp_delete_osc_mhrs_detail(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscm_id          Varchar2,
        p_oscd_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno          Varchar2(5);
        v_count          Number;
        v_is_lock        ts_osc_mhrs_master.is_lock%Type;
        v_is_hod_approve ts_osc_mhrs_master.is_hod_approve%Type;
        v_is_post        ts_osc_mhrs_master.is_post%Type;
        v_yymm           ts_osc_mhrs_master.yymm%Type;

        v_assign         ts_osc_mhrs_master.assign%Type;
        v_empno1         ts_osc_mhrs_master.empno%Type;
        v_projno         ts_osc_mhrs_detail.projno%Type;
        v_wpcode         ts_osc_mhrs_detail.wpcode%Type;
        v_activity       ts_osc_mhrs_detail.activity%Type;
        v_hours          ts_osc_mhrs_detail.hours%Type;

    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        sp_get_status(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,

            p_oscm_id        => p_oscm_id,

            p_is_lock        => v_is_lock,
            p_is_hod_approve => v_is_hod_approve,
            p_is_post        => v_is_post,
            p_yymm           => v_yymm,
            p_message_type   => p_message_type,
            p_message_text   => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        sp_check_processing_month(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_yymm         => v_yymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If v_is_lock = not_ok Then
            sp_get_timesheet_meta_props(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_oscm_id      => p_oscm_id,
                p_oscd_id      => p_oscd_id,

                p_assign       => v_assign,
                p_empno        => v_empno1,
                p_projno       => v_projno,
                p_wpcode       => v_wpcode,
                p_activity     => v_activity,
                p_hours        => v_hours,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;

            sp_validate_data(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_costcode     => v_assign,
                p_empno        => v_empno1,
                p_projno       => v_projno,
                p_wpcode       => v_wpcode,
                p_activity     => v_activity,
                p_hours        => v_hours,
                p_mode_type    => 'DELETE',

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;

            Delete
                From ts_osc_mhrs_detail
            Where
                oscd_id = Trim(p_oscd_id);

            Select
                Count(oscd_id)
            Into
                v_count
            From
                ts_osc_mhrs_detail
            Where
                oscm_id = Trim(p_oscm_id);

            If v_count = 0 Then
                Delete
                    From ts_osc_mhrs_master
                Where
                    oscm_id = Trim(p_oscm_id);
            Else
                sp_update_osc_mhrs_master(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_oscm_id      => p_oscm_id,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;

            Commit;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Invalid month for Subcontract manhours deletion !!!.';
        End If;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_osc_mhrs_detail;

    Procedure sp_lock_osc_mhrs(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscm_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno          Varchar2(5);
        v_count          Number;
        v_is_lock        ts_osc_mhrs_master.is_lock%Type;
        v_is_hod_approve ts_osc_mhrs_master.is_hod_approve%Type;
        v_is_post        ts_osc_mhrs_master.is_post%Type;
        v_yymm           ts_osc_mhrs_master.yymm%Type;

        v_assign         ts_osc_mhrs_master.assign%Type;
        v_empno1         ts_osc_mhrs_master.empno%Type;
        v_projno         ts_osc_mhrs_detail.projno%Type;
        v_wpcode         ts_osc_mhrs_detail.wpcode%Type;
        v_activity       ts_osc_mhrs_detail.activity%Type;
        v_hours          ts_osc_mhrs_detail.hours%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        sp_get_status(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,

            p_oscm_id        => p_oscm_id,

            p_is_lock        => v_is_lock,
            p_is_hod_approve => v_is_hod_approve,
            p_is_post        => v_is_post,
            p_yymm           => v_yymm,
            p_message_type   => p_message_type,
            p_message_text   => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        sp_check_processing_month(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_yymm         => v_yymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If v_is_lock = not_ok And v_is_hod_approve = not_ok And v_is_post = not_ok Then
            sp_get_timesheet_meta_props(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_oscm_id      => p_oscm_id,
                p_oscd_id      => Null,

                p_assign       => v_assign,
                p_empno        => v_empno1,
                p_projno       => v_projno,
                p_wpcode       => v_wpcode,
                p_activity     => v_activity,
                p_hours        => v_hours,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;

            sp_validate_data(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_costcode     => v_assign,
                p_empno        => v_empno1,
                p_projno       => v_projno,
                p_wpcode       => v_wpcode,
                p_activity     => v_activity,
                p_hours        => v_hours,
                p_mode_type    => 'LOCK',

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;

            Update
                ts_osc_mhrs_master
            Set
                is_lock = ok,
                lock_modified_on = sysdate,
                lock_modified_by = v_empno,
                modified_on = sysdate,
                modified_by = v_empno
            Where
                oscm_id = Trim(p_oscm_id);

            Commit;

            p_message_type := ok;
            p_message_text := 'Manhours locked successfully.';            
        ElsIf v_is_lock = ok Then
            p_message_type := ok;
            p_message_text := 'Already locked !!!';
            Return;            
        Else
            p_message_type := not_ok;
            p_message_text := 'Cannot lock manhours !!!';
            Return;
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_lock_osc_mhrs;

    Procedure sp_hod_approve_osc_mhrs(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
                
        p_oscm_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_hours          ts_osc_mhrs_master.hours%Type;
        v_count          Number;
        v_is_lock        ts_osc_mhrs_master.is_lock%Type;
        v_is_hod_approve ts_osc_mhrs_master.is_hod_approve%Type;
        v_is_post        ts_osc_mhrs_master.is_post%Type;
        v_yymm           ts_osc_mhrs_master.yymm%Type;
        v_empno          Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
    
        sp_get_status(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,

            p_oscm_id        => p_oscm_id,

            p_is_lock        => v_is_lock,
            p_is_hod_approve => v_is_hod_approve,
            p_is_post        => v_is_post,
            p_yymm           => v_yymm,
            p_message_type   => p_message_type,
            p_message_text   => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        sp_check_processing_month(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,
            
            p_yymm         => v_yymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If v_is_lock = ok And v_is_hod_approve = not_ok And v_is_post = not_ok Then
            Update
                ts_osc_mhrs_master
            Set
                is_hod_approve = ok,
                hod_approve_modified_on = sysdate,
                hod_approve_modified_by = v_empno,
                modified_on = sysdate,
                modified_by = v_empno
            Where
                oscm_id = Trim(p_oscm_id);

            Commit;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';        
        ElsIf v_is_hod_approve = ok Then
            p_message_type := ok;
            p_message_text := 'Already approved !!!';
            Return;            
        Else
            p_message_type := not_ok;
            p_message_text := 'Cannot approve manhours !!!';
            Return;
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_hod_approve_osc_mhrs;

    Procedure sp_post_osc_mhrs(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
            
        p_oscm_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_hours          ts_osc_mhrs_master.hours%Type;
        v_count          Number;
        v_is_lock        ts_osc_mhrs_master.is_lock%Type;
        v_is_hod_approve ts_osc_mhrs_master.is_hod_approve%Type;
        v_is_post        ts_osc_mhrs_master.is_post%Type;
        v_yymm           ts_osc_mhrs_master.yymm%Type;
        v_empno          Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
    
        sp_get_status(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,

            p_oscm_id        => p_oscm_id,

            p_is_lock        => v_is_lock,
            p_is_hod_approve => v_is_hod_approve,
            p_is_post        => v_is_post,
            p_yymm           => v_yymm,
            p_message_type   => p_message_type,
            p_message_text   => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        sp_check_processing_month(            
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,
            
            p_yymm         => v_yymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If v_is_lock = ok And v_is_hod_approve = ok And v_is_post = not_ok Then
            Update
                ts_osc_mhrs_master
            Set
                is_post = ok,
                post_modified_on = sysdate,
                post_modified_by = v_empno,
                modified_on = sysdate,
                modified_by = v_empno
            Where
                oscm_id = Trim(p_oscm_id);

            sp_insert_into_timetran(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                
                p_oscm_id      => p_oscm_id,

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

            Commit;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';            
        ElsIf v_is_post = ok Then
            p_message_type := ok;
            p_message_text := 'Already posted !!!';
            Return;            
        Else
            p_message_type := not_ok;
            p_message_text := 'Cannot Post manhours !!!';
            Return;
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_post_osc_mhrs;

    Procedure sp_unlock_osc_mhrs(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscm_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno          Varchar2(5);
        v_count          Number;
        v_is_lock        ts_osc_mhrs_master.is_lock%Type;
        v_is_hod_approve ts_osc_mhrs_master.is_hod_approve%Type;
        v_is_post        ts_osc_mhrs_master.is_post%Type;
        v_yymm           ts_osc_mhrs_master.yymm%Type;

        v_assign         ts_osc_mhrs_master.assign%Type;
        v_empno1         ts_osc_mhrs_master.empno%Type;
        v_projno         ts_osc_mhrs_detail.projno%Type;
        v_wpcode         ts_osc_mhrs_detail.wpcode%Type;
        v_activity       ts_osc_mhrs_detail.activity%Type;
        v_hours          ts_osc_mhrs_detail.hours%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        sp_get_status(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,

            p_oscm_id        => p_oscm_id,

            p_is_lock        => v_is_lock,
            p_is_hod_approve => v_is_hod_approve,
            p_is_post        => v_is_post,
            p_yymm           => v_yymm,
            p_message_type   => p_message_type,
            p_message_text   => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        sp_check_processing_month(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_yymm         => v_yymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If v_is_lock = ok And v_is_hod_approve = not_ok And v_is_post = not_ok Then
            sp_get_timesheet_meta_props(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_oscm_id      => p_oscm_id,
                p_oscd_id      => Null,

                p_assign       => v_assign,
                p_empno        => v_empno1,
                p_projno       => v_projno,
                p_wpcode       => v_wpcode,
                p_activity     => v_activity,
                p_hours        => v_hours,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;

            sp_validate_data(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_costcode     => v_assign,
                p_empno        => v_empno1,
                p_projno       => v_projno,
                p_wpcode       => v_wpcode,
                p_activity     => v_activity,
                p_hours        => v_hours,
                p_mode_type    => 'UNLOCK',

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;

            Update
                ts_osc_mhrs_master
            Set
                is_lock = not_ok,
                lock_modified_on = sysdate,
                lock_modified_by = v_empno,
                modified_on = sysdate,
                modified_by = v_empno
            Where
                oscm_id = Trim(p_oscm_id);

            Commit;

            p_message_type := ok;
            p_message_text := 'Manhours unlocked successfully.';        
        ElsIf v_is_lock = not_ok Then
            p_message_type := ok;
            p_message_text := 'Already unlocked !!!';
            Return;            
        Else
            p_message_type := not_ok;
            p_message_text := 'Cannot unlock manhours !!!';
            Return;
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_unlock_osc_mhrs;

    Procedure sp_hod_disapprove_osc_mhrs(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,    
        
        p_oscm_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_hours          ts_osc_mhrs_master.hours%Type;
        v_count          Number;
        v_is_lock        ts_osc_mhrs_master.is_lock%Type;
        v_is_hod_approve ts_osc_mhrs_master.is_hod_approve%Type;
        v_is_post        ts_osc_mhrs_master.is_post%Type;
        v_yymm           ts_osc_mhrs_master.yymm%Type;
        v_empno          Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
    
        sp_get_status(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,

            p_oscm_id        => p_oscm_id,

            p_is_lock        => v_is_lock,
            p_is_hod_approve => v_is_hod_approve,
            p_is_post        => v_is_post,
            p_yymm           => v_yymm,
            p_message_type   => p_message_type,
            p_message_text   => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        sp_check_processing_month(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,
            
            p_yymm         => v_yymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If v_is_lock = ok And v_is_hod_approve = ok And v_is_post = not_ok Then
            Update
                ts_osc_mhrs_master
            Set
                is_hod_approve = not_ok,
                hod_approve_modified_on = sysdate,
                hod_approve_modified_by = v_empno,
                modified_on = sysdate,
                modified_by = v_empno
            Where
                oscm_id = Trim(p_oscm_id);

            Commit;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';        
        ElsIf v_is_hod_approve = not_ok Then
            p_message_type := ok;
            p_message_text := 'Already approval is revoked !!!';
            Return;            
        Else
            p_message_type := not_ok;
            p_message_text := 'Cannot disapprove manhours !!!';
            Return;
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_hod_disapprove_osc_mhrs;

    Procedure sp_unpost_osc_mhrs(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
            
        p_oscm_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_hours          ts_osc_mhrs_master.hours%Type;
        v_count          Number;
        v_is_lock        ts_osc_mhrs_master.is_lock%Type;
        v_is_hod_approve ts_osc_mhrs_master.is_hod_approve%Type;
        v_is_post        ts_osc_mhrs_master.is_post%Type;
        v_yymm           ts_osc_mhrs_master.yymm%Type;        
        v_empno          Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
    
        sp_get_status(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,

            p_oscm_id        => p_oscm_id,

            p_is_lock        => v_is_lock,
            p_is_hod_approve => v_is_hod_approve,
            p_is_post        => v_is_post,
            p_yymm           => v_yymm,
            p_message_type   => p_message_type,
            p_message_text   => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        sp_check_processing_month(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,
            
            p_yymm         => v_yymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If v_is_lock = ok And v_is_hod_approve = ok And v_is_post = ok Then
            Update
                ts_osc_mhrs_master
            Set
                is_post = not_ok,
                post_modified_on = sysdate,
                post_modified_by = v_empno,
                modified_on = sysdate,
                modified_by = v_empno
            Where
                oscm_id = Trim(p_oscm_id);

            sp_delete_from_timetran(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                
                p_oscm_id      => p_oscm_id,

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

            Commit;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        ElsIf v_is_post = not_ok Then
            p_message_type := ok;
            p_message_text := 'Already unposted !!!';
            Return;
        Else
            p_message_type := not_ok;
            p_message_text := 'Cannot UnPost manhours !!!';
            Return;
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_unpost_osc_mhrs;

    Procedure sp_repost_osc_hrs(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        sp_check_processing_month(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_yymm         => p_yymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        Delete
            From timetran
        Where
            (yymm, empno, parent, costcode) In
            (
                Select
                    yymm,
                    empno,
                    parent,
                    assign
                From
                    ts_osc_mhrs_master
                Where
                    yymm = Trim(p_yymm)
            );

        Update
            ts_osc_mhrs_master
        Set
            is_post = ok,
            post_modified_on = sysdate,
            post_modified_by = v_empno,
            modified_on = sysdate,
            modified_by = v_empno
        Where
            is_hod_approve = ok
            And is_post    = not_ok
            And yymm       = Trim(p_yymm);

        Insert Into timetran(
            yymm,
            empno,
            costcode,
            projno,
            wpcode,
            activity,
            grp,
            hours,
            othours,
            company,
            loaded,
            yymm_inv,
            parent)
        Select
            tomm.yymm,
            tomm.empno,
            tomm.assign,
            tomd.projno,
            tomd.wpcode,
            tomd.activity,
            c.tma_grp,
            tomd.hours,
            0,
            'TICB',
            Null,
            Null,
            tomm.parent
        From
            ts_osc_mhrs_master tomm,
            ts_osc_mhrs_detail tomd,
            costmast           c
        Where
            tomm.oscm_id     = tomd.oscm_id
            And c.costcode   = tomm.assign
            And tomm.is_post = ok
            And tomm.yymm    = Trim(p_yymm);

        Commit;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_repost_osc_hrs;

End pkg_ts_osc_mhrs;