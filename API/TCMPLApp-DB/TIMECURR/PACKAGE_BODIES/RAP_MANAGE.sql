Create Or Replace Package Body timecurr.rap_manage As

    Procedure sp_repost(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_yyyymm           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
        v_repost       Number;
        v_pros_month   Varchar2(6);
        Cursor c1 Is
            Select
                *
            From
                time_mast
            Where
                approved > 0
                -- and yymm = p_yyyymm
                And Trim(yymm) In (
                    Select
                        Trim(pros_month)
                    From
                        tsconfig
                    Where
                        Trim(schemaname)   = 'TIMECURR'
                        And Trim(username) = 'TIMECURR'
                )
            For Update;

        rec            time_mast%rowtype;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            pros_month
        Into
            v_pros_month
        From
            tsconfig;

        If v_pros_month != p_yyyymm Then
            p_message_type := not_ok;
            p_message_text := 'YYMM is not matching with current month';
            Return;
        End If;

        Open c1;
        Loop
            Fetch c1 Into rec;
            Exit When c1%notfound;
            Delete
                From timetran
            Where
                yymm         = rec.yymm
                And empno    = rec.empno
                And costcode = rec.assign;

            Insert Into timetran (
                yymm,
                empno,
                costcode,
                projno,
                wpcode,
                activity,
                grp,
                company,
                hours,
                othours
            )
            Select
                yymm,
                empno,
                assign,
                projno,
                wpcode,
                activity,
                grp,
                company,
                Sum(nhrs),
                Sum(ohrs)
            From
                postingdata
            Where
                yymm       = rec.yymm
                And empno  = rec.empno
                And assign = rec.assign
            Group By
                yymm,
                empno,
                assign,
                projno,
                wpcode,
                activity,
                grp,
                company;

            Update
                time_mast
            Set
                posted = 1
            Where
                Current Of c1;

        End Loop;

        Close c1;
        /*UPDATE TIMETRAN SET PARENT = */
        Update
            timetran
        Set
            parent = (
                Select
                    parent
                From
                    emplmast
                Where
                    emplmast.empno = timetran.empno
            )
        Where
            timetran.parent Is Null;

        Select
            repost
        Into
            v_repost
        From
            tsconfig;

        Update
            tsconfig
        Set
            repost = nvl(v_repost, 0) + 1;

        pkg_ts_osc_mhrs.sp_repost_osc_hrs(p_person_id => p_person_id, p_meta_id => p_meta_id, p_yymm => p_yyyymm, p_message_type =>
        p_message_type,
                                          p_message_text => p_message_text);

        If p_message_type = ok Then
            sp_insert_proc_month_notfill();
            Commit;
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Error while reposting !!!';
        End If;

    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_repost;

    Procedure sp_move_month(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_yyyymm           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_new_proc_year   Varchar2(6);
        v_new_locked_year Varchar2(6);
        v_empno           Varchar2(5);
        v_user_tcp_ip     Varchar2(5) := 'NA';
        v_message_type    Number      := 0;
        v_pros_month      Varchar2(6);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
 
        Select
            pros_month
        Into
            v_pros_month
        From
            tsconfig;

        If v_pros_month != p_yyyymm Then
            p_message_type := not_ok;
            p_message_text := 'YYMM is not matching with current month';
            Return;
        End If;

        Select
            (to_char(add_months(To_Date(pros_month, 'yyyymm'), 1), 'yyyymm')) new_proc_year,
            pros_month                                                        new_locked_year
        Into
            v_new_proc_year,
            v_new_locked_year
        From
            tsconfig
        Where
            Trim(schemaname)   = 'TIMECURR'
            And Trim(username) = 'TIMECURR';

        Update
            tsconfig
        Set
            pros_month = v_new_proc_year,
            lockedmnth = v_new_locked_year,
            status = 1,
            modified_by = v_empno,
            modified_on = sysdate,
            repost = 0
        Where
            Trim(schemaname)   = 'TIMECURR'
            And Trim(username) = 'TIMECURR'
            And status         = 0;
            
        If (Sql%rowcount > 0) Then
             sp_insert_locked_month_notfill();               
        End If;
     
        
        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_move_month;

    Procedure sp_update_no_of_employee(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
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

        Update
            costmast
        Set
            noofemps = nvl((
                    Select
                        Count(empno)
                    From
                        emplmast
                    Where
                        emplmast.parent             = costmast.costcode
                        /* aDD THIS LINE IF NO OF EMPLOYEES SHOULD NOT INCLUDE NEW ED DIVISION*/
                        /*AND EMPNO NOT LIKE '10%'*/
                        And emplmast.emptype In('C', 'R', 'F')
                        And nvl(emplmast.status, 0) = 1
                ),
                0)
        Where
            active = 1;

        Update
            costmast
        Set
            noofcons = nvl((
                    Select
                        Count(empno)
                    From
                        emplmast
                    Where
                        emplmast.parent             = costmast.costcode
                        /* aDD THIS LINE IF NO OF EMPLOYEES SHOULD NOT INCLUDE NEW ED DIVISION*/
                        /*AND EMPNO NOT LIKE '10%'*/
                        And emplmast.emptype In('C')
                        And nvl(emplmast.status, 0) = 1
                ),
                0)
        Where
            active = 1;

        Update
            hr_costmast_main
        Set
            noofemps = nvl((
                    Select
                        noofemps
                    From
                        costmast
                    Where
                        costmast.costcode = hr_costmast_main.costcode
                ), 0)
        Where
            active = 1;

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_no_of_employee;

    Procedure sp_month_status(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_status       Number      := 0;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            status
        Into
            v_status
        From
            tsconfig
        Where
            Trim(schemaname)   = 'TIMECURR'
            And Trim(username) = 'TIMECURR';

        If (v_status = 0) Then
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Month-End  process already done.';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_month_status;

    Procedure sp_posting_status(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_repost       Out Number,
        p_proc_month   Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_status       Number      := 0;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            repost, pros_month
        Into
            p_repost, p_proc_month
        From
            tsconfig
        Where
            Trim(schemaname)   = 'TIMECURR'
            And Trim(username) = 'TIMECURR';

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_posting_status;

    Procedure sp_lock_ts_config(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_status       Number      := 0;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        Update
            tsconfig
        Set
            status = 1,
            modified_by = 'Sys',
            modified_on = sysdate,
            repost = 0
        Where
            Trim(schemaname)   = 'TIMECURR'
            And Trim(username) = 'TIMECURR';

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_lock_ts_config;

    Procedure sp_reset_ts_config(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_status       Number      := 0;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        Update
            tsconfig
        Set
            status = 0,
            modified_by = 'Sys',
            modified_on = sysdate
        Where
            Trim(schemaname)   = 'TIMECURR'
            And Trim(username) = 'TIMECURR';

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_reset_ts_config;

    Procedure sp_insert_notfill As
        Cursor c1 Is
            Select
                *
            From
                cc_post_det_lock;
        --cursor c2 (vProjno char) is select * from projmast where rownum = 1 and substr(projno,1,5) = substr(vProjno,1,5) and cdate is null order by projno;
        c1_rec       c1%rowtype;
        c_lockedmnth Varchar2(6);
    --c2_rec c2%rowtype;
    --test_projno CHAR(7);
    Begin
        Select
            pros_month
        Into
            c_lockedmnth
        From
            tsconfig;

        Delete
            From tsnotfilled
        Where
            yymm = c_lockedmnth;

        Open c1;
        Loop
            Fetch c1 Into c1_rec;
            Exit When c1%notfound;
            --      test_projno := c1_rec.projno;
            --    open c2 (c1_rec.projno);
            --  loop
            --     fetch c2 into c2_rec;
            --    exit when c2%NOTFOUND;
            Insert Into tsnotfilled (
                yymm,
                emptype,
                assign,
                costname,
                hod,
                desc1,
                empno,
                name,
                doj,
                email,
                dol,
                parent
            )
            Values (
                c_lockedmnth,
                c1_rec.emptype,
                c1_rec.assign,
                c1_rec.costname,
                c1_rec.hod,
                c1_rec.desc1,
                c1_rec.empno,
                c1_rec.name,
                c1_rec.doj,
                c1_rec.email,
                c1_rec.dol,
                c1_rec.parent
            );
            --  end loop;
            --  close c2;

        End Loop;

        Commit;
        Close c1;
        Commit;
    End sp_insert_notfill;

    Procedure sp_insert_proc_month_notfill As
        c_proc_month Varchar2(6);
    Begin
        Select
            pros_month
        Into
            c_proc_month
        From
            tsconfig;

        Delete
            From tsnotfilled
        Where
            yymm = c_proc_month;

        Insert Into tsnotfilled
            ( emptype, assign, costname, hod, desc1, empno, name, doj, email, dol, parent,yymm)
        With
            p As
            (
                Select
                    emptype,
                    assign,
                    costname,
                    hod,
                    desc1,
                    empno,
                    name,
                    doj,
                    email,
                    dol,
                    parent,
                    pros_month
                From
                    (
                        Select
                            a.emptype,
                            a.assign,
                            b.name                 As costname,
                            b.hod,
                            'Timesheet Not Filled' As desc1,
                            a.empno,
                            a.name,
                            a.doj,
                            a.email,
                            a.dol,
                            a.parent,
                            c.pros_month
                        From
                            emplmast      a
                            Join costmast b
                            On a.assign = b.costcode
                            Join tsconfig c
                            On to_char(a.doj, 'yyyymm') <= c.pros_month
                        Where
                            a.assign Like '02%'
                            And a.status = 1
                            And a.emptype In ('C', 'R', 'S', 'F', 'O')
                            And a.empno Not In (
                                Select
                                    empno
                                From
                                    time_mast
                                Where
                                    yymm = c.pros_month
                            )
                        Union All
                        Select
                            b.emptype,
                            a.assign,
                            c.name                 As costname,
                            c.hod,
                            'Timesheet Not Locked' As desc1,
                            a.empno,
                            b.name,
                            b.doj,
                            b.email,
                            b.dol,
                            b.parent,
                            d.pros_month
                        From
                            time_mast     a
                            Join emplmast b
                            On a.empno = b.empno
                            Join costmast c
                            On a.assign = c.costcode
                            Join tsconfig d
                            On a.yymm = d.pros_month
                        Where
                            nvl(a.locked, 0) = 0
                            And b.emptype In ('C', 'R', 'S', 'F')

                        Union All

                        Select
                            b.emptype,
                            a.assign,
                            c.name                   As costname,
                            c.hod,
                            'Timesheet Not Approved' As desc1,
                            a.empno,
                            b.name,
                            b.doj,
                            b.email,
                            b.dol,
                            b.parent,
                            d.pros_month
                        From
                            time_mast     a
                            Join emplmast b
                            On a.empno = b.empno
                            Join costmast c
                            On a.assign = c.costcode
                            Join tsconfig d
                            On a.yymm = d.pros_month
                        Where
                            nvl(a.approved, 0) = 0
                            And b.emptype In ('C', 'R', 'S', 'F')

                        Union All

                        Select
                            b.emptype,
                            a.assign,
                            c.name                 As costname,
                            c.hod,
                            'Timesheet Not Posted' As desc1,
                            a.empno,
                            b.name,
                            b.doj,
                            b.email,
                            b.dol,
                            b.parent,
                            d.pros_month
                        From
                            time_mast     a
                            Join emplmast b
                            On a.empno = b.empno
                            Join costmast c
                            On a.assign = c.costcode
                            Join tsconfig d
                            On a.yymm = d.pros_month
                        Where
                            nvl(a.posted, 0) = 0
                            And b.emptype In ('C', 'R', 'S', 'F')

                        Union All

                        Select
                            emptype,
                            assign,
                            costname,
                            hod,
                            desc1,
                            empno,
                            name,
                            doj,
                            email,
                            dol,
                            parent,
                            yymm
                        From
                            (
                                Select
                                    e.emptype,
                                    tomm.assign,
                                    c.name As costname,
                                    c.hod,
                                    tomm.is_lock,
                                    tomm.is_hod_approve,
                                    tomm.is_post,
                                    Case
                                        When nvl(tomm.is_lock, 'KO') = 'KO' Then
                                            'Timesheet Not Locked'
                                        When nvl(tomm.is_hod_approve, 'KO') = 'KO' Then
                                            'Timesheet Not Approved'
                                        When nvl(tomm.is_post, 'KO') = 'KO' Then
                                            'Timesheet Not Posted'
                                        Else
                                            'POSTED'
                                    End    desc1,
                                    tomm.empno,
                                    e.name,
                                    e.doj,
                                    e.email,
                                    e.dol,
                                    e.parent,
                                    tomm.yymm
                                From
                                    ts_osc_mhrs_master tomm,
                                    emplmast           e,
                                    costmast           c,
                                    tsconfig           t,
                                    deptphase          dp
                                Where
                                    e.assign         = c.costcode
                                    And tomm.yymm    = t.pros_month
                                    And tomm.empno   = e.empno(+)
                                    And e.emptype    = 'O'
                                    And e.assign     = dp.costcode
                                    And dp.isprimary = 1
                            )
                        Where
                            desc1 <> 'POSTED'
                    )
                Order By
                    empno
            )
        Select
            *
        From
            p;

        Commit;

    End sp_insert_proc_month_notfill;

    Procedure sp_insert_locked_month_notfill As
        c_locked_month Varchar2(6);
    Begin
        Select
            lockedmnth
        Into
            c_locked_month
        From
            tsconfig;

        Delete
            From tsnotfilled
        Where
            yymm = c_locked_month;

        Insert Into tsnotfilled
            ( emptype, assign, costname, hod, desc1, empno, name, doj, email, dol, parent , yymm)
        With
            p As
            (

                Select
                    emptype,
                    assign,
                    costname,
                    hod,
                    desc1,
                    empno,
                    name,
                    doj,
                    email,
                    dol,
                    parent,
                    lockedmnth
                From
                    (
                        Select
                            a.emptype,
                            a.assign,
                            b.name                 As costname,
                            b.hod,
                            'Timesheet Not Filled' As desc1,
                            a.empno,
                            a.name,
                            a.doj,
                            a.email,
                            a.dol,
                            a.parent,
                            c.lockedmnth
                        From
                            emplmast      a
                            Join costmast b
                            On a.assign = b.costcode
                            Join tsconfig c
                            On to_char(a.doj, 'yyyymm') <= c.lockedmnth
                        Where
                            a.assign Like '02%'
                            And a.status = 1
                            And a.emptype In ('C', 'R', 'S', 'F', 'O')
                            And a.empno Not In (
                                Select
                                    empno
                                From
                                    time_mast
                                Where
                                    yymm = c.lockedmnth
                            )
                        Union All
                        Select
                            b.emptype,
                            a.assign,
                            c.name                 As costname,
                            c.hod,
                            'Timesheet Not Locked' As desc1,
                            a.empno,
                            b.name,
                            b.doj,
                            b.email,
                            b.dol,
                            b.parent,
                            d.lockedmnth
                        From
                            time_mast     a
                            Join emplmast b
                            On a.empno = b.empno
                            Join costmast c
                            On a.assign = c.costcode
                            Join tsconfig d
                            On a.yymm = d.lockedmnth
                        Where
                            nvl(a.locked, 0) = 0
                            And b.emptype In ('C', 'R', 'S', 'F')

                        Union All

                        Select
                            b.emptype,
                            a.assign,
                            c.name                   As costname,
                            c.hod,
                            'Timesheet Not Approved' As desc1,
                            a.empno,
                            b.name,
                            b.doj,
                            b.email,
                            b.dol,
                            b.parent,
                            d.lockedmnth
                        From
                            time_mast     a
                            Join emplmast b
                            On a.empno = b.empno
                            Join costmast c
                            On a.assign = c.costcode
                            Join tsconfig d
                            On a.yymm = d.lockedmnth
                        Where
                            nvl(a.approved, 0) = 0
                            And b.emptype In ('C', 'R', 'S', 'F')

                        Union All

                        Select
                            b.emptype,
                            a.assign,
                            c.name                 As costname,
                            c.hod,
                            'Timesheet Not Posted' As desc1,
                            a.empno,
                            b.name,
                            b.doj,
                            b.email,
                            b.dol,
                            b.parent,
                            d.lockedmnth
                        From
                            time_mast     a
                            Join emplmast b
                            On a.empno = b.empno
                            Join costmast c
                            On a.assign = c.costcode
                            Join tsconfig d
                            On a.yymm = d.lockedmnth
                        Where
                            nvl(a.posted, 0) = 0
                            And b.emptype In ('C', 'R', 'S', 'F')

                        Union All

                        Select
                            emptype,
                            assign,
                            costname,
                            hod,
                            desc1,
                            empno,
                            name,
                            doj,
                            email,
                            dol,
                            parent,
                            yymm
                        From
                            (
                                Select
                                    e.emptype,
                                    tomm.assign,
                                    c.name As costname,
                                    c.hod,
                                    tomm.is_lock,
                                    tomm.is_hod_approve,
                                    tomm.is_post,
                                    Case
                                        When nvl(tomm.is_lock, 'KO') = 'KO' Then
                                            'Timesheet Not Locked'
                                        When nvl(tomm.is_hod_approve, 'KO') = 'KO' Then
                                            'Timesheet Not Approved'
                                        When nvl(tomm.is_post, 'KO') = 'KO' Then
                                            'Timesheet Not Posted'
                                        Else
                                            'POSTED'
                                    End    desc1,
                                    tomm.empno,
                                    e.name,
                                    e.doj,
                                    e.email,
                                    e.dol,
                                    e.parent,
                                    tomm.yymm
                                From
                                    ts_osc_mhrs_master tomm,
                                    emplmast           e,
                                    costmast           c,
                                    tsconfig           t,
                                    deptphase          dp
                                Where
                                    e.assign         = c.costcode
                                    And tomm.yymm    = t.lockedmnth
                                    And tomm.empno   = e.empno(+)
                                    And e.emptype    = 'O'
                                    And e.assign     = dp.costcode
                                    And dp.isprimary = 1
                            )
                        Where
                            desc1 <> 'POSTED'
                    )
                Order By
                    empno
            )
        Select
            *
        From
            p;

        Commit;

    End sp_insert_locked_month_notfill;

End rap_manage;