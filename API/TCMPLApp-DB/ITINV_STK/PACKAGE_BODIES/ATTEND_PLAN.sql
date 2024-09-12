--------------------------------------------------------
--  DDL for Package Body ATTEND_PLAN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "ITINV_STK"."ATTEND_PLAN" As

    Procedure delete_emp_cur_wk (
        p_keyid          In   Varchar2,
        p_wk_start_date  In   Date,
        p_hod            In   Char,
        p_status         Out  Varchar2,
        p_msg            Out  Varchar2
    ) As
    Begin
        If trunc(to_date(p_wk_start_date)) != attend_plan.get_week_start_date Then
            p_status := 'KO';
            p_msg := 'Err...Not authorized !!';
            return;
        End If;

        delete_attend_plan_wk(p_keyid);
        Commit;
        p_status := 'OK';
        p_msg := 'Success';
    Exception
        When Others Then
            p_status := 'KO';
            p_msg := 'Err - '
                     || sqlcode
                     || ' - '
                     || sqlerrm;
    End;

    Procedure delete_emp_nxt_wk (
        p_keyid          In   Varchar2,
        p_wk_start_date  In   Date,
        p_hod            In   Char,
        p_status         Out  Varchar2,
        p_msg            Out  Varchar2
    ) As
    Begin
        If trunc(to_date(p_wk_start_date)) != trunc(attend_plan.get_week_start_date + 7) Then
            p_status := 'KO';
            p_msg := 'Err...Not authorized !!';
            return;
        End If;

        delete_attend_plan_wk(p_keyid);
        Commit;
        p_status := 'OK';
        p_msg := 'Success';
    Exception
        When Others Then
            p_status := 'KO';
            p_msg := 'Err - '
                     || sqlcode
                     || ' - '
                     || sqlerrm;
    End;

    Procedure add_emp_cur_wk (
        p_empno          In   Char,
        p_wk_start_date  In   Date,
        p_modeler        In   Number,
        p_shift          In   Char,
        p_bus            In   Char,
        p_station        In   Varchar2,
        p_side           In   Char,
        p_city_landmark  In   Varchar2,
        p_taskforce      In   Varchar2,
        p_specialnote    In   Char,
        p_emp_plan       In   Number,
        p_hod            In   Char,
        p_status         Out  Varchar2,
        p_msg            Out  Varchar2
    ) As
    Begin
        If trunc(to_date(p_wk_start_date)) != attend_plan.get_week_start_date Then
            p_status := 'KO';
            p_msg := 'Err...Not authorized !!';
            return;
        End If;

        add_attend_plan_wk(p_empno, attend_plan.get_week_start_date, attend_plan.get_week_end_date, 0, 0,
                           0, 0, 0, 0, 0,
                           dist_users.get_empno_from_win_uid(p_hod));

        add_attend_shift_bus_pickup(p_empno, p_modeler, p_shift, p_bus, p_station,
                                    p_side, p_city_landmark, p_taskforce, p_specialnote, p_emp_plan,
                                    dist_users.get_empno_from_win_uid(p_hod));

        Commit;
        p_status := 'OK';
        p_msg := 'Success';
    Exception
        When Others Then
            p_status := 'KO';
            p_msg := 'Err - '
                     || sqlcode
                     || ' - '
                     || sqlerrm;
    End;

    Procedure add_emp_nxt_wk (
        p_empno          In   Char,
        p_wk_start_date  In   Date,
        p_modeler        In   Number,
        p_shift          In   Char,
        p_bus            In   Char,
        p_station        In   Varchar2,
        p_side           In   Char,
        p_city_landmark  In   Varchar2,
        p_taskforce      In   Varchar2,
        p_specialnote    In   Char,
        p_emp_plan       In   Number,
        p_hod            In   Char,
        p_status         Out  Varchar2,
        p_msg            Out  Varchar2
    ) As
    Begin
        If trunc(to_date(p_wk_start_date)) != trunc(attend_plan.get_week_start_date + 7) Then
            p_status := 'KO';
            p_msg := 'Err...Not authorized !!';
            return;
        End If;

        add_attend_plan_wk(p_empno, attend_plan.get_week_start_date + 7, attend_plan.get_week_end_date + 7, 0, 0,
                           0, 0, 0, 0, 0,
                           dist_users.get_empno_from_win_uid(p_hod));

        add_attend_shift_bus_pickup(p_empno, p_modeler, p_shift, p_bus, p_station,
                                    p_side, p_city_landmark, p_taskforce, p_specialnote, p_emp_plan,
                                    dist_users.get_empno_from_win_uid(p_hod));

        Commit;
        p_status := 'OK';
        p_msg := 'Success';
    Exception
        When Others Then
            p_status := 'KO';
            p_msg := 'Err - '
                     || sqlcode
                     || ' - '
                     || sqlerrm;
    End;

    Procedure save_cur_wk (
        p_json           In   Clob,
        p_wk_start_date  In   Date,
        p_hod            In   Char,
        p_status         Out  Varchar2,
        p_msg            Out  Varchar2
    ) As

        v_keyid  attend_plan_wk.keyid%Type;
        v_empno  attend_plan_wk.empno%Type;
        v_mon    attend_plan_wk.mon%Type;
        v_tue    attend_plan_wk.tue%Type;
        v_wed    attend_plan_wk.wed%Type;
        v_thu    attend_plan_wk.thu%Type;
        v_fri    attend_plan_wk.fri%Type;
        v_sat    attend_plan_wk.sat%Type;
    Begin
        If trunc(to_date(p_wk_start_date)) != attend_plan.get_week_start_date Then
            p_status := 'KO';
            p_msg := 'Err...Not authorized !!';
            return;
        End If;

        apex_json.parse(p_json);
        For i In 1..apex_json.get_count('data') Loop
            v_keyid := apex_json.get_varchar2('data[%d].KEYID', i);
            v_empno := apex_json.get_varchar2('data[%d].EMPNO', i);
            v_mon := apex_json.get_number('data[%d].MON', i);
            v_tue := apex_json.get_number('data[%d].TUE', i);
            v_wed := apex_json.get_number('data[%d].WED', i);
            v_thu := apex_json.get_number('data[%d].THU', i);
            v_fri := apex_json.get_number('data[%d].FRI', i);
            v_sat := apex_json.get_number('data[%d].SAT', i);
            delete_attend_plan_wk(v_keyid);
            add_attend_plan_wk(v_empno, attend_plan.get_week_start_date, attend_plan.get_week_end_date, v_mon, v_tue,
                               v_wed, v_thu, v_fri, v_sat, 0,
                               dist_users.get_empno_from_win_uid(p_hod));

        End Loop;

        Commit;
        p_status := 'OK';
        p_msg := 'Success';
    Exception
        When Others Then
            p_status := 'KO';
            p_msg := 'Err - '
                     || sqlcode
                     || ' - '
                     || sqlerrm;
    End save_cur_wk;

    Procedure save_nxt_wk (
        p_json           In   Clob,
        p_wk_start_date  In   Date,
        p_hod            In   Char,
        p_status         Out  Varchar2,
        p_msg            Out  Varchar2
    ) As

        v_keyid  attend_plan_wk.keyid%Type;
        v_empno  attend_plan_wk.empno%Type;
        v_mon    attend_plan_wk.mon%Type;
        v_tue    attend_plan_wk.tue%Type;
        v_wed    attend_plan_wk.wed%Type;
        v_thu    attend_plan_wk.thu%Type;
        v_fri    attend_plan_wk.fri%Type;
        v_sat    attend_plan_wk.sat%Type;
    Begin
        If trunc(to_date(p_wk_start_date)) != trunc(attend_plan.get_week_start_date + 7) Then
            p_status := 'KO';
            p_msg := 'Err...Not authorized !!';
            return;
        End If;

        apex_json.parse(p_json);
        For i In 1..apex_json.get_count('data') Loop
            v_keyid := apex_json.get_varchar2('data[%d].KEYID', i);
            v_empno := apex_json.get_varchar2('data[%d].EMPNO', i);
            v_mon := apex_json.get_number('data[%d].MON', i);
            v_tue := apex_json.get_number('data[%d].TUE', i);
            v_wed := apex_json.get_number('data[%d].WED', i);
            v_thu := apex_json.get_number('data[%d].THU', i);
            v_fri := apex_json.get_number('data[%d].FRI', i);
            v_sat := apex_json.get_number('data[%d].SAT', i);
            delete_attend_plan_wk(v_keyid);
            add_attend_plan_wk(v_empno, attend_plan.get_week_start_date + 7, attend_plan.get_week_end_date + 7, v_mon, v_tue,
                               v_wed, v_thu, v_fri, v_sat, 0,
                               dist_users.get_empno_from_win_uid(p_hod));

        End Loop;

        Commit;
        p_status := 'OK';
        p_msg := 'Success';
    Exception
        When Others Then
            p_status := 'KO';
            p_msg := 'Err - '
                     || sqlcode
                     || ' - '
                     || sqlerrm;
    End save_nxt_wk;

    Procedure update_attend_shift_bus_pickup (
        p_empno          In   Char,
        p_modeler        In   Number,
        p_shift          In   Char,
        p_bus            In   Char,
        p_station        In   Varchar2,
        p_side           In   Char,
        p_city_landmark  In   Varchar2,
        p_taskforce      In   Varchar2,
        p_specialnote    In   Char,
        p_hod            In   Char,
        p_status         Out  Varchar2,
        p_msg            Out  Varchar2
    ) As
    Begin
        add_attend_shift_bus_pickup(p_empno, p_modeler, p_shift, p_bus, p_station,
                                    p_side, p_city_landmark, p_taskforce, p_specialnote, 0,
                                    dist_users.get_empno_from_win_uid(p_hod));

        Commit;
        p_status := 'OK';
        p_msg := 'Success';
    Exception
        When Others Then
            p_status := 'KO';
            p_msg := 'Err - '
                     || sqlcode
                     || ' - '
                     || sqlerrm;
    End update_attend_shift_bus_pickup;

    Procedure create_attend_act_punch (
        p_punch_date  In   Date,
        p_empno       In   Char,
        p_status      Out  Varchar2,
        p_msg         Out  Varchar2
    ) As

        v_count   Number;
        v_counts  Number;
        v_day     Varchar2(10);
        v_mon     Number(1) := 0;
        v_tue     Number(1) := 0;
        v_wed     Number(1) := 0;
        v_thu     Number(1) := 0;
        v_fri     Number(1) := 0;
        v_sat     Number(1) := 0;
    Begin
        v_day := to_char(p_punch_date, 'DAY');
        If trim(v_day) = 'SUNDAY' Then
            p_status := 'KO';
            p_msg := 'Err - Not allowed for Sunday !!';
            return;
        End If;

        Select
            Count(keyid)
        Into v_count
        From
            attend_plan_wk
        Where
            p_punch_date Between wk_start_date And wk_end_date
            And p_punch_date <= sysdate;

        If v_count = 0 Then
            p_status := 'KO';
            p_msg := 'Err - No such week exists in the application !!';
        Else
            Select
                Count(keyid)
            Into v_counts
            From
                attend_plan_wk
            Where
                    empno = Trim(p_empno)
                And p_punch_date Between wk_start_date And wk_end_date;

            If v_counts = 0 Then
                add_attend_plan_wk(p_empno, trunc(p_punch_date, 'DAY') + 1, trunc(p_punch_date, 'DAY') + 6, v_mon, v_tue, v_wed, v_thu,
                                   v_fri, v_sat, 0, 'PUNCH');

            Else
                p_status := 'KO';
                p_msg := 'Err - Record exists !!';
                return;
            End If;

            Commit;
            p_status := 'OK';
            p_msg := 'Success';
        End If;

    Exception
        When Others Then
            p_status := 'KO';
            p_msg := 'Err - '
                     || sqlcode
                     || ' - '
                     || sqlerrm;
    End create_attend_act_punch;

    Procedure populate_nxt_wk (
        p_status  Out  Varchar2,
        p_msg     Out  Varchar2
    ) As
    Begin
        Insert Into attend_plan_wk
            Select
                dbms_random.string('X', 10),
                a.empno,
                trunc(wk_start_date + 7),
                trunc(wk_end_date + 7),
                mon,
                tue,
                wed,
                thu,
                fri,
                sat,
                isdeleted,
                created_by,
                sysdate
            From
                attend_plan_wk  a,
                vu_emplmast     e
            Where
                    a.empno = e.empno
                And e.status = 1
                And ( mon = 1
                      Or tue = 1
                      Or wed = 1
                      Or thu = 1
                      Or fri = 1
                      Or sat = 1 )
                And a.wk_start_date = attend_plan.get_week_start_date;

        Insert Into attend_office_seat_cap
            Select
                office,
                tot_seat_cap,
                tot_seat_avl,
                allt_ocu,
                trunc(wk_start_date + 7),
                trunc(wk_end_date + 7)
            From
                attend_office_seat_cap
            Where
                wk_start_date = attend_plan.get_week_start_date;

        attend_plan_wk_job_log('ATTEND_PLAN_WK', 'SUCCESS');
        Commit;
        p_status := 'OK';
        p_msg := 'Success';
    Exception
        When Others Then
            p_status := 'KO';
            p_msg := 'Err - '
                     || sqlcode
                     || ' - '
                     || sqlerrm;
            Rollback;
            attend_plan_wk_job_log('ATTEND_PLAN_WK', substr(p_msg, 1, 1000));
            Commit;
    End populate_nxt_wk;

    Procedure populate_history_data_job As
        v_success  Varchar2(10);
        v_message  Varchar2(1000);
    Begin
        populate_history_data(p_date => sysdate, p_status => v_success, p_msg => v_message);
    End;

    Procedure populate_history_data (
        p_date    In   Date,
        p_status  Out  Varchar2,
        p_msg     Out  Varchar2
    ) As
        v_day Varchar2(10);
    Begin
        v_day := to_char(nvl(p_date, sysdate), 'DAY');
        If trim(v_day) = 'SUNDAY' Then
            p_status := 'KO';
            p_msg := 'Err - Not allowed for Sunday !!';
            return;
        End If;

        Begin
            Insert Into attend_plan_calendar
                Select
                    trunc(sysdate)
                From
                    dual;

        Exception
            When Others Then
                Null;
        End;

        If trim(v_day) = 'MONDAY' Then
            Insert Into attend_plan_wk_history
                Select
                    p_date,
                    empno,
                    mon,
                    'JOB',
                    sysdate
                From
                    attend_plan_wk
                Where
                        mon = 1
                    And p_date Between wk_start_date And wk_end_date;

        Elsif trim(v_day) = 'TUESDAY' Then
            Insert Into attend_plan_wk_history
                Select
                    p_date,
                    empno,
                    tue,
                    'JOB',
                    sysdate
                From
                    attend_plan_wk
                Where
                        tue = 1
                    And p_date Between wk_start_date And wk_end_date;

        Elsif trim(v_day) = 'WEDNESDAY' Then
            Insert Into attend_plan_wk_history
                Select
                    p_date,
                    empno,
                    wed,
                    'JOB',
                    sysdate
                From
                    attend_plan_wk
                Where
                        wed = 1
                    And p_date Between wk_start_date And wk_end_date;

        Elsif trim(v_day) = 'THURSDAY' Then
            Insert Into attend_plan_wk_history
                Select
                    p_date,
                    empno,
                    thu,
                    'JOB',
                    sysdate
                From
                    attend_plan_wk
                Where
                        thu = 1
                    And p_date Between wk_start_date And wk_end_date;

        Elsif trim(v_day) = 'FRIDAY' Then
            Insert Into attend_plan_wk_history
                Select
                    p_date,
                    empno,
                    fri,
                    'JOB',
                    sysdate
                From
                    attend_plan_wk
                Where
                        fri = 1
                    And p_date Between wk_start_date And wk_end_date;

        Elsif trim(v_day) = 'SATURDAY' Then
            Insert Into attend_plan_wk_history
                Select
                    p_date,
                    empno,
                    sat,
                    'JOB',
                    sysdate
                From
                    attend_plan_wk
                Where
                        sat = 1
                    And p_date Between wk_start_date And wk_end_date;

        End If;

        Insert Into attend_plan_wk_history_job_log Values (
            p_date,
            'SUCCESS',
            sysdate
        );

        Commit;
        p_status := 'OK';
        p_msg := 'Success';
    Exception
        When Others Then
            p_status := 'KO';
            p_msg := 'Err - '
                     || sqlcode
                     || ' - '
                     || sqlerrm;
            Rollback;
            Insert Into attend_plan_wk_history_job_log Values (
                p_date,
                substr(p_msg, 1, 1000),
                sysdate
            );

            Commit;
    End populate_history_data;

    Procedure add_attend_plan_wk (
        p_empno          In  Char,
        p_wk_start_date  In  Date,
        p_wk_end_date    In  Date,
        p_mon            In  Number,
        p_tue            In  Number,
        p_wed            In  Number,
        p_thu            In  Number,
        p_fri            In  Number,
        p_sat            In  Number,
        p_isdeleted      In  Number,
        p_by             In  Char
    ) As
    Begin
        Insert Into attend_plan_wk Values (
            dbms_random.string('X', 10),
            p_empno,
            trunc(p_wk_start_date),
            trunc(p_wk_end_date),
            p_mon,
            p_tue,
            p_wed,
            p_thu,
            p_fri,
            p_sat,
            p_isdeleted,
            p_by,
            sysdate
        );

    End;

    Procedure add_attend_shift_bus_pickup (
        p_empno          In  Char,
        p_modeler        In  Number,
        p_shift          In  Char,
        p_bus            In  Char,
        p_station        In  Varchar2,
        p_side           In  Char,
        p_city_landmark  In  Varchar2,
        p_taskforce      In  Varchar2,
        p_specialnote    In  Char,
        p_emp_plan       In  Number,
        p_by             In  Char
    ) As
        n_empno Number(1);
    Begin
        Select
            Count(empno)
        Into n_empno
        From
            attend_shift_bus_pickup
        Where
            empno = p_empno;

        If n_empno = 0 Then
            Insert Into attend_shift_bus_pickup
                Select
                    p_empno,
                    p_shift,
                    p_bus,
                    p_station,
                    p_side,
                    p_city_landmark,
                    p_taskforce,
                    p_specialnote,
                    nvl(p_emp_plan, 0),
                    p_by,
                    sysdate,
                    p_modeler
                From
                    dual;

        Else
            Update attend_shift_bus_pickup
            Set
                shift = p_shift,
                bus = p_bus,
                station = p_station,
                side = p_side,
                city_landmark = p_city_landmark,
                taskforce = p_taskforce,
                special_note = p_specialnote,
                created_by = p_by,
                created_on = sysdate
            Where
                empno = p_empno;

        End If;

    End;

    Procedure delete_attend_plan_wk (
        p_keyid In Varchar2
    ) As
    Begin
        Delete From attend_plan_wk
        Where
            keyid = Trim(p_keyid);

    End;

    Procedure attend_plan_wk_job_log (
        p_table_name  In  Varchar2,
        p_msg         In  Char
    ) As
    Begin
        Insert Into attend_plan_wk_job_log Values (
            dbms_random.string('X', 8),
            trunc(attend_plan.get_week_start_date + 7),
            trunc(attend_plan.get_week_end_date + 7),
            p_table_name,
            p_msg,
            sysdate
        );

    End;

    Function get_role (
        p_empno In Char
    ) Return Varchar2 Is
        v_empno Char(5);
    Begin
        --RETURN 'AP_EMPLOYEE';
        Select
            Count(c.empno)
        Into v_empno
        From
            dist_vu_hod  c,
            vu_emplmast  e
        Where
                c.empno = p_empno
            And c.empno = e.empno
            And e.status = 1;

        If v_empno > 0 Then
            Return 'AP_HOD';
        End If;
        Select
            Count(a.approver)
        Into v_empno
        From
            vu_empl_approver  a,
            vu_emplmast       e
        Where
                a.approver = p_empno
            And a.approver = e.empno
            And e.status = 1;

        If v_empno > 0 Then
            Return 'AP_LEAD';
        End If;
        Select
            Count(empno)
        Into v_empno
        From
            vu_emplmast
        Where
                empno = p_empno
            And status = 1;

        If v_empno > 0 Then
            Return 'AP_EMPLOYEE';
        End If;
        Return 'KO';
    End;

    Function get_query_by_role (
        p_empno In Char
    ) Return Varchar2 Is
        v_role   Varchar2(15);
        v_empno  Varchar2(5);
    Begin
        v_empno := dist_users.get_empno_from_win_uid(p_empno);
        --v_empno := '11182';
        v_role := get_role(v_empno);
        If v_role = 'AP_LEAD' Then
            Return ' where empno in (select empno from vu_empl_approver where approver = '''
                   || v_empno
                   || ''')';
        Elsif v_role = 'AP_EMPLOYEE' Then
            Return ' where empno = '''
                   || v_empno
                   || '''';
        Else
            Return ' ';
        End If;

    End;

    Function get_week_start_date Return Date As
    Begin
        If get_today_day In (
            1
        ) Then
            Return trunc(next_day(get_plan_start_date, 'MONDAY'));
        Else
            Return trunc(get_plan_start_date, 'DAY') + 1;
        End If;
    End get_week_start_date;

    Function get_week_end_date Return Date As
    Begin
        If get_today_day In (
            1
        ) Then
            Return trunc(next_day(get_plan_start_date, 'SATURDAY'));
        Else
            Return trunc(get_plan_start_date, 'DAY') + 6;
        End If;
    End get_week_end_date;

    Function get_today_day Return Number Is
    Begin
        Return to_number(to_char(get_plan_start_date, 'd'));
    End get_today_day;

    Function enable_disable_day (
        p_days Number
    ) Return Number Is
    Begin
        If trunc(attend_plan.get_week_start_date + p_days) > trunc(get_plan_start_date) Then
            Return 1;
        Else
            Return 0;
        End If;
    End enable_disable_day;

    Function isabsent (
        p_date   Date,
        p_empno  Char,
        p_days   Number
    ) Return Char Is
        v_number Number(2);
    Begin
        If trunc(p_date + p_days) > trunc(get_plan_start_date) Then
            Return 'A';
        End If;

        v_number := selfservice.isabsent(p_empno, to_date(to_char(p_date + p_days, 'dd-Mon-yyyy'), 'dd-Mon-yyyy'));

        If v_number = 1 Then
            Return 'A';
        Elsif v_number = 0 Then
            Return 'P';
        Else
            Return '-';
        End If;

    Exception
        When Others Then
            Return '-';
    End;

    Function is_present (
        p_date   Date,
        p_empno  Char,
        p_days   Number
    ) Return Number Is
        v_number Number(2);
    Begin
        If trunc(p_date + p_days) > trunc(get_plan_start_date) Then
            Return -1;
        End If;

        v_number := selfservice.isabsent(p_empno, to_date(to_char(p_date + p_days, 'dd-Mon-yyyy'), 'dd-Mon-yyyy'));

        If v_number = 0 Then
            Return 1;
        Else
            Return 0;
        End If;
    Exception
        When Others Then
            Return 0;
    End;

    Function get_device (
        p_empno Char
    ) Return Varchar2 Is
        v_device Varchar2(200);
    Begin
        v_device := pkg_dist.get_emp_laptop_csv(p_empno);
        If v_device Is Not Null Then
            Return 'LAPTOP';
        Else
            Return Null;
        End If;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_tot_seat_cap (
        p_office         Varchar2,
        p_wk_start_date  Date
    ) Return Number Is
        v_tot_seat_cap attend_office_seat_cap.tot_seat_cap%Type;
    Begin
        Select
            tot_seat_cap
        Into v_tot_seat_cap
        From
            attend_office_seat_cap
        Where
                office = p_office
            And wk_start_date = p_wk_start_date;

        Return v_tot_seat_cap;
    Exception
        When Others Then
            Return Null;
    End get_tot_seat_cap;

    Function get_tot_seat_avl (
        p_office         Varchar2,
        p_wk_start_date  Date
    ) Return Number Is
        v_tot_seat_avl attend_office_seat_cap.tot_seat_avl%Type;
    Begin
        Select
            tot_seat_avl
        Into v_tot_seat_avl
        From
            attend_office_seat_cap
        Where
                office = p_office
            And wk_start_date = p_wk_start_date;

        Return v_tot_seat_avl;
    Exception
        When Others Then
            Return Null;
    End get_tot_seat_avl;

    Function get_allt_ocu (
        p_office         Varchar2,
        p_wk_start_date  Date
    ) Return Number Is
        v_allt_ocu attend_office_seat_cap.allt_ocu%Type;
    Begin
        Select
            allt_ocu
        Into v_allt_ocu
        From
            attend_office_seat_cap
        Where
                office = p_office
            And wk_start_date = p_wk_start_date;

        Return v_allt_ocu;
    Exception
        When Others Then
            Return Null;
    End get_allt_ocu;

    Function get_next_working_day Return Date Is
    Begin
        If get_today_day = 7 Then
            Return trunc(get_plan_start_date) + 2;
        End If;
        Return trunc(get_plan_start_date) + 1;
    End;

    Function get_last_planned_date (
        p_empno Char
    ) Return Number Is
        v_planned_date Date;
    Begin
        Select
            planned_date
        Into v_planned_date
        From
            (
                Select
                    planned_date
                From
                    attend_plan_wk_history
                Where
                    empno = p_empno
                Order By
                    planned_date Desc
            )
        Where
            Rownum = 1;

        Return get_next_working_day - v_planned_date;
    Exception
        When Others Then
            Return 7;
    End;

    Procedure save_plan_data_temp (
        p_json    In   Clob,
        p_hod     In   Char,
        p_status  Out  Varchar2,
        p_msg     Out  Varchar2
    ) As

        v_empno             attend_plan_data_temp.empno%Type;
        v_assign            attend_plan_data_temp.assign%Type;
        v_attending_office  attend_plan_data_temp.attending_office%Type;
        v_modeler           attend_plan_data_temp.modeler%Type;
        v_shift             attend_plan_data_temp.shift%Type;
        v_bus               attend_plan_data_temp.bus%Type;
        v_station           attend_plan_data_temp.station%Type;
        v_side              attend_plan_data_temp.side%Type;
        v_city_landmark     attend_plan_data_temp.city_landmark%Type;
        v_taskforce         attend_plan_data_temp.taskforce%Type;
        v_special_note      attend_plan_data_temp.special_note%Type;
        v_plan_start_date   attend_plan_init_date.plan_start_date%Type;
        v_day               Varchar2(10);
        v_mon               Number(1) := 0;
        v_tue               Number(1) := 0;
        v_wed               Number(1) := 0;
        v_thu               Number(1) := 0;
        v_fri               Number(1) := 0;
        v_sat               Number(1) := 0;
        v_flag              Number(1) := 0;
    Begin
        /*Begin
            Select
                plan_start_date
            Into v_plan_start_date
            From
                attend_plan_init_date;

            v_day := to_char(v_plan_start_date, 'DAY');
            If trim(v_day) = 'SUNDAY' Then
                p_status := 'KO';
                p_msg := 'Err - Not allowed for Sunday !!';
                return;
            End If;

            v_flag := 1;
            If trim(v_day) = 'MONDAY' Then
                v_mon := 1;
                v_tue := 1;
                v_wed := 1;
                v_thu := 1;
                v_fri := 1;
                v_sat := 1;
            Elsif trim(v_day) = 'TUESDAY' Then
                v_tue := 1;
                v_wed := 1;
                v_thu := 1;
                v_fri := 1;
                v_sat := 1;
            Elsif trim(v_day) = 'WEDNESDAY' Then
                v_wed := 1;
                v_thu := 1;
                v_fri := 1;
                v_sat := 1;
            Elsif trim(v_day) = 'THURSDAY' Then
                v_thu := 1;
                v_fri := 1;
                v_sat := 1;
            Elsif trim(v_day) = 'FRIDAY' Then
                v_fri := 1;
                v_sat := 1;
            Elsif trim(v_day) = 'SATURDAY' Then
                v_sat := 1;
            End If;

        Exception
            When Others Then
                Null;
        End;*/

        apex_json.parse(p_json);
        For i In 1..apex_json.get_count('data') Loop
            v_empno := apex_json.get_varchar2('data[%d].EMPNO', i);
            v_assign := apex_json.get_varchar2('data[%d].ASSIGN', i);
            v_attending_office := apex_json.get_number('data[%d].ATTENDING_OFFICE', i);
            v_modeler := apex_json.get_number('data[%d].MODELER', i);
            v_shift := apex_json.get_varchar2('data[%d].SHIFT', i);
            v_bus := apex_json.get_number('data[%d].BUS', i);
            v_station := apex_json.get_varchar2('data[%d].STATION', i);
            v_side := apex_json.get_varchar2('data[%d].SIDE', i);
            v_city_landmark := apex_json.get_varchar2('data[%d].CITY_LANDMARK', i);
            v_taskforce := apex_json.get_varchar2('data[%d].TASKFORCE', i);
            v_special_note := apex_json.get_varchar2('data[%d].SPECIAL_NOTE', i);
            Delete From attend_plan_data_temp
            Where
                empno = Trim(v_empno);

            Insert Into attend_plan_data_temp Values (
                Trim(v_empno),
                Trim(v_assign),
                v_attending_office,
                v_modeler,
                v_shift,
                v_bus,
                v_station,
                v_side,
                v_city_landmark,
                v_taskforce,
                dist_users.get_empno_from_win_uid(p_hod),
                sysdate,
                v_special_note
            );

            /*Delete From attend_shift_bus_pickup
            Where
                empno = Trim(v_empno);

            Insert Into attend_shift_bus_pickup Values (
                Trim(v_empno),
                v_shift,
                v_bus,
                v_station,
                v_side,
                v_city_landmark,
                v_taskforce,
                v_special_note,
                0,
                dist_users.get_empno_from_win_uid(p_hod),
                sysdate,
                v_modeler
            );

            If v_flag = 1 Then
                Insert Into attend_plan_wk Values (
                    dbms_random.string('X', 10),
                    v_empno,
                    get_week_start_date,
                    get_week_end_date,
                    v_mon,
                    v_tue,
                    v_wed,
                    v_thu,
                    v_fri,
                    v_sat,
                    0,
                    dist_users.get_empno_from_win_uid(p_hod),
                    sysdate
                );

            End If;*/

            Commit;
        End Loop;

        Commit;
        p_status := 'OK';
        p_msg := 'Success';
    Exception
        When Others Then
            p_status := 'KO';
            p_msg := 'Err - '
                     || sqlcode
                     || ' - '
                     || sqlerrm;
    End save_plan_data_temp;

    Function get_plan_start_date Return Date Is
        v_plan_start_date Date;
    Begin
        Select
            greatest(plan_start_date, sysdate)
        Into v_plan_start_date
        From
            attend_plan_init_date;

        Return v_plan_start_date;
    Exception
        When Others Then
            Return sysdate;
    End get_plan_start_date;

End attend_plan;

/

  GRANT EXECUTE ON "ITINV_STK"."ATTEND_PLAN" TO "SELFSERVICE";
