--------------------------------------------------------
--  DDL for Package Body SUM_WRK_HRS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."SUM_WRK_HRS" As

    Procedure get_emp_work_hrs (
        param_empno          Varchar2,
        param_bdate          Date,
        param_edate          Date,
        param_act_wrk_hrs    Out   Number,
        param_tar_wrk_hrs    Out   Number,
        param_sat_wrk_hrs    Out   Number,
        param_sun_wrk_hrs    Out   Number,
        param_hh_wrk_hrs     Out   Number,
        param_sat_wrk_days   Out   Number,
        param_sun_wrk_days   Out   Number,
        param_hh_wrk_days    Out   Number,
        param_success        Out   Varchar2,
        param_message        Out   Varchar2
    ) As
    Begin
        Null;
        Select
            Sum(shift_hrs),
            Sum(act_wrkhrs),
            Sum(sat_wrkhrs),
            Sum(sun_wrkhrs),
            Sum(hh_wrkhrs),
            Sum(sat_day),
            Sum(sun_day),
            Sum(hh_day)
        Into
            param_tar_wrk_hrs,
            param_act_wrk_hrs,
            param_sat_wrk_hrs,
            param_sun_wrk_hrs,
            param_hh_wrk_hrs,
            param_sat_wrk_days,
            param_sun_wrk_days,
            param_hh_wrk_days
        From
            (
                Select
                    shift_hrs,
                    act_wrkhrs,
                    sat_wrkhrs,
                    sun_wrkhrs,
                    hh_wrkhrs,
                    Case
                        When sat_wrkhrs > 0 Then
                            1
                        Else
                            0
                    End As sat_day,
                    Case
                        When sun_wrkhrs > 0 Then
                            1
                        Else
                            0
                    End As sun_day,
                    Case
                        When hh_wrkhrs > 0 Then
                            1
                        Else
                            0
                    End As hh_day
                From
                    (
                        With shift As (
                            Select
                                shiftcode,
                                ( ( ( ( ( ( timeout_hh * 60 ) + nvl(timeout_mn, 0) ) - ( ( timein_hh * 60 ) + timein_mn ) ) - nvl
                                (lunch_mn, 0) ) ) / 60 ) shift_hrs
                            From
                                ss_shiftmast
                        )
                        Select
                            b.shift_hrs,
                            Case
                                When holiday_type = 0 Then
                                    n_workedhrs(param_empno, d_date, a.shiftcode)
                                Else
                                    0
                            End As act_wrkhrs,
                            Case
                                When holiday_type = 1 Then
                                    n_workedhrs(param_empno, d_date, a.shiftcode)
                                Else
                                    0
                            End As sat_wrkhrs,
                            Case
                                When holiday_type = 2 Then
                                    n_workedhrs(param_empno, d_date, a.shiftcode)
                                Else
                                    0
                            End As sun_wrkhrs,
                            Case
                                When holiday_type = 3 Then
                                    n_workedhrs(param_empno, d_date, a.shiftcode)
                                Else
                                    0
                            End As hh_wrkhrs
                        From
                            (
                                Select
                                    d_date,
                                    getshift1(param_empno, d_date) As shiftcode,
                                    get_holiday(d_date) As holiday_type
                                From
                                    ss_days_details
                                Where
                                    d_date <= ( param_edate ) And d_date >= param_bdate
                            ) a,
                            shift b
                        Where
                            a.shiftcode = b.shiftcode (+)
                    )
            );

    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure populate_data (
        param_yyyymm    Varchar2,
        param_success   Out   Varchar2,
        param_message   Out   Varchar2
    ) As

        Cursor cur_emp_list (
            cp_month_bdate Date
        ) Is
        Select
            empno,
            name,
            parent,
            grade,
            greatest(doj, cp_month_bdate) bdate,
            least(nvl(dol, last_day(cp_month_bdate)), last_day(cp_month_bdate)) edate
        From
            ss_emplmast
        Where
            ( ( status = 1 And doj < last_day(cp_month_bdate) ) Or ( status = 0 And dol Between cp_month_bdate And last_day(cp_month_bdate
            ) ) ) And emptype In (
                'R',
                'S',
                'C'
            ) order by empno;

        v_key_id           Varchar2(5);
        v_bdate            Date;
        v_edate            Date;
        Type typ_tab_emp Is
            Table Of cur_emp_list%rowtype;
        tab_emp            typ_tab_emp;
        v_master_created   Varchar2(2);
    Begin
        v_master_created := 'KO';
        v_key_id := dbms_random.string('X', 5);
        Delete From ss_worked_hrs_mast
        Where
            yyyymm = param_yyyymm;

        Delete From ss_worked_hrs_detail
        Where
            yyyymm = param_yyyymm;

        Commit;
        Insert Into ss_worked_hrs_mast (
            key_id,
            yyyymm,
            modified_on,
            proc_status
        ) Values (
            v_key_id,
            param_yyyymm,
            sysdate,
            'WP'
        );

        v_master_created := 'OK';
        Commit;
        v_bdate := trunc(to_date(param_yyyymm, 'yyyymm'), 'month');
        v_edate := last_day(v_bdate);
        Open cur_emp_list(v_bdate);
        Loop
            Fetch cur_emp_list Bulk Collect Into tab_emp Limit 100;
            For i In 1..tab_emp.count Loop Declare
                v_act_wrk_hrs    Number;
                v_tar_wrk_hrs    Number;
                v_sat_wrk_hrs    Number;
                v_sun_wrk_hrs    Number;
                v_hh_wrk_hrs     Number;
                v_sat_wrk_days   Number;
                v_sun_wrk_days   Number;
                v_hh_wrk_days    Number;
                v_success        Varchar2(10);
                v_message        Varchar2(2000);
            Begin
                get_emp_work_hrs(tab_emp(i).empno, tab_emp(i).bdate, tab_emp(i).edate, v_act_wrk_hrs, v_tar_wrk_hrs,
                                 v_sat_wrk_hrs, v_sun_wrk_hrs, v_hh_wrk_hrs, v_sat_wrk_days, v_sun_wrk_days,
                                 v_hh_wrk_days, v_success, v_message);

                If v_success = 'KO' Then
                    Continue;
                End If;
                Insert Into ss_worked_hrs_detail (
                    key_id,
                    yyyymm,
                    empno,
                    tar_work_hrs,
                    act_work_hrs,
                    act_sat_work_hrs,
                    act_sun_work_hrs,
                    act_hh_work_hrs,
                    act_sat_work_days,
                    act_sun_work_days,
                    act_hh_work_days
                ) Values (
                    v_key_id,
                    param_yyyymm,
                    tab_emp(i).empno,
                    v_tar_wrk_hrs,
                    ( trunc(v_act_wrk_hrs / 15) * 15 ) / 60,
                    ( trunc(v_sat_wrk_hrs / 15) * 15 ) / 60,
                    ( trunc(v_sun_wrk_hrs / 15) * 15 ) / 60,
                    ( trunc(v_hh_wrk_hrs / 15) * 15 ) / 60,
                    v_sat_wrk_days,
                    v_sun_wrk_days,
                    v_hh_wrk_days
                );

                Commit;
            End;
            End Loop;

            Exit When cur_emp_list%notfound;
        End Loop;

        Update ss_worked_hrs_mast
        Set
            proc_status = 'OK'
        Where
            key_id = v_key_id;

        param_success := 'OK';
    Exception
        When Others Then
            If v_master_created = 'OK' Then
                Update ss_worked_hrs_mast
                Set
                    proc_status = 'KO'
                Where
                    key_id = v_key_id;

                Commit;
            End If;

            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End populate_data;

End sum_wrk_hrs;


/
