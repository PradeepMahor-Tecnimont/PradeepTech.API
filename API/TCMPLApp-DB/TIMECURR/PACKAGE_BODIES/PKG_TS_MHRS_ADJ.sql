--------------------------------------------------------
--  DDL for Package Body PKG_TS_MHRS_ADJ
--------------------------------------------------------

Create Or Replace Package Body timecurr.pkg_ts_mhrs_adj As

    Procedure prc_get_last_date_month(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_yymm             Varchar2,
        p_last_date    Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        /*v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;*/

        p_last_date    := To_Number (to_char(
                              last_day(To_Date(p_yymm || '01', 'YYYYMMDD')), 'DD'
                          ));

        p_message_type := ok;
        p_message_text := 'Success';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_get_last_date_month;

    Procedure prc_validate_costcode_data(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_costcode         Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno    Varchar2(5);
        v_costcode costmast.costcode%Type;
    Begin
        /*v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;*/

        Select
            c.costcode
        Into
            v_costcode
        From
            costmast  c,
            deptphase dp
        Where
            c.active = 1
            And c.costcode = dp.costcode
            And dp.isprimary = 1
            And c.costcode = Trim(p_costcode);

        p_message_type := ok;
        p_message_text := 'Assign is valid.';
    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'Assign is not valid. !!! ';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_validate_costcode_data;

    Procedure prc_validate_empno_data(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_empno            Varchar2,
        p_empno_new    Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno       Varchar2(5);
        v_empno_user  emplmast.empno%Type;
        v_metaid_user emplmast.metaid%Type;
    Begin
        /*v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;*/

        Select
            e.empno,
            e.metaid
        Into
            v_empno_user,
            v_metaid_user
        From
            emplmast e
        Where
            e.status = 1
            And e.empno = Trim(p_empno);

        p_empno_new    := v_empno_user;
        p_message_type := ok;
        p_message_text := 'Empno is valid.';
    Exception
        When no_data_found Then
            Begin
                Select
                    e.empno
                Into
                    v_empno_user
                From
                    emplmast e
                Where
                    e.status = 1
                    And e.metaid = Trim(v_metaid_user);
                p_empno_new    := v_empno_user;
                p_message_type := ok;
                p_message_text := 'Empno is valid.';
            Exception
                When no_data_found Then
                    p_message_type := not_ok;
                    p_message_text := 'Empno is not valid.';
                When Others Then
                    p_message_type := not_ok;
                    p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
            End;
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_validate_empno_data;

    Procedure prc_validate_projno_data(
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
        /*v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;*/

        Select
            p.projno
        Into
            v_projno
        From
            projmast p,
            tsconfig t
        Where
            p.active = 1
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
            And p.projno Not In (
                Select
                    projno
                From
                    job_lock
            )
            And substr(p.projno, 1, 5) Not In (
                Select
                    projno
                From
                    tm_leave
            )
            And p.projno = Trim(p_projno);

        p_message_type := ok;
        p_message_text := 'Project and Costcode are valid.';
    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'Project and Costcode are not valid.';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_validate_projno_data;

    Procedure prc_validate_wpcode_data(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_wpcode           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno  Varchar2(5);
        v_wpcode time_wpcode.wpcode%Type;
    Begin
        /*v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;*/

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
    End prc_validate_wpcode_data;

    Procedure prc_validate_activity_data(
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
        /*v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;*/

        Select
            activity
        Into
            v_activity
        From
            act_mast
        Where
            costcode = Trim(p_costcode)
            And active = 1
            And activity = p_activity;

        p_message_type := ok;
        p_message_text := 'Activity is valid.';
    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'Activity / Costcode is not valid.';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_validate_activity_data;

    Procedure prc_validate_data(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_costcode         Varchar2,
        p_wpcode           Varchar2,
        p_activity         Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        /*v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;   */

        prc_validate_wpcode_data(
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

        prc_validate_activity_data(
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

        p_message_type := ok;
        p_message_text := 'Data is valid.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_validate_data;

    Procedure prc_check_processing_month(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_yymm                Varchar2,
        p_yymm_pros_month Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_empno      Varchar2(5);
        v_pros_month tsconfig.pros_month%Type;
    Begin
        /*v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;*/

        Select
            pros_month
        Into
            v_pros_month
        From
            tsconfig;

        If To_Number (v_pros_month) = To_Number (p_yymm) Then
            p_message_type := not_ok;
            p_message_text := 'Invalid month for manhours adjustment processing !!!.';
            Return;
        Else
            p_yymm_pros_month := v_pros_month;
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_check_processing_month;

    Procedure prc_process_timetran(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_yymm             Varchar2,
        p_empno            Varchar2,
        p_assign           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno    Varchar2(5);
        row_locked Exception;
        Pragma exception_init(row_locked, -54);
    Begin
        /*v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;*/

        Begin
            Select
                empno
            Into
                v_empno
            From
                timetran
            Where
                costcode = Trim(p_assign)
                And empno = Trim(p_empno)
                And yymm = Trim(p_yymm)
            For Update Nowait;
        Exception
            When no_data_found Then
                Null;
            When row_locked Then
                p_message_type := not_ok;
                p_message_text := 'Timesheet is in use';
                Return;
        End;

        Delete
            From timetran
        Where
            costcode = Trim(p_assign)
            And empno = Trim(p_empno)
            And yymm = Trim(p_yymm);
        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_process_timetran;

    Procedure prc_time_adj_log(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_log_id           Varchar2 Default Null,
        p_yymm_from        Varchar2,
        p_yymm_to          Varchar2,
        p_projno_from      Varchar2,
        p_projno_to        Varchar2,
        p_message_type_in  Varchar2,
        p_message_text_in  Varchar2,
        p_log_id_out   Out Varchar2,
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

        If p_log_id Is Null Then
            Insert Into time_adj_log (
                log_id,
                yymm_from,
                yymm_to,
                projno_from,
                projno_to,
                modified_by,
                modified_on,
                message_type,
                message_text
            )
            Values (
                dbms_random.string('X', 10),
                p_yymm_from,
                p_yymm_to,
                p_projno_from,
                p_projno_to,
                v_empno,
                sysdate,
                p_message_type_in,
                p_message_text_in
            )
            Returning log_id
                Into p_log_id_out;
        Else
            Update
                time_adj_log
            Set
                message_type = p_message_type_in,
                message_text = p_message_text_in,
                modified_on = sysdate
            Where
                log_id = p_log_id;
            p_log_id_out := p_log_id;
        End If;

        p_message_type := p_message_type_in;
        p_message_text := p_message_text_in;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_time_adj_log;

    Procedure prc_time_mast_adj_log(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,
        p_log_id               Varchar2,
        p_time_mast_id         Varchar2 Default Null,
        p_yymm                 Varchar2 Default Null,
        p_empno                Varchar2 Default Null,
        p_empno_to             Varchar2 Default Null,
        p_parent               Varchar2 Default Null,
        p_assign               Varchar2 Default Null,
        p_grp                  Varchar2 Default Null,
        p_company              Varchar2 Default Null,
        p_tot_nhr              Number   Default Null,
        p_tot_ohr              Number   Default Null,
        p_exceed               Number   Default Null,
        p_message_type_in      Varchar2,
        p_message_text_in      Varchar2,
        p_time_mast_id_out Out Varchar2,
        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_time_mast_id Is Null Then
            Insert Into time_mast_adj_log (
                time_mast_id,
                log_id,
                yymm,
                empno,
                parent,
                assign,
                locked,
                approved,
                posted,
                appr_on,
                grp,
                tot_nhr,
                tot_ohr,
                company,
                remark,
                exceed,
                modified_by,
                modified_on,
                message_type,
                message_text
            )
            Values (
                dbms_random.string('X', 10),
                p_log_id,
                p_yymm,
                p_empno_to,
                p_parent,
                p_assign,
                0,
                0,
                0,
                Null,
                p_grp,
                0,
                0,
                p_company,
                Null,
                0,
                v_empno,
                sysdate,
                p_message_type_in,
                p_message_text_in
            )
            Returning time_mast_id
                Into p_time_mast_id_out;

        Else
            Update
                time_mast_adj_log
            Set
                grp = p_grp,
                company = p_company,
                tot_nhr = p_tot_nhr,
                tot_ohr = p_tot_ohr,
                exceed = p_exceed,
                message_type = p_message_type_in,
                message_text = p_message_text_in,
                modified_on = sysdate
            Where
                time_mast_id = p_time_mast_id;
            p_time_mast_id_out := p_time_mast_id;
        End If;

        p_message_type := p_message_type_in;
        p_message_text := p_message_text_in;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_time_mast_adj_log;

    Procedure prc_time_daily_adj_log(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_log_id                Varchar2,
        p_time_mast_id          Varchar2,
        p_time_daily_id         Varchar2 Default Null,
        p_yymm                  Varchar2 Default Null,
        p_empno                 Varchar2 Default Null,
        p_empno_to              Varchar2 Default Null,
        p_parent                Varchar2 Default Null,
        p_assign                Varchar2 Default Null,
        p_projno                Varchar2 Default Null,
        p_wpcode                Varchar2 Default Null,
        p_activity              Varchar2 Default Null,
        p_d1                    Number   Default 0,
        p_d2                    Number   Default 0,
        p_d3                    Number   Default 0,
        p_d4                    Number   Default 0,
        p_d5                    Number   Default 0,
        p_d6                    Number   Default 0,
        p_d7                    Number   Default 0,
        p_d8                    Number   Default 0,
        p_d9                    Number   Default 0,
        p_d10                   Number   Default 0,
        p_d11                   Number   Default 0,
        p_d12                   Number   Default 0,
        p_d13                   Number   Default 0,
        p_d14                   Number   Default 0,
        p_d15                   Number   Default 0,
        p_d16                   Number   Default 0,
        p_d17                   Number   Default 0,
        p_d18                   Number   Default 0,
        p_d19                   Number   Default 0,
        p_d20                   Number   Default 0,
        p_d21                   Number   Default 0,
        p_d22                   Number   Default 0,
        p_d23                   Number   Default 0,
        p_d24                   Number   Default 0,
        p_d25                   Number   Default 0,
        p_d26                   Number   Default 0,
        p_d27                   Number   Default 0,
        p_d28                   Number   Default 0,
        p_d29                   Number   Default 0,
        p_d30                   Number   Default 0,
        p_d31                   Number   Default 0,
        p_total                 Number   Default 0,
        p_grp                   Varchar2 Default Null,
        p_company               Varchar2 Default Null,
        p_message_type_in       Varchar2,
        p_message_text_in       Varchar2,
        p_time_daily_id_out Out Varchar2,
        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_time_daily_id Is Null Then
            Insert Into time_daily_adj_log (
                time_daily_id,
                time_mast_id,
                yymm,
                empno,
                parent,
                assign,
                projno,
                wpcode,
                activity,
                d1,
                d2,
                d3,
                d4,
                d5,
                d6,
                d7,
                d8,
                d9,
                d10,
                d11,
                d12,
                d13,
                d14,
                d15,
                d16,
                d17,
                d18,
                d19,
                d20,
                d21,
                d22,
                d23,
                d24,
                d25,
                d26,
                d27,
                d28,
                d29,
                d30,
                d31,
                total,
                grp,
                company,
                modified_by,
                modified_on,
                message_type,
                message_text
            )
            Values (
                dbms_random.string('X', 10),
                p_time_mast_id,
                p_yymm,
                p_empno_to,
                p_parent,
                p_assign,
                p_projno,
                p_wpcode,
                p_activity,
                p_d1,
                p_d2,
                p_d3,
                p_d4,
                p_d5,
                p_d6,
                p_d7,
                p_d8,
                p_d9,
                p_d10,
                p_d11,
                p_d12,
                p_d13,
                p_d14,
                p_d15,
                p_d16,
                p_d17,
                p_d18,
                p_d19,
                p_d20,
                p_d21,
                p_d22,
                p_d23,
                p_d24,
                p_d25,
                p_d26,
                p_d27,
                p_d28,
                p_d29,
                p_d30,
                p_d31,
                p_total,
                p_grp,
                p_company,
                v_empno,
                sysdate,
                p_message_type_in,
                p_message_text_in
            )
            Returning time_daily_id
                Into p_time_daily_id_out;
        Else
            Update
                time_daily_adj_log
            Set
                d1 = p_d1,
                d2 = p_d2,
                d3 = p_d3,
                d4 = p_d4,
                d5 = p_d5,
                d6 = p_d6,
                d7 = p_d7,
                d8 = p_d8,
                d9 = p_d9,
                d10 = p_d10,
                d11 = p_d11,
                d12 = p_d12,
                d13 = p_d13,
                d14 = p_d14,
                d15 = p_d15,
                d16 = p_d16,
                d17 = p_d17,
                d18 = p_d18,
                d19 = p_d19,
                d20 = p_d20,
                d21 = p_d21,
                d22 = p_d22,
                d23 = p_d23,
                d24 = p_d24,
                d25 = p_d25,
                d26 = p_d26,
                d27 = p_d27,
                d28 = p_d28,
                d29 = p_d29,
                d30 = p_d30,
                d31 = p_d31,
                total = p_total,
                message_type = p_message_type_in,
                message_text = p_message_text_in,
                modified_on = sysdate
            Where
                time_daily_id = p_time_daily_id;
            p_time_daily_id_out := p_time_daily_id;
        End If;

        p_message_type := p_message_type_in;
        p_message_text := p_message_text_in;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_time_daily_adj_log;

    Procedure prc_time_ot_adj_log(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,
        p_log_id             Varchar2,
        p_time_mast_id       Varchar2,
        p_time_ot_id         Varchar2 Default Null,
        p_yymm               Varchar2 Default Null,
        p_empno              Varchar2 Default Null,
        p_empno_to           Varchar2 Default Null,
        p_parent             Varchar2 Default Null,
        p_assign             Varchar2 Default Null,
        p_projno             Varchar2 Default Null,
        p_wpcode             Varchar2 Default Null,
        p_activity           Varchar2 Default Null,
        p_d1                 Number   Default 0,
        p_d2                 Number   Default 0,
        p_d3                 Number   Default 0,
        p_d4                 Number   Default 0,
        p_d5                 Number   Default 0,
        p_d6                 Number   Default 0,
        p_d7                 Number   Default 0,
        p_d8                 Number   Default 0,
        p_d9                 Number   Default 0,
        p_d10                Number   Default 0,
        p_d11                Number   Default 0,
        p_d12                Number   Default 0,
        p_d13                Number   Default 0,
        p_d14                Number   Default 0,
        p_d15                Number   Default 0,
        p_d16                Number   Default 0,
        p_d17                Number   Default 0,
        p_d18                Number   Default 0,
        p_d19                Number   Default 0,
        p_d20                Number   Default 0,
        p_d21                Number   Default 0,
        p_d22                Number   Default 0,
        p_d23                Number   Default 0,
        p_d24                Number   Default 0,
        p_d25                Number   Default 0,
        p_d26                Number   Default 0,
        p_d27                Number   Default 0,
        p_d28                Number   Default 0,
        p_d29                Number   Default 0,
        p_d30                Number   Default 0,
        p_d31                Number   Default 0,
        p_total              Number   Default 0,
        p_grp                Varchar2 Default Null,
        p_company            Varchar2 Default Null,
        p_message_type_in    Varchar2,
        p_message_text_in    Varchar2,
        p_time_ot_id_out Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_time_ot_id Is Null Then
            Insert Into time_ot_adj_log (
                time_ot_id,
                time_mast_id,
                yymm,
                empno,
                parent,
                assign,
                projno,
                wpcode,
                activity,
                d1,
                d2,
                d3,
                d4,
                d5,
                d6,
                d7,
                d8,
                d9,
                d10,
                d11,
                d12,
                d13,
                d14,
                d15,
                d16,
                d17,
                d18,
                d19,
                d20,
                d21,
                d22,
                d23,
                d24,
                d25,
                d26,
                d27,
                d28,
                d29,
                d30,
                d31,
                total,
                grp,
                company,
                modified_by,
                modified_on,
                message_type,
                message_text
            )
            Values (
                dbms_random.string('X', 10),
                p_time_mast_id,
                p_yymm,
                p_empno_to,
                p_parent,
                p_assign,
                p_projno,
                p_wpcode,
                p_activity,
                p_d1,
                p_d2,
                p_d3,
                p_d4,
                p_d5,
                p_d6,
                p_d7,
                p_d8,
                p_d9,
                p_d10,
                p_d11,
                p_d12,
                p_d13,
                p_d14,
                p_d15,
                p_d16,
                p_d17,
                p_d18,
                p_d19,
                p_d20,
                p_d21,
                p_d22,
                p_d23,
                p_d24,
                p_d25,
                p_d26,
                p_d27,
                p_d28,
                p_d29,
                p_d30,
                p_d31,
                p_total,
                p_grp,
                p_company,
                v_empno,
                sysdate,
                p_message_type_in,
                p_message_text_in
            )
            Returning time_ot_id
                Into p_time_ot_id_out;
        Else
            Update
                time_ot_adj_log
            Set
                d1 = p_d1,
                d2 = p_d2,
                d3 = p_d3,
                d4 = p_d4,
                d5 = p_d5,
                d6 = p_d6,
                d7 = p_d7,
                d8 = p_d8,
                d9 = p_d9,
                d10 = p_d10,
                d11 = p_d11,
                d12 = p_d12,
                d13 = p_d13,
                d14 = p_d14,
                d15 = p_d15,
                d16 = p_d16,
                d17 = p_d17,
                d18 = p_d18,
                d19 = p_d19,
                d20 = p_d20,
                d21 = p_d21,
                d22 = p_d22,
                d23 = p_d23,
                d24 = p_d24,
                d25 = p_d25,
                d26 = p_d26,
                d27 = p_d27,
                d28 = p_d28,
                d29 = p_d29,
                d30 = p_d30,
                d31 = p_d31,
                total = p_total,
                message_type = p_message_type_in,
                message_text = p_message_text_in,
                modified_on = sysdate
            Where
                time_ot_id = p_time_ot_id;
            p_time_ot_id_out := p_time_ot_id;
        End If;

        p_message_type := p_message_type_in;
        p_message_text := p_message_text_in;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_time_ot_adj_log;

    Procedure prc_process_time_mast_before(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,
        p_yymm_from          Varchar2,
        p_yymm_to            Varchar2,
        p_empno              Varchar2,
        p_empno_to           Varchar2,
        p_parent             Varchar2,
        p_assign             Varchar2,
        p_parent_current Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_empno              Varchar2(5);
        v_user_empno         Varchar2(5);
        v_rec_time_mast_from time_mast%rowtype;
        v_rec_time_mast_to   time_mast%rowtype;
        v_parent             emplmast.parent%Type;
        row_locked           Exception;
        Pragma exception_init(row_locked, -54);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            *
        Into
            v_rec_time_mast_from
        From
            time_mast
        Where
            assign = Trim(p_assign)
            And parent = Trim(p_parent)
            And empno = Trim(p_empno)
            And yymm = Trim(p_yymm_from);

        Begin
            Select
                *
            Into
                v_rec_time_mast_to
            From
                time_mast
            Where
                assign = Trim(p_assign)
                And empno = Trim(p_empno_to)
                And yymm = Trim(p_yymm_to)
            For Update Nowait;

            If v_rec_time_mast_to.posted = 1 Then
                prc_process_timetran(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,
                    p_yymm         => p_yymm_to,
                    p_empno        => p_empno_to,
                    p_assign       => p_assign,
                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;

            Update
                time_mast
            Set
                locked = 0,
                approved = 0,
                posted = 0,
                appr_on = sysdate,
                tot_nhr = 0,
                tot_ohr = 0,
                exceed = 0
            Where
                parent = Trim(v_rec_time_mast_to.parent)
                And assign = Trim(p_assign)
                And empno = Trim(p_empno_to)
                And yymm = Trim(p_yymm_to);

            p_parent_current := v_rec_time_mast_to.parent;
        Exception
            When no_data_found Then
                Select
                    parent
                Into
                    v_rec_time_mast_to.parent
                From
                    emplmast
                Where
                    status = 1
                    And empno = Trim(p_empno);

                Insert Into time_mast (
                    yymm,
                    empno,
                    parent,
                    assign,
                    locked,
                    approved,
                    posted,
                    appr_on,
                    grp,
                    tot_nhr,
                    tot_ohr,
                    company,
                    remark,
                    exceed
                )
                Values (
                    p_yymm_to,
                    p_empno_to,
                    v_rec_time_mast_to.parent,
                    p_assign,
                    0,
                    0,
                    0,
                    Null,
                    v_rec_time_mast_from.grp,
                    0,
                    0,
                    v_rec_time_mast_from.company,
                    Null,
                    0
                );

                p_parent_current := v_rec_time_mast_to.parent;
                p_message_type   := ok;
                p_message_text   := 'Success - Started';
            When row_locked Then
                p_message_type := not_ok;
                p_message_text := 'Timesheet is in use';
                Return;
        End;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_process_time_mast_before;

    Procedure prc_process_time_mast_after(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_yymm             Varchar2,
        p_empno            Varchar2,
        p_empno_to         Varchar2,
        p_parent           Varchar2,
        p_assign           Varchar2,
        p_tot_nhr      Out Number,
        p_tot_ohr      Out Number,
        p_exceed       Out Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno           Varchar2(5);
        v_total_hrs_daily time_daily.total%Type;
        v_total_hrs_ot    time_ot.total%Type;
        v_exceed          time_mast.exceed%Type;
        row_locked        Exception;
        Pragma exception_init(row_locked, -54);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Sum(nvl(total, 0))
        Into
            v_total_hrs_daily
        From
            time_daily
        Where
            assign = Trim(p_assign)
            And parent = Trim(p_parent)
            And empno = Trim(p_empno_to)
            And yymm = Trim(p_yymm);

        Select
            Sum(nvl(total, 0))
        Into
            v_total_hrs_ot
        From
            time_ot
        Where
            assign = Trim(p_assign)
            And parent = Trim(p_parent)
            And empno = Trim(p_empno_to)
            And yymm = Trim(p_yymm);

        If v_total_hrs_daily + v_total_hrs_ot > 240 Then
            v_exceed := 1;
        End If;
        Update
            time_mast
        Set
            locked = 0,
            approved = 0,
            posted = 0,
            appr_on = sysdate,
            tot_nhr = v_total_hrs_daily,
            tot_ohr = v_total_hrs_ot,
            exceed = v_exceed
        Where
            parent = Trim(p_parent)
            And assign = Trim(p_assign)
            And empno = Trim(p_empno_to)
            And yymm = Trim(p_yymm);

        p_tot_nhr      := v_total_hrs_daily;
        p_tot_ohr      := v_total_hrs_ot;
        p_exceed       := v_exceed;
        p_message_type := ok;
        p_message_text := 'Success - Finished';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_process_time_mast_after;

    Procedure prc_process_time_daily(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_log_id           Varchar2,
        p_time_mast_id     Varchar2,
        p_projno_from      Varchar2,
        p_yymm             Varchar2,
        p_empno            Varchar2,
        p_empno_to         Varchar2,
        p_parent           Varchar2,
        p_assign           Varchar2,
        p_projno_to        Varchar2,
        p_wpcode           Varchar2,
        p_activity         Varchar2,
        p_total            Number,
        p_grp              Varchar2,
        p_company          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno           Varchar2(5);
        v_empno_user      Varchar2(5);
        time_daily_rec    time_daily%rowtype;
        v_last_date       Number;
        row_locked        Exception;
        Pragma exception_init(row_locked, -54);
        v_time_daily_id   Varchar2(10);
        v_message_type_in Varchar2(2);
        v_message_text_in Varchar2(4000);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        --validate data
        prc_validate_data(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,
            p_costcode     => p_assign,
            p_wpcode       => c_wpcode,
            p_activity     => p_activity,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        
        --process time_daily log 
        prc_time_daily_adj_log(
            p_person_id         => p_person_id,
            p_meta_id           => p_meta_id,
            p_log_id            => p_log_id,
            p_time_mast_id      => p_time_mast_id,
            p_yymm              => p_yymm,
            p_empno             => p_empno,
            p_empno_to          => p_empno_to,
            p_parent            => p_parent,
            p_assign            => p_assign,
            p_projno            => p_projno_to,
            p_wpcode            => c_wpcode,
            p_activity          => p_activity,
            p_total             => p_total,
            p_grp               => p_grp,
            p_company           => p_company,
            p_message_type_in   => p_message_type,
            p_message_text_in   => p_message_text,
            p_time_daily_id_out => v_time_daily_id,
            p_message_type      => p_message_type,
            p_message_text      => p_message_text
        );

        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        Begin
            Select
                empno
            Into
                v_empno_user
            From
                time_daily
            Where
                yymm = Trim(p_yymm)
                And empno = (p_empno_to)
                And parent = (p_parent)
                And assign = (p_assign)
                And projno = (p_projno_to)
                And wpcode = (c_wpcode)
                And activity = (p_activity)
            For Update Nowait;
        Exception
            When no_data_found Then
                Null;
            When row_locked Then
                p_message_type := not_ok;
                p_message_text := 'Timesheet is in use';
                Return;
        End;

        Delete
            From time_daily
        Where
            yymm = Trim(p_yymm)
            And empno = (p_empno_to)
            And parent = (p_parent)
            And assign = (p_assign)
            And projno = (p_projno_to)
            And wpcode = (c_wpcode)
            And activity = (p_activity);
        Commit;
        Insert Into time_daily (
            yymm,
            empno,
            parent,
            assign,
            projno,
            wpcode,
            activity,
            d1,
            d2,
            d3,
            d4,
            d5,
            d6,
            d7,
            d8,
            d9,
            d10,
            d11,
            d12,
            d13,
            d14,
            d15,
            d16,
            d17,
            d18,
            d19,
            d20,
            d21,
            d22,
            d23,
            d24,
            d25,
            d26,
            d27,
            d28,
            d29,
            d30,
            d31,
            total,
            grp,
            company
        )
        Values (
            p_yymm,
            p_empno_to,
            p_parent,
            p_assign,
            p_projno_to,
            c_wpcode,
            p_activity,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            p_total,
            p_grp,
            p_company
        );

        Select
            d1,
            d2,
            d3,
            d4,
            d5,
            d6,
            d7,
            d8,
            d9,
            d10,
            d11,
            d12,
            d13,
            d14,
            d15,
            d16,
            d17,
            d18,
            d19,
            d20,
            d21,
            d22,
            d23,
            d24,
            d25,
            d26,
            d27,
            d28,
            d29,
            d30,
            d31
        Into
            time_daily_rec.d1,
            time_daily_rec.d2,
            time_daily_rec.d3,
            time_daily_rec.d4,
            time_daily_rec.d5,
            time_daily_rec.d6,
            time_daily_rec.d7,
            time_daily_rec.d8,
            time_daily_rec.d9,
            time_daily_rec.d10,
            time_daily_rec.d11,
            time_daily_rec.d12,
            time_daily_rec.d13,
            time_daily_rec.d14,
            time_daily_rec.d15,
            time_daily_rec.d16,
            time_daily_rec.d17,
            time_daily_rec.d18,
            time_daily_rec.d19,
            time_daily_rec.d20,
            time_daily_rec.d21,
            time_daily_rec.d22,
            time_daily_rec.d23,
            time_daily_rec.d24,
            time_daily_rec.d25,
            time_daily_rec.d26,
            time_daily_rec.d27,
            time_daily_rec.d28,
            time_daily_rec.d29,
            time_daily_rec.d30,
            time_daily_rec.d31
        From
            (
                Select
                    level As d,
                    Case
                        When p_total - (c_99 * level) > 0 Then
                            99
                        Else
                            p_total - (c_99 * (level - 1))
                    End   As hrs
                From
                    dual
                Connect By level <= ceil(p_total / c_99)
                Union
                Select
                    Rownum As d,
                    0      hrs
                From
                    dual
                Connect By Rownum <= 31
            ) Pivot (
            Max(hrs)
            For (d)
            In ('1' As d1, '2' As d2, '3' As d3, '4' As d4, '5' As d5, '6' As d6, '7' As d7, '8' As d8, '9' As d9, '10' As
            d10, '11' As d11, '12' As d12, '13' As d13, '14' As d14, '15' As d15, '16' As d16, '17' As d17, '18' As d18,
            '19' As d19, '20' As d20, '21' As d21, '22' As d22, '23' As d23, '24' As d24, '25' As d25, '26' As d26, '27' As
            d27,
            '28' As d28, '29' As d29, '30' As d30, '31' As d31)
            );

        prc_get_last_date_month(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,
            p_yymm         => p_yymm,
            p_last_date    => v_last_date,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If v_last_date = 28 Then
            If time_daily_rec.d29 > 0 Or time_daily_rec.d30 > 0 Or time_daily_rec.d31 > 0 Then
                p_message_type := not_ok;
                p_message_text := 'Manhours found on 29th / 30th / 31st of the month';
                Return;
            End If;
        Elsif v_last_date = 29 Then
            If time_daily_rec.d30 > 0 Or time_daily_rec.d31 > 0 Then
                p_message_type := not_ok;
                p_message_text := 'Manhours found on 30th / 31st of the month';
                Return;
            End If;
        Elsif v_last_date = 30 Then
            If time_daily_rec.d31 > 0 Then
                p_message_type := not_ok;
                p_message_text := 'Manhours found on 31st of the month';
                Return;
            End If;
        End If;

        Update
            time_daily
        Set
            d1 = time_daily_rec.d1,
            d2 = time_daily_rec.d2,
            d3 = time_daily_rec.d3,
            d4 = time_daily_rec.d4,
            d5 = time_daily_rec.d5,
            d6 = time_daily_rec.d6,
            d7 = time_daily_rec.d7,
            d8 = time_daily_rec.d8,
            d9 = time_daily_rec.d9,
            d10 = time_daily_rec.d10,
            d11 = time_daily_rec.d11,
            d12 = time_daily_rec.d12,
            d13 = time_daily_rec.d13,
            d14 = time_daily_rec.d14,
            d15 = time_daily_rec.d15,
            d16 = time_daily_rec.d16,
            d17 = time_daily_rec.d17,
            d18 = time_daily_rec.d18,
            d19 = time_daily_rec.d19,
            d20 = time_daily_rec.d20,
            d21 = time_daily_rec.d21,
            d22 = time_daily_rec.d22,
            d23 = time_daily_rec.d23,
            d24 = time_daily_rec.d24,
            d25 = time_daily_rec.d25,
            d26 = time_daily_rec.d26,
            d27 = time_daily_rec.d27,
            d28 = time_daily_rec.d28,
            d29 = time_daily_rec.d29,
            d30 = time_daily_rec.d30,
            d31 = time_daily_rec.d31
        Where
            yymm = Trim(p_yymm)
            And empno = (p_empno_to)
            And parent = (p_parent)
            And assign = (p_assign)
            And projno = (p_projno_to)
            And wpcode = (c_wpcode)
            And activity = (p_activity);

        prc_time_daily_adj_log(
            p_person_id         => p_person_id,
            p_meta_id           => p_meta_id,
            p_log_id            => p_log_id,
            p_time_mast_id      => p_time_mast_id,
            p_time_daily_id     => v_time_daily_id,
            p_yymm              => p_yymm,
            p_empno             => p_empno,
            p_empno_to          => p_empno_to,
            p_parent            => p_parent,
            p_assign            => p_assign,
            p_projno            => p_projno_to,
            p_wpcode            => c_wpcode,
            p_activity          => p_activity,
            p_d1                => time_daily_rec.d1,
            p_d2                => time_daily_rec.d2,
            p_d3                => time_daily_rec.d3,
            p_d4                => time_daily_rec.d4,
            p_d5                => time_daily_rec.d5,
            p_d6                => time_daily_rec.d6,
            p_d7                => time_daily_rec.d7,
            p_d8                => time_daily_rec.d8,
            p_d9                => time_daily_rec.d9,
            p_d10               => time_daily_rec.d10,
            p_d11               => time_daily_rec.d11,
            p_d12               => time_daily_rec.d12,
            p_d13               => time_daily_rec.d13,
            p_d14               => time_daily_rec.d14,
            p_d15               => time_daily_rec.d15,
            p_d16               => time_daily_rec.d16,
            p_d17               => time_daily_rec.d17,
            p_d18               => time_daily_rec.d18,
            p_d19               => time_daily_rec.d19,
            p_d20               => time_daily_rec.d20,
            p_d21               => time_daily_rec.d21,
            p_d22               => time_daily_rec.d22,
            p_d23               => time_daily_rec.d23,
            p_d24               => time_daily_rec.d24,
            p_d25               => time_daily_rec.d25,
            p_d26               => time_daily_rec.d26,
            p_d27               => time_daily_rec.d27,
            p_d28               => time_daily_rec.d28,
            p_d29               => time_daily_rec.d29,
            p_d30               => time_daily_rec.d30,
            p_d31               => time_daily_rec.d31,
            p_total             => p_total,
            p_grp               => p_grp,
            p_company           => p_company,
            p_message_type_in   => ok,
            p_message_text_in   => 'Procedure executed successfully',
            p_time_daily_id_out => v_time_daily_id,
            p_message_type      => p_message_type,
            p_message_text      => p_message_text
        );

        Begin
            Select
                empno
            Into
                v_empno_user
            From
                time_daily
            Where
                yymm = Trim(p_yymm)
                And empno = (p_empno_to)
                And parent = (p_parent)
                And assign = (p_assign)
                And projno = (p_projno_from)
                And wpcode = (c_wpcode)
                And activity = (p_activity)
            For Update Nowait;
        Exception
            When no_data_found Then
                Null;
            When row_locked Then
                p_message_type := not_ok;
                p_message_text := 'Timesheet is in use';
                Return;
        End;

        Delete
            From time_daily
        Where
            yymm = Trim(p_yymm)
            And empno = (p_empno_to)
            And parent = (p_parent)
            And assign = (p_assign)
            And projno = (p_projno_from)
            And wpcode = (c_wpcode)
            And activity = (p_activity);
        Commit;
        Insert Into time_daily(
            yymm,
            empno,
            parent,
            assign,
            projno,
            wpcode,
            activity,
            d1,
            d2,
            d3,
            d4,
            d5,
            d6,
            d7,
            d8,
            d9,
            d10,
            d11,
            d12,
            d13,
            d14,
            d15,
            d16,
            d17,
            d18,
            d19,
            d20,
            d21,
            d22,
            d23,
            d24,
            d25,
            d26,
            d27,
            d28,
            d29,
            d30,
            d31,
            total,
            grp,
            company)
        Select
            yymm,
            empno,
            parent,
            assign,
            p_projno_from,
            c_wpcode,
            activity,
            d1 * -1,
            d2 * -1,
            d3 * -1,
            d4 * -1,
            d5 * -1,
            d6 * -1,
            d7 * -1,
            d8 * -1,
            d9 * -1,
            d10 * -1,
            d11 * -1,
            d12 * -1,
            d13 * -1,
            d14 * -1,
            d15 * -1,
            d16 * -1,
            d17 * -1,
            d18 * -1,
            d19 * -1,
            d20 * -1,
            d21 * -1,
            d22 * -1,
            d23 * -1,
            d24 * -1,
            d25 * -1,
            d26 * -1,
            d27 * -1,
            d28 * -1,
            d29 * -1,
            d30 * -1,
            d31 * -1,
            total * -1,
            grp,
            company
        From
            time_daily
        Where
            yymm = Trim(p_yymm)
            And empno = (p_empno_to)
            And parent = (p_parent)
            And assign = (p_assign)
            And projno = (p_projno_to)
            And wpcode = (c_wpcode)
            And activity = (p_activity);

        If Sql%rowcount > 0 Then
            v_message_type_in := ok;
            v_message_text_in := 'Procedure executed successfully';
        Else
            v_message_type_in := not_ok;
            v_message_text_in := 'Error while inserting data';
        End If;

        prc_time_daily_adj_log(
            p_person_id         => p_person_id,
            p_meta_id           => p_meta_id,
            p_log_id            => p_log_id,
            p_time_mast_id      => p_time_mast_id,
            p_yymm              => p_yymm,
            p_empno             => p_empno,
            p_empno_to          => p_empno_to,
            p_parent            => p_parent,
            p_assign            => p_assign,
            p_projno            => p_projno_from,
            p_wpcode            => c_wpcode,
            p_activity          => p_activity,
            p_total             => p_total,
            p_grp               => p_grp,
            p_company           => p_company,
            p_message_type_in   => p_message_type,
            p_message_text_in   => p_message_text,
            p_time_daily_id_out => v_time_daily_id,
            p_message_type      => p_message_type,
            p_message_text      => p_message_text
        );

        prc_time_daily_adj_log(
            p_person_id         => p_person_id,
            p_meta_id           => p_meta_id,
            p_log_id            => p_log_id,
            p_time_mast_id      => p_time_mast_id,
            p_time_daily_id     => v_time_daily_id,
            p_yymm              => p_yymm,
            p_empno             => p_empno,
            p_empno_to          => p_empno_to,
            p_parent            => p_parent,
            p_assign            => p_assign,
            p_projno            => p_projno_from,
            p_wpcode            => c_wpcode,
            p_activity          => p_activity,
            p_d1                => time_daily_rec.d1 * -1,
            p_d2                => time_daily_rec.d2 * -1,
            p_d3                => time_daily_rec.d3 * -1,
            p_d4                => time_daily_rec.d4 * -1,
            p_d5                => time_daily_rec.d5 * -1,
            p_d6                => time_daily_rec.d6 * -1,
            p_d7                => time_daily_rec.d7 * -1,
            p_d8                => time_daily_rec.d8 * -1,
            p_d9                => time_daily_rec.d9 * -1,
            p_d10               => time_daily_rec.d10 * -1,
            p_d11               => time_daily_rec.d11 * -1,
            p_d12               => time_daily_rec.d12 * -1,
            p_d13               => time_daily_rec.d13 * -1,
            p_d14               => time_daily_rec.d14 * -1,
            p_d15               => time_daily_rec.d15 * -1,
            p_d16               => time_daily_rec.d16 * -1,
            p_d17               => time_daily_rec.d17 * -1,
            p_d18               => time_daily_rec.d18 * -1,
            p_d19               => time_daily_rec.d19 * -1,
            p_d20               => time_daily_rec.d20 * -1,
            p_d21               => time_daily_rec.d21 * -1,
            p_d22               => time_daily_rec.d22 * -1,
            p_d23               => time_daily_rec.d23 * -1,
            p_d24               => time_daily_rec.d24 * -1,
            p_d25               => time_daily_rec.d25 * -1,
            p_d26               => time_daily_rec.d26 * -1,
            p_d27               => time_daily_rec.d27 * -1,
            p_d28               => time_daily_rec.d28 * -1,
            p_d29               => time_daily_rec.d29 * -1,
            p_d30               => time_daily_rec.d30 * -1,
            p_d31               => time_daily_rec.d31 * -1,
            p_total             => p_total * -1,
            p_grp               => p_grp,
            p_company           => p_company,
            p_message_type_in   => v_message_type_in,
            p_message_text_in   => v_message_text_in,
            p_time_daily_id_out => v_time_daily_id,
            p_message_type      => p_message_type,
            p_message_text      => p_message_text
        );
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_process_time_daily;

    Procedure prc_process_time_ot(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_log_id           Varchar2,
        p_time_mast_id     Varchar2,
        p_projno_from      Varchar2,
        p_yymm             Varchar2,
        p_empno            Varchar2,
        p_empno_to         Varchar2,
        p_parent           Varchar2,
        p_assign           Varchar2,
        p_projno_to        Varchar2,
        p_wpcode           Varchar2,
        p_activity         Varchar2,
        p_total            Number,
        p_grp              Varchar2,
        p_company          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno           Varchar2(5);
        v_empno_user      Varchar2(5);
        time_ot_rec       time_ot%rowtype;
        v_last_date       Number;
        row_locked        Exception;
        Pragma exception_init(row_locked, -54);
        v_time_ot_id      Varchar2(10);
        v_message_type_in Varchar2(2);
        v_message_text_in Varchar2(4000);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        --validate data
        prc_validate_data(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,
            p_costcode     => p_assign,
            p_wpcode       => c_wpcode,
            p_activity     => p_activity,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        
        --process time_ot log 
        prc_time_ot_adj_log(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,
            p_log_id          => p_log_id,
            p_time_mast_id    => p_time_mast_id,
            p_yymm            => p_yymm,
            p_empno           => p_empno,
            p_empno_to        => p_empno_to,
            p_parent          => p_parent,
            p_assign          => p_assign,
            p_projno          => p_projno_to,
            p_wpcode          => c_wpcode,
            p_activity        => p_activity,
            p_total           => p_total,
            p_grp             => p_grp,
            p_company         => p_company,
            p_message_type_in => p_message_type,
            p_message_text_in => p_message_text,
            p_time_ot_id_out  => v_time_ot_id,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        Begin
            Select
                empno
            Into
                v_empno_user
            From
                time_ot
            Where
                yymm = Trim(p_yymm)
                And empno = (p_empno_to)
                And parent = (p_parent)
                And assign = (p_assign)
                And projno = (p_projno_to)
                And wpcode = (c_wpcode)
                And activity = (p_activity)
            For Update Nowait;
        Exception
            When no_data_found Then
                Null;
            When row_locked Then
                p_message_type := not_ok;
                p_message_text := 'Timesheet is in use';
                Return;
        End;

        Delete
            From time_ot
        Where
            yymm = Trim(p_yymm)
            And empno = (p_empno_to)
            And parent = (p_parent)
            And assign = (p_assign)
            And projno = (p_projno_to)
            And wpcode = (c_wpcode)
            And activity = (p_activity);
        Commit;
        Insert Into time_ot (
            yymm,
            empno,
            parent,
            assign,
            projno,
            wpcode,
            activity,
            d1,
            d2,
            d3,
            d4,
            d5,
            d6,
            d7,
            d8,
            d9,
            d10,
            d11,
            d12,
            d13,
            d14,
            d15,
            d16,
            d17,
            d18,
            d19,
            d20,
            d21,
            d22,
            d23,
            d24,
            d25,
            d26,
            d27,
            d28,
            d29,
            d30,
            d31,
            total,
            grp,
            company
        )
        Values (
            p_yymm,
            p_empno_to,
            p_parent,
            p_assign,
            p_projno_to,
            c_wpcode,
            p_activity,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            p_total,
            p_grp,
            p_company
        );

        Select
            d1,
            d2,
            d3,
            d4,
            d5,
            d6,
            d7,
            d8,
            d9,
            d10,
            d11,
            d12,
            d13,
            d14,
            d15,
            d16,
            d17,
            d18,
            d19,
            d20,
            d21,
            d22,
            d23,
            d24,
            d25,
            d26,
            d27,
            d28,
            d29,
            d30,
            d31
        Into
            time_ot_rec.d1,
            time_ot_rec.d2,
            time_ot_rec.d3,
            time_ot_rec.d4,
            time_ot_rec.d5,
            time_ot_rec.d6,
            time_ot_rec.d7,
            time_ot_rec.d8,
            time_ot_rec.d9,
            time_ot_rec.d10,
            time_ot_rec.d11,
            time_ot_rec.d12,
            time_ot_rec.d13,
            time_ot_rec.d14,
            time_ot_rec.d15,
            time_ot_rec.d16,
            time_ot_rec.d17,
            time_ot_rec.d18,
            time_ot_rec.d19,
            time_ot_rec.d20,
            time_ot_rec.d21,
            time_ot_rec.d22,
            time_ot_rec.d23,
            time_ot_rec.d24,
            time_ot_rec.d25,
            time_ot_rec.d26,
            time_ot_rec.d27,
            time_ot_rec.d28,
            time_ot_rec.d29,
            time_ot_rec.d30,
            time_ot_rec.d31
        From
            (
                Select
                    level As d,
                    Case
                        When p_total - (c_99 * level) > 0 Then
                            99
                        Else
                            p_total - (c_99 * (level - 1))
                    End   As hrs
                From
                    dual
                Connect By level <= ceil(p_total / c_99)
                Union
                Select
                    Rownum As d,
                    0      hrs
                From
                    dual
                Connect By Rownum <= 31
            ) Pivot (
            Max(hrs)
            For (d)
            In ('1' As d1, '2' As d2, '3' As d3, '4' As d4, '5' As d5, '6' As d6, '7' As d7, '8' As d8, '9' As d9, '10' As
            d10, '11' As d11, '12' As d12, '13' As d13, '14' As d14, '15' As d15, '16' As d16, '17' As d17, '18' As d18,
            '19' As d19, '20' As d20, '21' As d21, '22' As d22, '23' As d23, '24' As d24, '25' As d25, '26' As d26, '27' As
            d27,
            '28' As d28, '29' As d29, '30' As d30, '31' As d31)
            );

        prc_get_last_date_month(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,
            p_yymm         => p_yymm,
            p_last_date    => v_last_date,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If v_last_date = 28 Then
            If time_ot_rec.d29 > 0 Or time_ot_rec.d30 > 0 Or time_ot_rec.d31 > 0 Then
                p_message_type := not_ok;
                p_message_text := 'Manhours found on 29th / 30th / 31st of the month';
                Return;
            End If;
        Elsif v_last_date = 29 Then
            If time_ot_rec.d30 > 0 Or time_ot_rec.d31 > 0 Then
                p_message_type := not_ok;
                p_message_text := 'Manhours found on 30th / 31st of the month';
                Return;
            End If;
        Elsif v_last_date = 30 Then
            If time_ot_rec.d31 > 0 Then
                p_message_type := not_ok;
                p_message_text := 'Manhours found on 31st of the month';
                Return;
            End If;
        End If;

        Update
            time_ot
        Set
            d1 = time_ot_rec.d1,
            d2 = time_ot_rec.d2,
            d3 = time_ot_rec.d3,
            d4 = time_ot_rec.d4,
            d5 = time_ot_rec.d5,
            d6 = time_ot_rec.d6,
            d7 = time_ot_rec.d7,
            d8 = time_ot_rec.d8,
            d9 = time_ot_rec.d9,
            d10 = time_ot_rec.d10,
            d11 = time_ot_rec.d11,
            d12 = time_ot_rec.d12,
            d13 = time_ot_rec.d13,
            d14 = time_ot_rec.d14,
            d15 = time_ot_rec.d15,
            d16 = time_ot_rec.d16,
            d17 = time_ot_rec.d17,
            d18 = time_ot_rec.d18,
            d19 = time_ot_rec.d19,
            d20 = time_ot_rec.d20,
            d21 = time_ot_rec.d21,
            d22 = time_ot_rec.d22,
            d23 = time_ot_rec.d23,
            d24 = time_ot_rec.d24,
            d25 = time_ot_rec.d25,
            d26 = time_ot_rec.d26,
            d27 = time_ot_rec.d27,
            d28 = time_ot_rec.d28,
            d29 = time_ot_rec.d29,
            d30 = time_ot_rec.d30,
            d31 = time_ot_rec.d31
        Where
            yymm = Trim(p_yymm)
            And empno = (p_empno_to)
            And parent = (p_parent)
            And assign = (p_assign)
            And projno = (p_projno_to)
            And wpcode = (c_wpcode)
            And activity = (p_activity);

        prc_time_ot_adj_log(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,
            p_log_id          => p_log_id,
            p_time_mast_id    => p_time_mast_id,
            p_time_ot_id      => v_time_ot_id,
            p_yymm            => p_yymm,
            p_empno           => p_empno,
            p_empno_to        => p_empno_to,
            p_parent          => p_parent,
            p_assign          => p_assign,
            p_projno          => p_projno_to,
            p_wpcode          => c_wpcode,
            p_activity        => p_activity,
            p_d1              => time_ot_rec.d1,
            p_d2              => time_ot_rec.d2,
            p_d3              => time_ot_rec.d3,
            p_d4              => time_ot_rec.d4,
            p_d5              => time_ot_rec.d5,
            p_d6              => time_ot_rec.d6,
            p_d7              => time_ot_rec.d7,
            p_d8              => time_ot_rec.d8,
            p_d9              => time_ot_rec.d9,
            p_d10             => time_ot_rec.d10,
            p_d11             => time_ot_rec.d11,
            p_d12             => time_ot_rec.d12,
            p_d13             => time_ot_rec.d13,
            p_d14             => time_ot_rec.d14,
            p_d15             => time_ot_rec.d15,
            p_d16             => time_ot_rec.d16,
            p_d17             => time_ot_rec.d17,
            p_d18             => time_ot_rec.d18,
            p_d19             => time_ot_rec.d19,
            p_d20             => time_ot_rec.d20,
            p_d21             => time_ot_rec.d21,
            p_d22             => time_ot_rec.d22,
            p_d23             => time_ot_rec.d23,
            p_d24             => time_ot_rec.d24,
            p_d25             => time_ot_rec.d25,
            p_d26             => time_ot_rec.d26,
            p_d27             => time_ot_rec.d27,
            p_d28             => time_ot_rec.d28,
            p_d29             => time_ot_rec.d29,
            p_d30             => time_ot_rec.d30,
            p_d31             => time_ot_rec.d31,
            p_total           => p_total,
            p_grp             => p_grp,
            p_company         => p_company,
            p_message_type_in => ok,
            p_message_text_in => 'Success',
            p_time_ot_id_out  => v_time_ot_id,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        Begin
            Select
                empno
            Into
                v_empno_user
            From
                time_ot
            Where
                yymm = Trim(p_yymm)
                And empno = (p_empno_to)
                And parent = (p_parent)
                And assign = (p_assign)
                And projno = (p_projno_from)
                And wpcode = (c_wpcode)
                And activity = (p_activity)
            For Update Nowait;
        Exception
            When no_data_found Then
                Null;
            When row_locked Then
                p_message_type := not_ok;
                p_message_text := 'Timesheet is in use';
                Return;
        End;

        Delete
            From time_ot
        Where
            yymm = Trim(p_yymm)
            And empno = (p_empno_to)
            And parent = (p_parent)
            And assign = (p_assign)
            And projno = (p_projno_from)
            And wpcode = (c_wpcode)
            And activity = (p_activity);
        Commit;
        Insert Into time_ot(
            yymm,
            empno,
            parent,
            assign,
            projno,
            wpcode,
            activity,
            d1,
            d2,
            d3,
            d4,
            d5,
            d6,
            d7,
            d8,
            d9,
            d10,
            d11,
            d12,
            d13,
            d14,
            d15,
            d16,
            d17,
            d18,
            d19,
            d20,
            d21,
            d22,
            d23,
            d24,
            d25,
            d26,
            d27,
            d28,
            d29,
            d30,
            d31,
            total,
            grp,
            company)
        Select
            yymm,
            empno,
            parent,
            assign,
            p_projno_from,
            c_wpcode,
            activity,
            d1 * -1,
            d2 * -1,
            d3 * -1,
            d4 * -1,
            d5 * -1,
            d6 * -1,
            d7 * -1,
            d8 * -1,
            d9 * -1,
            d10 * -1,
            d11 * -1,
            d12 * -1,
            d13 * -1,
            d14 * -1,
            d15 * -1,
            d16 * -1,
            d17 * -1,
            d18 * -1,
            d19 * -1,
            d20 * -1,
            d21 * -1,
            d22 * -1,
            d23 * -1,
            d24 * -1,
            d25 * -1,
            d26 * -1,
            d27 * -1,
            d28 * -1,
            d29 * -1,
            d30 * -1,
            d31 * -1,
            total * -1,
            grp,
            company
        From
            time_ot
        Where
            yymm = Trim(p_yymm)
            And empno = (p_empno_to)
            And parent = (p_parent)
            And assign = (p_assign)
            And projno = (p_projno_to)
            And wpcode = (c_wpcode)
            And activity = (p_activity);

        If Sql%rowcount > 0 Then
            v_message_type_in := ok;
            v_message_text_in := 'Procedure executed successfully';
        Else
            v_message_type_in := not_ok;
            v_message_text_in := 'Error while inserting data';
        End If;

        prc_time_ot_adj_log(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,
            p_log_id          => p_log_id,
            p_time_mast_id    => p_time_mast_id,
            p_yymm            => p_yymm,
            p_empno           => p_empno,
            p_empno_to        => p_empno_to,
            p_parent          => p_parent,
            p_assign          => p_assign,
            p_projno          => p_projno_from,
            p_wpcode          => c_wpcode,
            p_activity        => p_activity,
            p_total           => p_total,
            p_grp             => p_grp,
            p_company         => p_company,
            p_message_type_in => p_message_type,
            p_message_text_in => p_message_text,
            p_time_ot_id_out  => v_time_ot_id,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        prc_time_ot_adj_log(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,
            p_log_id          => p_log_id,
            p_time_mast_id    => p_time_mast_id,
            p_time_ot_id      => v_time_ot_id,
            p_yymm            => p_yymm,
            p_empno           => p_empno,
            p_empno_to        => p_empno_to,
            p_parent          => p_parent,
            p_assign          => p_assign,
            p_projno          => p_projno_from,
            p_wpcode          => c_wpcode,
            p_activity        => p_activity,
            p_d1              => time_ot_rec.d1 * -1,
            p_d2              => time_ot_rec.d2 * -1,
            p_d3              => time_ot_rec.d3 * -1,
            p_d4              => time_ot_rec.d4 * -1,
            p_d5              => time_ot_rec.d5 * -1,
            p_d6              => time_ot_rec.d6 * -1,
            p_d7              => time_ot_rec.d7 * -1,
            p_d8              => time_ot_rec.d8 * -1,
            p_d9              => time_ot_rec.d9 * -1,
            p_d10             => time_ot_rec.d10 * -1,
            p_d11             => time_ot_rec.d11 * -1,
            p_d12             => time_ot_rec.d12 * -1,
            p_d13             => time_ot_rec.d13 * -1,
            p_d14             => time_ot_rec.d14 * -1,
            p_d15             => time_ot_rec.d15 * -1,
            p_d16             => time_ot_rec.d16 * -1,
            p_d17             => time_ot_rec.d17 * -1,
            p_d18             => time_ot_rec.d18 * -1,
            p_d19             => time_ot_rec.d19 * -1,
            p_d20             => time_ot_rec.d20 * -1,
            p_d21             => time_ot_rec.d21 * -1,
            p_d22             => time_ot_rec.d22 * -1,
            p_d23             => time_ot_rec.d23 * -1,
            p_d24             => time_ot_rec.d24 * -1,
            p_d25             => time_ot_rec.d25 * -1,
            p_d26             => time_ot_rec.d26 * -1,
            p_d27             => time_ot_rec.d27 * -1,
            p_d28             => time_ot_rec.d28 * -1,
            p_d29             => time_ot_rec.d29 * -1,
            p_d30             => time_ot_rec.d30 * -1,
            p_d31             => time_ot_rec.d31 * -1,
            p_total           => p_total * -1,
            p_grp             => p_grp,
            p_company         => p_company,
            p_message_type_in => v_message_type_in,
            p_message_text_in => v_message_text_in,
            p_time_ot_id_out  => v_time_ot_id,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_process_time_ot;

    Procedure prc_process_timesheet_prechecks(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno_from      Varchar2,
        p_projno_to        Varchar2,
        p_yymm             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        Cursor c1 Is
            Select
            Distinct empno
            From
                (
                    Select
                        empno
                    From
                        time_daily
                    Where
                        projno = Trim(p_projno_from)
                        And yymm = Trim(p_yymm)
                        And wpcode != 4
                        And total > 0
                    Union
                    Select
                        empno
                    From
                        time_ot
                    Where
                        projno = Trim(p_projno_from)
                        And yymm = Trim(p_yymm)
                        And wpcode != 4
                        And total > 0
                )
            Order By
                empno;

        Cursor c2 Is
            Select
            Distinct assign
            From
                (
                    Select
                        assign
                    From
                        time_daily
                    Where
                        projno = Trim(p_projno_from)
                        And yymm = Trim(p_yymm)
                        And wpcode != 4
                        And total > 0
                    Union
                    Select
                        assign
                    From
                        time_ot
                    Where
                        projno = Trim(p_projno_from)
                        And yymm = Trim(p_yymm)
                        And wpcode != 4
                        And total > 0
                )
            Order By
                assign;

        Cursor c3 Is
            Select
            Distinct assign, projno
            From
                (
                    Select
                        assign, projno
                    From
                        time_daily
                    Where
                        projno = Trim(p_projno_from)
                        And yymm = Trim(p_yymm)
                        And wpcode != 4
                        And total > 0
                    Union
                    Select
                        assign, projno
                    From
                        time_ot
                    Where
                        projno = Trim(p_projno_from)
                        And yymm = Trim(p_yymm)
                        And wpcode != 4
                        And total > 0
                )
            Order By
                assign,
                projno;

        Cursor c4 Is
            Select
            Distinct wpcode
            From
                (
                    Select
                        wpcode
                    From
                        time_daily
                    Where
                        projno = Trim(p_projno_from)
                        And yymm = Trim(p_yymm)
                        And wpcode != 4
                        And total > 0
                    Union
                    Select
                        wpcode
                    From
                        time_ot
                    Where
                        projno = Trim(p_projno_from)
                        And yymm = Trim(p_yymm)
                        And wpcode != 4
                        And total > 0
                )
            Order By
                wpcode;

        Cursor c5 Is
            Select
            Distinct assign, activity
            From
                (
                    Select
                        assign, activity
                    From
                        time_daily
                    Where
                        projno = Trim(p_projno_from)
                        And yymm = Trim(p_yymm)
                        And wpcode != 4
                        And total > 0
                    Union
                    Select
                        assign, activity
                    From
                        time_ot
                    Where
                        projno = Trim(p_projno_from)
                        And yymm = Trim(p_yymm)
                        And wpcode != 4
                        And total > 0
                )
            Order By
                assign,
                activity;

        v_empno     Varchar2(5);
        v_empno_new Varchar2(5) := '';
        row_locked  Exception;
        Pragma exception_init(row_locked, -54);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        --check empno  
        For cur_empno In c1
        Loop
            prc_validate_empno_data(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_empno        => cur_empno.empno,
                p_empno_new    => v_empno_new,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := 'Empno - ' || cur_empno.empno || ' ' || p_message_text;
                Return;
            End If;
        End Loop;
            
        --check assign
        For cur_assign In c2
        Loop
            prc_validate_costcode_data(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_costcode     => cur_assign.assign,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := 'Costcode - ' || cur_assign.assign || ' - ' || p_message_text;
                Return;
            End If;
        End Loop;
            
        --check project from & project to
        For cur_assign_projno In c3
        Loop
            prc_validate_projno_data(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_costcode     => cur_assign_projno.assign,
                p_projno       => p_projno_from,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := 'Project from - ' || p_projno_from || ' - Costcode - ' || cur_assign_projno.assign ||
                                  ' - ' || p_message_text;
                Return;
            End If;

            prc_validate_projno_data(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_costcode     => cur_assign_projno.assign,
                p_projno       => p_projno_to,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := 'Project to - ' || p_projno_to || ' - Costcode - ' || cur_assign_projno.assign ||
                                  ' - ' || p_message_text;
                Return;
            End If;
        End Loop;
        
        --check wpcode 
        For cur_wpcode In c4
        Loop
            prc_validate_wpcode_data(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_wpcode       => cur_wpcode.wpcode,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := 'Wp code - ' || cur_wpcode.wpcode ||
                                  ' - ' || p_message_text;
                Return;
            End If;
        End Loop;
        
        --check assign and activity
        For cur_assign_activity In c5
        Loop
            prc_validate_activity_data(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_costcode     => cur_assign_activity.assign,
                p_activity     => cur_assign_activity.activity,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := 'Activity - ' || cur_assign_activity.activity || ' - Costcode - ' || cur_assign_activity.
                assign ||
                                  ' - ' || p_message_text;
                Return;
            End If;
        End Loop;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_process_timesheet_prechecks;

    Procedure sp_process_timesheet(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_yymm             Varchar2,
        p_projno_from      Varchar2,
        p_projno_to        Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        Cursor c1 Is
            Select
                *
            From
                time_mast
            Where
                yymm = Trim(p_yymm)
                And ((empno, yymm) In (
                        Select
                            empno,
                            yymm
                        From
                            time_daily
                        Where
                            projno = Trim(p_projno_from)
                            And yymm = Trim(p_yymm)
                            And wpcode != 4
                            And total > 0
                    )
                    Or (empno, yymm) In (
                        Select
                            empno,
                            yymm
                        From
                            time_ot
                        Where
                            projno = Trim(p_projno_from)
                            And yymm = Trim(p_yymm)
                            And wpcode != 4
                            And total > 0
                    ));

        Cursor c2(
            v_empno  Varchar2,
            v_parent Varchar2,
            v_assign Varchar2
        ) Is
            Select
                *
            From
                time_daily
            Where
                empno = Trim(v_empno)
                And parent = Trim(v_parent)
                And assign = Trim(v_assign)
                And yymm = Trim(p_yymm)
                And projno = Trim(p_projno_from)
                And wpcode != 4
                And total > 0;

        Cursor c3(
            v_empno  Varchar2,
            v_parent Varchar2,
            v_assign Varchar2
        ) Is
            Select
                *
            From
                time_ot
            Where
                empno = Trim(v_empno)
                And parent = Trim(v_parent)
                And assign = Trim(v_assign)
                And yymm = Trim(p_yymm)
                And projno = Trim(p_projno_from)
                And wpcode != 4
                And total > 0;

        v_is_lock         time_mast.locked%Type;
        v_is_hod_approve  time_mast.approved%Type;
        v_is_post         time_mast.posted%Type;
        v_empno           Varchar2(5);
        v_yymm            Varchar2(6);
        v_parent          time_mast.parent%Type;
        v_log_id          Varchar2(10);
        v_time_mast_id    Varchar2(10);
        v_time_daily_id   Varchar2(10);
        v_time_ot_id      Varchar2(10);
        v_total_hrs_daily time_daily.total%Type;
        v_total_hrs_ot    time_ot.total%Type;
        v_exceed          time_mast.exceed%Type;
        v_empno_new       emplmast.empno%Type;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        pkg_ts_mhrs_adj_qry.sp_allow_to_process(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_yymm Is Null Or p_projno_from Is Null Or p_projno_to Is Null Then
            p_message_type := not_ok;
            p_message_text := 'Year month / Project from / Project To cannot be blank';
            Return;
        End If;

        If p_projno_from = p_projno_to Then
            p_message_type := not_ok;
            p_message_text := 'Project (From) and Project (To) cannot be same';
            Return;
        End If;        
        
        --check processing month
        prc_check_processing_month(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,
            p_yymm            => p_yymm,
            p_yymm_pros_month => v_yymm,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        prc_process_timesheet_prechecks(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_projno_from  => p_projno_from,
            p_projno_to    => p_projno_to,
            p_yymm         => p_yymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        prc_time_adj_log(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,
            p_yymm_from       => p_yymm,
            p_yymm_to         => v_yymm,
            p_projno_from     => p_projno_from,
            p_projno_to       => p_projno_to,
            p_message_type_in => ok,
            p_message_text_in => 'Started...',
            p_log_id_out      => v_log_id,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        For cur_time_mast In c1
        Loop                     
            --check assign
            prc_validate_costcode_data(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_costcode     => cur_time_mast.assign,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                prc_time_adj_log(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_log_id          => v_log_id,
                    p_yymm_from       => p_yymm,
                    p_yymm_to         => v_yymm,
                    p_projno_from     => p_projno_from,
                    p_projno_to       => p_projno_to,
                    p_message_type_in => not_ok,
                    p_message_text_in => 'Costcode - ' || cur_time_mast.assign || ' - ' || p_message_text,
                    p_log_id_out      => v_log_id,
                    p_message_type    => p_message_type,
                    p_message_text    => p_message_text
                );

                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;
            
            --check empno
            prc_validate_empno_data(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_empno        => cur_time_mast.empno,
                p_empno_new    => v_empno_new,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                prc_time_adj_log(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_log_id          => v_log_id,
                    p_yymm_from       => p_yymm,
                    p_yymm_to         => v_yymm,
                    p_projno_from     => p_projno_from,
                    p_projno_to       => p_projno_to,
                    p_message_type_in => not_ok,
                    p_message_text_in => 'Empno - ' || cur_time_mast.empno || ' - ' || p_message_text,
                    p_log_id_out      => v_log_id,
                    p_message_type    => p_message_type,
                    p_message_text    => p_message_text
                );

                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;
            
            --check project from
            prc_validate_projno_data(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_costcode     => cur_time_mast.assign,
                p_projno       => p_projno_from,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                prc_time_adj_log(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_log_id          => v_log_id,
                    p_yymm_from       => p_yymm,
                    p_yymm_to         => v_yymm,
                    p_projno_from     => p_projno_from,
                    p_projno_to       => p_projno_to,
                    p_message_type_in => not_ok,
                    p_message_text_in => 'Project from - ' || p_projno_from || ' - Costcode - ' || cur_time_mast.assign ||
                                         ' - ' || p_message_text,
                    p_log_id_out      => v_log_id,
                    p_message_type    => p_message_type,
                    p_message_text    => p_message_text
                );

                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;
            
            --check project to
            prc_validate_projno_data(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_costcode     => cur_time_mast.assign,
                p_projno       => p_projno_to,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                prc_time_adj_log(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_log_id          => v_log_id,
                    p_yymm_from       => p_yymm,
                    p_yymm_to         => v_yymm,
                    p_projno_from     => p_projno_from,
                    p_projno_to       => p_projno_to,
                    p_message_type_in => not_ok,
                    p_message_text_in => 'Project to - ' || p_projno_to || ' - Costcode - ' || cur_time_mast.assign || ' - ' ||
                                         p_message_text,
                    p_log_id_out      => v_log_id,
                    p_message_type    => p_message_type,
                    p_message_text    => p_message_text
                );

                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;        
        
            --process time_mast 
            prc_process_time_mast_before(
                p_person_id      => p_person_id,
                p_meta_id        => p_meta_id,
                p_yymm_from      => p_yymm,
                p_yymm_to        => v_yymm,
                p_empno          => cur_time_mast.empno,
                p_empno_to       => v_empno_new,
                p_parent         => cur_time_mast.parent,
                p_assign         => cur_time_mast.assign,
                p_parent_current => v_parent,
                p_message_type   => p_message_type,
                p_message_text   => p_message_text
            );          
            
            --process time_mast log
            prc_time_mast_adj_log(
                p_person_id        => p_person_id,
                p_meta_id          => p_meta_id,
                p_log_id           => v_log_id,
                p_yymm             => v_yymm,
                p_empno            => cur_time_mast.empno,
                p_empno_to         => v_empno_new,
                p_parent           => v_parent,
                p_assign           => cur_time_mast.assign,
                p_message_type_in  => p_message_type,
                p_message_text_in  => p_message_text,
                p_time_mast_id_out => v_time_mast_id,
                p_message_type     => p_message_type,
                p_message_text     => p_message_text
            );

            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;            
            
            --process time daily
            For cur_time_daily In c2(
                cur_time_mast.empno,
                cur_time_mast.parent,
                cur_time_mast.assign
            )
            Loop
                prc_process_time_daily(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,
                    p_log_id       => v_log_id,
                    p_time_mast_id => v_time_mast_id,
                    p_projno_from  => p_projno_from,
                    p_yymm         => v_yymm,
                    p_empno        => cur_time_mast.empno,
                    p_empno_to     => v_empno_new,
                    p_parent       => v_parent,
                    p_assign       => cur_time_mast.assign,
                    p_projno_to    => p_projno_to,
                    p_wpcode       => cur_time_daily.wpcode,
                    p_activity     => cur_time_daily.activity,
                    p_total        => cur_time_daily.total,
                    p_grp          => cur_time_daily.grp,
                    p_company      => cur_time_daily.company,
                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End Loop;
            
            --process time ot
            For cur_time_ot In c3(
                cur_time_mast.empno,
                cur_time_mast.parent,
                cur_time_mast.assign
            )
            Loop
                prc_process_time_ot(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,
                    p_log_id       => v_log_id,
                    p_time_mast_id => v_time_mast_id,
                    p_projno_from  => p_projno_from,
                    p_yymm         => v_yymm,
                    p_empno        => cur_time_mast.empno,
                    p_empno_to     => v_empno_new,
                    p_parent       => v_parent,
                    p_assign       => cur_time_mast.assign,
                    p_projno_to    => p_projno_to,
                    p_wpcode       => cur_time_ot.wpcode,
                    p_activity     => cur_time_ot.activity,
                    p_total        => cur_time_ot.total,
                    p_grp          => cur_time_ot.grp,
                    p_company      => cur_time_ot.company,
                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End Loop;
            
            --process time_mast
            prc_process_time_mast_after(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_yymm         => v_yymm,
                p_empno        => cur_time_mast.empno,
                p_empno_to     => v_empno_new,
                p_parent       => v_parent,
                p_assign       => cur_time_mast.assign,
                p_tot_nhr      => v_total_hrs_daily,
                p_tot_ohr      => v_total_hrs_ot,
                p_exceed       => v_exceed,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            
            --process time_mast log
            prc_time_mast_adj_log(
                p_person_id        => p_person_id,
                p_meta_id          => p_meta_id,
                p_log_id           => v_log_id,
                p_time_mast_id     => v_time_mast_id,
                p_yymm             => v_yymm,
                p_empno            => cur_time_mast.empno,
                p_empno_to         => v_empno_new,
                p_parent           => v_parent,
                p_assign           => cur_time_mast.assign,
                p_tot_nhr          => v_total_hrs_daily,
                p_tot_ohr          => v_total_hrs_ot,
                p_exceed           => v_exceed,
                p_message_type_in  => p_message_type,
                p_message_text_in  => p_message_text,
                p_time_mast_id_out => v_time_mast_id,
                p_message_type     => p_message_type,
                p_message_text     => p_message_text
            );

            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;
        End Loop;

        prc_time_adj_log(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,
            p_log_id          => v_log_id,
            p_yymm_from       => p_yymm,
            p_yymm_to         => v_yymm,
            p_projno_from     => p_projno_from,
            p_projno_to       => p_projno_to,
            p_message_type_in => p_message_type,
            p_message_text_in => p_message_text,
            p_log_id_out      => v_log_id,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_process_timesheet;

End pkg_ts_mhrs_adj;