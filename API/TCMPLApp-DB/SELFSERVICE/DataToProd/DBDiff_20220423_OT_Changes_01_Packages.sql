--------------------------------------------------------
--  File created - Saturday-April-23-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--IOT_PUNCH_DETAILS
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_PUNCH_DETAILS" As

    Cursor cur_tab Is
        Select
            *
        From
            tab;

    Cursor cur_for_punch_data(cp_empno      Varchar2,
                              cp_start_date Date,
                              cp_end_date   Date) Is
        Select
            typ_row_punch_data(
                empno,
                dd,
                ddd,
                d_date,
                shiftcode,
                wk_of_year,
                first_punch,
                last_punch,
                penaltyhrs,
                is_odd_punch,
                is_ldt,
                is_sunday,
                islwd,
                islcapp,
                issleaveapp,
                is_absent,
                slappcntr,
                ego,
                wrkhrs,
                deltahrs,
                extra_hours,
                comp_off_hrs,
                last_day_cfwd_dhrs,
                Sum(wrkhrs) Over (Partition By wk_of_year),
                Sum(deltahrs) Over (Partition By wk_of_year),
                Sum(extra_hours) Over (Partition By wk_of_year),
                Sum(comp_off_hrs) Over (Partition By wk_of_year),
                Sum(weekday_extra_hours) Over (Partition By wk_of_year),
                Sum(holiday_extra_hours) Over (Partition By wk_of_year),
                wk_bfwd_delta_hrs,
                wk_cfwd_delta_hrs,
                wk_penalty_leave_hrs,
                day_punch_count,
                remarks
            --,
            --str_wrk_hrs,
            --str_delta_hrs,
            --str_extra_hrs,
            --str_ts_work_hrs,
            --str_ts_extra_hrs,
            --str_wk_sum_work_hrs,
            --str_wk_sum_delta_hrs,
            --str_wk_bfwd_delta_hrs,
            --str_wk_cfwd_delta_hrs,
            --str_wk_penalty_leave_hrs
            )
        From
            (
                Select
                    main_main_query.*,
                    n_otperiod_inlcude_2nd_shift(cp_empno, d_date, shiftcode, deltahrs)                       As extra_hours,
                    trunc(n_otperiod_inlcude_2nd_shift(cp_empno, d_date, shiftcode, deltahrs, 1) / 240) * 240 As comp_off_hrs,
                    Case
                        When is_sunday = 0 Then

                            n_otperiod_inlcude_2nd_shift(cp_empno, d_date, shiftcode, deltahrs)
                        Else
                            0
                    End                                                                     As weekday_extra_hours,
                    Case
                        When is_sunday > 0 Then

                            n_otperiod_inlcude_2nd_shift(cp_empno, d_date, shiftcode, deltahrs)
                        Else
                            0
                    End                                                                     As holiday_extra_hours,
                    Case
                        When islwd = 1 Then

                            lastday_cfwd_dhrs1(
                                p_deltahrs  => deltahrs,
                                p_ego       => ego,
                                p_slapp     => issleaveapp,
                                p_slappcntr => slappcntr,
                                p_islwd     => islwd
                            )
                        Else
                            0
                    End                                                                     As last_day_cfwd_dhrs

                From
                    (
                        Select
                            main_query.*,
                            n_deltahrs(cp_empno, d_date, shiftcode, penaltyhrs) As deltahrs,
                            Case
                                When day_punch_count > 1 Then
                                    to_hrs(firstlastpunch1(cp_empno, d_date, 1))
                                Else
                                    ''
                            End                                                 As last_punch
                        From
                            (
                                Select
                                    cp_empno                                                        As empno,
                                    d_dd                                                            As dd,
                                    d_day                                                           As ddd,
                                    wk_of_year,

                                    to_hrs(firstlastpunch1(cp_empno, d_date, 0))                    As first_punch,

                                    penaltyleave1(

                                        latecome1(cp_empno, d_date),
                                        earlygo1(cp_empno, d_date),
                                        islastworkday1(cp_empno, d_date),

                                        Sum(islcomeegoapp(cp_empno, d_date))
                                            Over ( Partition By wk_of_year Order By d_date
                                                Range Between Unbounded Preceding And Current Row),

                                        n_sum_slapp_count(cp_empno, d_date),

                                        islcomeegoapp(cp_empno, d_date),
                                        issleaveapp(cp_empno, d_date)
                                    )                                                               As penaltyhrs,
                                    is_odd_punch(cp_empno, d_date)                                  As is_odd_punch,
                                    to_char(d_date, 'dd-Mon-yyyy')                                  As mdate,
                                    d_dd                                                            As sday,
                                    d_date,
                                    getshift1(cp_empno, d_date)                                     As shiftcode,
                                    isleavedeputour(d_date, cp_empno)                               As is_ldt,
                                    get_holiday(d_date)                                             As is_sunday,
                                    islastworkday1(cp_empno, d_date)                                As islwd,
                                    lc_appcount(cp_empno, d_date)                                   As islcapp,
                                    issleaveapp(cp_empno, d_date)                                   As issleaveapp,
                                    isabsent(cp_empno, d_date)                                      As is_absent,

                                    n_sum_slapp_count(cp_empno, d_date)                             As slappcntr,

                                    earlygo1(cp_empno, d_date)                                      As ego,
                                    n_workedhrs(cp_empno, d_date, getshift1(cp_empno, d_date))      As wrkhrs,

                                    0                                                               As wk_bfwd_delta_hrs,
                                    0                                                               As wk_cfwd_delta_hrs,
                                    0                                                               As wk_penalty_leave_hrs,
                                    punchcount(cp_empno, d_date)                                    As day_punch_count,
                                    Null                                                            As remarks,
                                    ''                                                              As str_wrk_hrs,
                                    ''                                                              As str_delta_hrs,
                                    ''                                                              As str_extra_hrs,
                                    ''                                                              As str_wk_sum_work_hrs,
                                    ''                                                              As str_wk_sum_delta_hrs,
                                    ''                                                              As str_wk_bfwd_delta_hrs,
                                    ''                                                              As str_wk_cfwd_delta_hrs,
                                    ''                                                              As str_wk_penalty_leave_hrs,
                                    to_hrs(nvl(get_time_sheet_work_hrs(cp_empno, d_date), 0) * 60)  As str_ts_work_hrs,
                                    to_hrs(nvl(get_time_sheet_extra_hrs(cp_empno, d_date), 0) * 60) As str_ts_extra_hrs
                                --v_max_punch                                              tot_punch_nos

                                From
                                    ss_days_details
                                Where
                                    d_date Between cp_start_date And cp_end_date
                                Order By d_date
                            ) main_query
                    ) main_main_query
            )
        Order By
            d_date;

    Type pls_typ_tab_punch_data Is Table Of cur_for_punch_data%rowtype;
    /*
        Function fn_punch_details_4_self(
            p_person_id Varchar2,
            p_meta_id   Varchar2,
            p_yyyymm    Varchar2
        ) Return Sys_Refcursor;
    */
    Cursor cur_day_punch_list(cp_empno Varchar2,
                              p_pdate  Date) Is
        Select
            cp_empno                                    empno,
            pdate                                       punch_date,
            lpad(hh, 2, '0') || ':' || lpad(mm, 2, '0') punch_time,
            substr(b.office, 4, 1)                      office
        From
            ss_integratedpunch                       a, ss_swipe_mach_mast b
        Where
            empno      = cp_empno
            And a.mach = b.mach_name(+)
            And pdate  = p_pdate
        Order By
            hh,
            mm,
            ss,
            hhsort,
            mmsort,
            hh,
            mm;
    Type typ_tab_day_punch_list Is Table Of cur_day_punch_list%rowtype;

    --

    Function fn_punch_details_4_self(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null,
        p_yyyymm    Varchar2,
        p_for_ot    Varchar2 Default 'KO'
    ) Return typ_tab_punch_data
        Pipelined;

    Function fn_day_punch_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2,
        p_date      Date
    ) Return typ_tab_day_punch_list
        Pipelined;

    Procedure punch_details_pipe(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null,
        p_yyyymm    Varchar2,
        p_for_ot    Varchar2 Default 'KO'
    );

End iot_punch_details;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_CONFIG_WEEK
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_CONFIG_WEEK" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

    Procedure sp_configuration;

    Procedure sp_add_new_joinees_to_pws;

    Procedure sp_mail_plan_to_emp;

    v_ows_mail_body Varchar2(1000) := '<p>Dear User,</p><p>You have been assigned <strong>Office</strong> as your 
    primary workspace for the week between <strong>!@StartDate@!</strong> and <strong>!@EndDate@!</strong> .</p><p>
    You will be required to attend office daily between such period.</p><p></p><p>SWP</p>';
/*
    v_sws_mail_body Varchar2(2000) := '<p>Dear User,</p>rn<p>You have been assigned <strong>Smart</strong> as your 
    primary workspace for the week between <strong>!@StartDate@!</strong> and <strong>!@EndDate@!</strong> .</p>rn<p>
    You will be required to attend office on below mentioned days between such period.
    </p>rn<table border="1" style="border-collapse: collapse; width: 75.7746%;" height="56">rn
    <tbody>rn<tr>rn<td>Date</td>rn<td>Day</td>rn<td>DeskId</td>rn<td>Office</td>rn<td>Floor</td>rn<td>Wing</td>rn</tr>rn
    !@WEEKLYPLANNING@!    
	</tbody>rn
    </table>rn<p></p>rn<p></p>rn<p>SWP</p>';
*/
v_sws_mail_body Varchar2(2000) := '<p>Dear Colleague,</p>
<p>This is to inform you that as per our new working arrangement in accordance with the Smart Work Policy sent vide email on 1st June 2021, employees have been allocated a Primary Workspace which can be either an "Office Workspace" or a "Smart Workspace".</p>
<p>You have been assigned <strong>Smart Workspace</strong> as your primary workspace for the week between <strong>!@StartDate@!</strong> and <strong>!@EndDate@!</strong> .</p>
<p>You will be required to attend office on below mentioned day/s between such period.</p>
<p><strong>!@User@!</strong> attendance plan</p>
<table style="border-collapse: collapse; width: 75.7746%;" border="1">
<tbody>
<tr>
<td>Date</td>
<td>Day</td>
<td>DeskId</td>
<td>Office</td>
<td>Floor</td>
<td>Wing</td>
</tr>
!@WEEKLYPLANNING@!
</tbody>
</table>
<p> </p>
<p>The above mentioned desk/s are dynamically allocated. It may not be the same desk as the one occupied by you prior to moving to Smart Workspace.</p>
<p>Please report to the office on the above mentioned date/s only and occupy the corresponding desk only.</p>
<p>You are expected to observe the above schedule strictly.</p>
<p>In case you do not report to office on the above mentioned date/s, you must apply for leave for those date/s or the system will deduct your leave / log an LOP (Loss of Pay), as applicable.</p>
<p>Interchanging of scheduled date/s with other colleagues is not allowed and the employee will be considered as "Absent" for the scheduled date/s in case of such interchange.</p>
<p>If you are required to use monitor and keyboard provided on office desk, you must bring your docking station along with you.</p>
<p>Also carry your headphones along with you.</p>
<p><strong>Special note to Microsoft Surface users : Surface users must also bring DP to mini DP cable provided to them at the time of issue of Laptop, along with the docking station.</strong></p>
<p> </p>';

    v_sws_empty_day_row Varchar2(200) := '<tr><td>DATE</td><td>DAY</td><td>DESKID</td><td>OFFICE</td><td>FLOOR</td><td>WING</td></tr>';


End iot_swp_config_week;
/
---------------------------
--Changed PACKAGE BODY
--IOT_PUNCH_DETAILS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_PUNCH_DETAILS" As

    Procedure calculate_weekly_cfwd_hrs(
        p_wk_bfwd_dhrs   Number,
        p_wk_dhrs        Number,
        p_lday_lcome_ego Number,
        p_fri_sl_app     Number,
        p_cfwd_dhrs Out  Number,
        p_pn_hrs    Out  Number
    )
    As
        v_wk_negative_delta Number;
    Begin
        v_wk_negative_delta := nvl(p_wk_bfwd_dhrs, 0) + nvl(p_wk_dhrs, 0);
        If v_wk_negative_delta >= 0 Then
            p_pn_hrs    := 0;
            p_cfwd_dhrs := 0;
            Return;
        End If;
        If p_fri_sl_app <> 1 Then
            p_pn_hrs := ceil((v_wk_negative_delta * -1) / 60);
            If p_pn_hrs Between 5 And 8 Then
                p_pn_hrs := 8;
            End If;

            If p_pn_hrs * 60 > v_wk_negative_delta * -1 Then
                p_cfwd_dhrs := 0;
            Else
                p_cfwd_dhrs := v_wk_negative_delta + p_pn_hrs * 60;
            End If;
        Elsif p_fri_sl_app = 1 Then
            If v_wk_negative_delta > p_lday_lcome_ego Then
                p_pn_hrs    := 0;
                p_cfwd_dhrs := v_wk_negative_delta;
            Elsif v_wk_negative_delta < p_lday_lcome_ego Then
                p_pn_hrs := ceil((v_wk_negative_delta + (p_lday_lcome_ego * -1)) * -1 / 60);
                If p_pn_hrs Between 5 And 8 Then
                    p_pn_hrs := 8;
                End If;
                If p_pn_hrs * 60 > v_wk_negative_delta * -1 Then
                    p_cfwd_dhrs := 0;
                Else
                    p_cfwd_dhrs := v_wk_negative_delta + p_pn_hrs * 60;
                End If;
            End If;
        End If;
        p_pn_hrs            := nvl(p_pn_hrs, 0) * 60;
    End;
    /*
        Function fn_punch_details_4_self(
            p_person_id Varchar2,
            p_meta_id   Varchar2,
            p_yyyymm    Varchar2
        ) Return Sys_Refcursor As
            v_start_date             Date;
            v_end_date               Date;
            v_max_punch              Number;
            v_empno                  Varchar2(5);
            v_prev_delta_hrs         Number;
            v_prev_cfwd_lwd_deltahrs Number;
            v_prev_lc_app_cntr       Number;
            c                        Sys_Refcursor;
            e_employee_not_found     Exception;
            Pragma exception_init(e_employee_not_found, -20001);
        Begin
            v_empno      := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;
            v_end_date   := last_day(to_date(p_yyyymm, 'yyyymm'));
            v_start_date := n_getstartdate(to_char(v_end_date, 'mm'), to_char(v_end_date, 'yyyy'));

            v_max_punch  := n_maxpunch(v_empno, v_start_date, v_end_date);

            --n_cfwd_lwd_deltahrs(v_empno, to_date(p_yyyymm, 'yyyymm'), 0, v_prev_delta_hrs, v_prev_cfwd_lwd_deltahrs, v_prev_lc_app_cntr);

            Open c For
                Select
                    empno,
                    days,
                    wk_of_year,
                    penaltyhrs,
                    mdate,
                    sday,
                    d_date,
                    shiftcode,
                    islod,
                    issunday,
                    islwd,
                    islcapp,
                    issleaveapp,
                    is_absent,
                    slappcntr,

                    ego,
                    wrkhrs,
                    tot_punch_nos,
                    deltahrs,
                    extra_hours,
                    last_day_c_fwd_dhrs,
                    Sum(wrkhrs) Over (Partition By wk_of_year)   As sum_work_hrs,
                    Sum(deltahrs) Over (Partition By wk_of_year) As sum_delta_hrs,
                    0                                            bfwd_delta_hrs,
                    0                                            cfwd_delta_hrs,
                    0                                            penalty_leave_hrs
                From
                    (
                        Select
                            main_main_query.*,
                            n_otperiod(v_empno, d_date, shiftcode, deltahrs) As extra_hours,
                            Case
                                When islwd = 1 Then

                                    lastday_cfwd_dhrs1(
                                        p_deltahrs  => deltahrs,
                                        p_ego       => ego,
                                        p_slapp     => issleaveapp,
                                        p_slappcntr => slappcntr,
                                        p_islwd     => islwd
                                    )
                                Else
                                    0
                            End                                              As last_day_c_fwd_dhrs

                        From
                            (
                                Select
                                    main_query.*, n_deltahrs(v_empno, d_date, shiftcode, penaltyhrs) As deltahrs
                                From
                                    (
                                        Select
                                            v_empno                                                  As empno,
                                            to_char(d_date, 'dd')                                    As days,
                                            wk_of_year,
                                            penaltyleave1(

                                                latecome1(v_empno, d_date),
                                                earlygo1(v_empno, d_date),
                                                islastworkday1(v_empno, d_date),

                                                Sum(islcomeegoapp(v_empno, d_date))
                                                    Over ( Partition By wk_of_year Order By d_date
                                                        Range Between Unbounded Preceding And Current Row),

                                                n_sum_slapp_count(v_empno, d_date),

                                                islcomeegoapp(v_empno, d_date),
                                                issleaveapp(v_empno, d_date)
                                            )                                                        As penaltyhrs,

                                            to_char(d_date, 'dd-Mon-yyyy')                           As mdate,
                                            d_dd                                                     As sday,
                                            d_date,
                                            getshift1(v_empno, d_date)                               As shiftcode,
                                            isleavedeputour(d_date, v_empno)                         As islod,
                                            get_holiday(d_date)                                      As issunday,
                                            islastworkday1(v_empno, d_date)                          As islwd,
                                            lc_appcount(v_empno, d_date)                             As islcapp,
                                            issleaveapp(v_empno, d_date)                             As issleaveapp,

                                            n_sum_slapp_count(v_empno, d_date)                       As slappcntr,

                                            isabsent(v_empno, d_date)                                As is_absent,
                                            earlygo1(v_empno, d_date)                                As ego,
                                            n_workedhrs(v_empno, d_date, getshift1(v_empno, d_date)) As wrkhrs,

                                            v_max_punch                                              tot_punch_nos

                                        From
                                            ss_days_details
                                        Where
                                            d_date Between v_start_date And v_end_date
                                        Order By d_date
                                    ) main_query
                            ) main_main_query
                    );

            Return c;
        End fn_punch_details_4_self;
    */
    Function fn_punch_details_4_self(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null,
        p_yyyymm    Varchar2,
        p_for_ot    Varchar2 Default 'KO'
    ) Return typ_tab_punch_data
        Pipelined
    Is
        v_prev_delta_hrs               Number;
        v_prev_lwrk_day_cfwd_delta_hrs Number;
        v_prev_lcome_app_cntr          Number;
        tab_punch_data                 typ_tab_punch_data;
        v_start_date                   Date;
        v_end_date                     Date;
        v_max_punch                    Number;
        v_empno                        Varchar2(5);
        e_employee_not_found           Exception;
        v_is_fri_lcome_ego_app         Number;
        c_absent                       Constant Number := 1;
        c_ldt_leave                    Constant Number := 1;
        c_ldt_tour_depu                Constant Number := 2;
        c_ldt_remote_work              Constant Number := 3;
        v_count                        Number;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        If Trim(p_empno) Is Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return;
            End If;
            /*Else
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_emplmast
                Where
                    empno      = p_empno
                    And status = 1;

                If v_count = 0 Then
                    Raise e_employee_not_found;
                    Return;
                Else
                    v_empno := p_empno;
                End If;*/
        Else
            v_empno := p_empno;

        End If;
        If p_for_ot = 'OK' Then
            v_end_date := n_getenddate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));
        Else
            v_end_date := last_day(to_date(p_yyyymm, 'yyyymm'));
        End If;
        v_start_date := n_getstartdate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));

        v_max_punch  := n_maxpunch(v_empno, v_start_date, v_end_date);

        n_cfwd_lwd_deltahrs(
            p_empno       => v_empno,
            p_pdate       => to_date(p_yyyymm, 'yyyymm'),
            p_savetot     => 0,
            p_deltahrs    => v_prev_delta_hrs,
            p_lwddeltahrs => v_prev_lwrk_day_cfwd_delta_hrs,
            p_lcappcntr   => v_prev_lcome_app_cntr
        );

        Open cur_for_punch_data(v_empno, v_start_date, v_end_date);
        Loop
            Fetch cur_for_punch_data Bulk Collect Into tab_punch_data Limit 7;
            For i In 1..tab_punch_data.count
            Loop

                --tab_punch_data(i).str_wrk_hrs              := to_hrs(tab_punch_data(i).wrk_hrs);
                --tab_punch_data(i).str_delta_hrs            := to_hrs(tab_punch_data(i).delta_hrs);
                --tab_punch_data(i).str_extra_hrs            := to_hrs(tab_punch_data(i).extra_hrs);

                If tab_punch_data(i).is_absent = 1 Then
                    tab_punch_data(i).remarks := 'Absent';
                Elsif tab_punch_data(i).penalty_hrs > 0 Then
                    If tab_punch_data(i).day_punch_count = 1 Then
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '_HrsLeaveDedu(MissedPunch)';
                    Else
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '_HrsLeaveDeducted';
                    End If;
                Elsif tab_punch_data(i).is_ldt = c_ldt_leave Then
                    tab_punch_data(i).remarks := 'OnLeave';
                Elsif tab_punch_data(i).is_ldt = c_ldt_tour_depu Then
                    tab_punch_data(i).remarks := 'OnTour-Depu';
                Elsif tab_punch_data(i).is_ldt = c_ldt_remote_work Then
                    tab_punch_data(i).remarks := 'RemoteWork';
                Elsif (tab_punch_data(i).is_sleave_app > 0 And tab_punch_data(i).sl_app_cntr < 3) Then
                    tab_punch_data(i).remarks := 'SLeave(Apprd)';
                Elsif tab_punch_data(i).is_lc_app > 0 Then
                    tab_punch_data(i).remarks := 'LCome(Apprd)';
                Elsif tab_punch_data(i).day_punch_count = 1 Then
                    tab_punch_data(i).remarks := 'MissedPunch';
                End If;
                If tab_punch_data(i).is_lwd = 1 And tab_punch_data(i).is_sleave_app = 1 And tab_punch_data(i).sl_app_cntr < 3
                Then
                    v_is_fri_lcome_ego_app := 1;
                Else
                    v_is_fri_lcome_ego_app := 0;
                End If;

                If i = 7 Then
                    tab_punch_data(i).wk_bfwd_delta_hrs := v_prev_lwrk_day_cfwd_delta_hrs;
                    calculate_weekly_cfwd_hrs(
                        p_wk_bfwd_dhrs   => tab_punch_data(i).wk_bfwd_delta_hrs,
                        p_wk_dhrs        => tab_punch_data(i).wk_sum_delta_hrs,
                        p_lday_lcome_ego => tab_punch_data(i).last_day_cfwd_dhrs,
                        p_fri_sl_app     => v_is_fri_lcome_ego_app,
                        p_cfwd_dhrs      => tab_punch_data(i).wk_cfwd_delta_hrs,
                        p_pn_hrs         => tab_punch_data(i).wk_penalty_leave_hrs
                    );
                    v_prev_lwrk_day_cfwd_delta_hrs      := tab_punch_data(i).wk_cfwd_delta_hrs;
                End If;

                --tab_punch_data(i).str_wk_sum_work_hrs      := to_hrs(tab_punch_data(i).wk_sum_work_hrs);
                --tab_punch_data(i).str_wk_sum_delta_hrs     := to_hrs(tab_punch_data(i).wk_sum_delta_hrs);
                --tab_punch_data(i).str_wk_bfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_bfwd_delta_hrs);
                --tab_punch_data(i).str_wk_cfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_cfwd_delta_hrs);
                --tab_punch_data(i).str_wk_penalty_leave_hrs := to_hrs(tab_punch_data(i).wk_penalty_leave_hrs);

                Pipe Row(tab_punch_data(i));
            End Loop;
            tab_punch_data := Null;
            Exit When cur_for_punch_data%notfound;
        End Loop;
        Close cur_for_punch_data;
        Return;
    End fn_punch_details_4_self;

    Function fn_day_punch_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2,
        p_date      Date
    ) Return typ_tab_day_punch_list
        Pipelined
    Is
        tab_day_punch_list   typ_tab_day_punch_list;
        v_count              Number;

        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = p_empno;
        If v_count = 0 Then
            Raise e_employee_not_found;
            Return;
        End If;

        Open cur_day_punch_list(p_empno, p_date);
        Loop
            Fetch cur_day_punch_list Bulk Collect Into tab_day_punch_list Limit 50;
            For i In 1..tab_day_punch_list.count
            Loop
                Pipe Row(tab_day_punch_list(i));
            End Loop;
            Exit When cur_day_punch_list%notfound;
        End Loop;
        Close cur_day_punch_list;
        Return;
    End fn_day_punch_list;

    Procedure punch_details_pipe(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null,
        p_yyyymm    Varchar2,
        p_for_ot    Varchar2 Default 'KO'
    )
    Is
        v_prev_delta_hrs               Number;
        v_prev_lwrk_day_cfwd_delta_hrs Number;
        v_prev_lcome_app_cntr          Number;
        tab_punch_data                 typ_tab_punch_data;
        v_start_date                   Date;
        v_end_date                     Date;
        v_max_punch                    Number;
        v_empno                        Varchar2(5);
        e_employee_not_found           Exception;
        v_is_fri_lcome_ego_app         Number;
        c_absent                       Constant Number := 1;
        c_ldt_leave                    Constant Number := 1;
        c_ldt_tour_depu                Constant Number := 2;
        c_ldt_remote_work              Constant Number := 3;
        v_count                        Number;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        If Trim(p_empno) Is Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return;
            End If;
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno      = p_empno
                And status = 1;

            If v_count = 0 Then
                Raise e_employee_not_found;
                Return;
            Else
                v_empno := p_empno;
            End If;
        End If;
        If p_for_ot = 'OK' Then
            v_end_date := n_getenddate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));
        Else
            v_end_date := last_day(to_date(p_yyyymm, 'yyyymm'));
        End If;
        v_start_date := n_getstartdate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));

        v_max_punch  := n_maxpunch(v_empno, v_start_date, v_end_date);

        n_cfwd_lwd_deltahrs(
            p_empno       => v_empno,
            p_pdate       => to_date(p_yyyymm, 'yyyymm'),
            p_savetot     => 0,
            p_deltahrs    => v_prev_delta_hrs,
            p_lwddeltahrs => v_prev_lwrk_day_cfwd_delta_hrs,
            p_lcappcntr   => v_prev_lcome_app_cntr
        );

        Open cur_for_punch_data(v_empno, v_start_date, v_end_date);
        Loop
            Fetch cur_for_punch_data Bulk Collect Into tab_punch_data Limit 7;
            For i In 1..tab_punch_data.count
            Loop

                --tab_punch_data(i).str_wrk_hrs              := to_hrs(tab_punch_data(i).wrk_hrs);
                --tab_punch_data(i).str_delta_hrs            := to_hrs(tab_punch_data(i).delta_hrs);
                --tab_punch_data(i).str_extra_hrs            := to_hrs(tab_punch_data(i).extra_hrs);

                If tab_punch_data(i).is_absent = 1 Then
                    tab_punch_data(i).remarks := 'Absent';
                Elsif tab_punch_data(i).penalty_hrs > 0 Then
                    If tab_punch_data(i).day_punch_count = 1 Then
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '-HoursLeaveDeducted(MissedPunch)';
                    Else
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '-HoursLeaveDeducted';
                    End If;
                Elsif tab_punch_data(i).is_ldt = c_ldt_leave Then
                    tab_punch_data(i).remarks := 'OnLeave';
                Elsif tab_punch_data(i).is_ldt = c_ldt_tour_depu Then
                    tab_punch_data(i).remarks := 'OnTour-Depu';
                Elsif tab_punch_data(i).is_ldt = c_ldt_remote_work Then
                    tab_punch_data(i).remarks := 'RemoteWork';
                Elsif tab_punch_data(i).day_punch_count = 1 Then
                    tab_punch_data(i).remarks := 'MissedPunch';
                End If;
                If tab_punch_data(i).is_lwd = 1 And tab_punch_data(i).is_sleave_app = 1 And tab_punch_data(i).sl_app_cntr < 3
                Then
                    v_is_fri_lcome_ego_app := 1;
                Else
                    v_is_fri_lcome_ego_app := 0;
                End If;

                If i = 7 Then
                    tab_punch_data(i).wk_bfwd_delta_hrs := v_prev_lwrk_day_cfwd_delta_hrs;
                    calculate_weekly_cfwd_hrs(
                        p_wk_bfwd_dhrs   => tab_punch_data(i).wk_bfwd_delta_hrs,
                        p_wk_dhrs        => tab_punch_data(i).wk_sum_delta_hrs,
                        p_lday_lcome_ego => tab_punch_data(i).last_day_cfwd_dhrs,
                        p_fri_sl_app     => v_is_fri_lcome_ego_app,
                        p_cfwd_dhrs      => tab_punch_data(i).wk_cfwd_delta_hrs,
                        p_pn_hrs         => tab_punch_data(i).wk_penalty_leave_hrs
                    );
                    v_prev_lwrk_day_cfwd_delta_hrs      := tab_punch_data(i).wk_cfwd_delta_hrs;
                End If;

                --tab_punch_data(i).str_wk_sum_work_hrs      := to_hrs(tab_punch_data(i).wk_sum_work_hrs);
                --tab_punch_data(i).str_wk_sum_delta_hrs     := to_hrs(tab_punch_data(i).wk_sum_delta_hrs);
                --tab_punch_data(i).str_wk_bfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_bfwd_delta_hrs);
                --tab_punch_data(i).str_wk_cfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_cfwd_delta_hrs);
                --tab_punch_data(i).str_wk_penalty_leave_hrs := to_hrs(tab_punch_data(i).wk_penalty_leave_hrs);

            End Loop;
            tab_punch_data := Null;
            Exit When cur_for_punch_data%notfound;
        End Loop;
        Close cur_for_punch_data;
        Return;
    End;

End iot_punch_details;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_CONFIG_WEEK
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_CONFIG_WEEK" As
    c_plan_close_code  Constant Number := 0;
    c_plan_open_code   Constant Number := 1;
    c_past_plan_code   Constant Number := 0;
    c_cur_plan_code    Constant Number := 1;
    c_future_plan_code Constant Number := 2;

    Function fn_is_second_last_day_of_week(p_sysdate Date) Return Boolean As
        v_secondlast_workdate Date;
        v_fri_date            Date;
        Type rec Is Record(
                work_date     Date,
                work_day_desc Varchar2(100),
                rec_num       Number
            );

        Type typ_tab_work_day Is Table Of rec;
        tab_work_day          typ_tab_work_day;
    Begin
        v_fri_date := iot_swp_common.get_friday_date(trunc(p_sysdate));
        Select
            d_date As work_date,
            Case Rownum
                When 1 Then
                    'LAST'
                When 2 Then
                    'SECOND_LAST'
                Else
                    Null
            End    work_day_desc,
            Rownum As rec_num
        Bulk Collect
        Into
            tab_work_day
        From
            (
                Select
                    *
                From
                    ss_days_details
                Where
                    d_date <= v_fri_date
                    And d_date >= trunc(p_sysdate)
                    And d_date Not In
                    (
                        Select
                            trunc(holiday)
                        From
                            ss_holidays
                        Where
                            (holiday <= v_fri_date
                                And holiday >= trunc(p_sysdate))
                    )
                Order By d_date Desc
            )
        Where
            Rownum In(1, 2);
        If tab_work_day.count = 2 Then
            --v_sysdate EQUAL SECOND_LAST working day "THURSDAY"
            If p_sysdate = tab_work_day(2).work_date Then --SECOND_LAST working day
                Return true;
            End If;
        End If;
        Return false;
    Exception
        When Others Then
            Return false;
    End;

    Procedure sp_del_dms_desk_for_sws_users As
        Cursor cur_desk_plan_dept Is
            Select
                *
            From
                swp_include_assign_4_seat_plan;
        c1      Sys_Refcursor;

        --
        Cursor cur_sws Is
            Select
                a.empno,
                a.primary_workspace,
                a.start_date,
                iot_swp_common.get_swp_planned_desk(
                    p_empno => a.empno
                ) swp_desk_id
            From
                swp_primary_workspace a,
                ss_emplmast           e
            Where
                a.empno                 = e.empno
                And e.status            = 1
                And a.primary_workspace = 2
                And trunc(a.start_date) = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = a.empno
                        And b.start_date <= sysdate
                )
                And e.assign In (
                    Select
                        assign
                    From
                        swp_include_assign_4_seat_plan
                );
        Type typ_tab_sws Is Table Of cur_sws%rowtype Index By Binary_Integer;
        tab_sws typ_tab_sws;
    Begin
        Open cur_sws;
        Loop
            Fetch cur_sws Bulk Collect Into tab_sws Limit 50;
            For i In 1..tab_sws.count
            Loop
                iot_swp_dms.sp_remove_desk_user(
                    p_person_id => Null,
                    p_meta_id   => Null,
                    p_empno     => tab_sws(i).empno,
                    p_deskid    => tab_sws(i).swp_desk_id
                );
            End Loop;
            Exit When cur_sws%notfound;
        End Loop;
    End;

    --

    Procedure sp_mail_plan_to_emp
    As
        cur_dept_rows      Sys_Refcursor;
        cur_emp_week_plan  Sys_Refcursor;
        row_config_week    swp_config_weeks%rowtype;
        v_mail_body        Varchar2(4000);
        v_day_row          Varchar2(1000);
        v_emp_mail         Varchar2(100);
        v_msg_type         Varchar2(15);
        v_msg_text         Varchar2(1000);
        v_emp_desk         Varchar2(10);
        Cursor cur_sws_emp_list(cp_monday_date Date,
                                cp_friday_date Date) Is
            Select
                a.empno,
                e.name As employee_name,
                a.primary_workspace,
                a.start_date
            From
                swp_primary_workspace a,
                ss_emplmast           e
            Where
                e.status                = 1
                And a.empno             = e.empno
                And a.primary_workspace = 2
                And emptype In (
                    Select
                        emptype
                    From
                        swp_include_emptype
                )
                And assign Not In(
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
                And trunc(a.start_date) = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = a.empno
                        And b.start_date <= cp_friday_date
                )
                And e.empno Not In(
                    Select
                        empno
                    From
                        swp_exclude_emp
                    Where
                        empno = e.empno
                        And (cp_monday_date Between start_date And end_date
                            Or cp_friday_date Between start_date And end_date)
                )
                And grade <> 'X1';

        Type typ_tab_sws_emp_list Is Table Of cur_sws_emp_list%rowtype;
        tab_sws_emp_list   typ_tab_sws_emp_list;

        Cursor cur_emp_smart_attend_plan(cp_empno      Varchar2,
                                         cp_start_date Date,
                                         cp_end_date   Date) Is
            With
                atnd_days As (
                    Select
                        w.empno,
                        Trim(w.attendance_date) As attendance_date,
                        Trim(w.deskid)          As deskid,
                        1                       As planned,
                        dm.office               As office,
                        dm.floor                As floor,
                        dm.wing                 As wing,
                        dm.bay                  As bay
                    From
                        swp_smart_attendance_plan w,
                        dms.dm_deskmaster         dm
                    Where
                        w.empno      = cp_empno
                        And w.deskid = dm.deskid(+)
                        And attendance_date Between cp_start_date And cp_end_date
                )
            Select
                e.empno                   As empno,
                dd.d_day,
                dd.d_date,
                nvl(atnd_days.planned, 0) As planned,
                atnd_days.deskid          As deskid,
                atnd_days.office          As office,
                atnd_days.floor           As floor,
                atnd_days.wing            As wing,
                atnd_days.bay             As bay
            From
                ss_emplmast     e,
                ss_days_details dd,
                atnd_days
            Where
                e.empno       = Trim(cp_empno)

                And dd.d_date = atnd_days.attendance_date
                And d_date Between cp_start_date And cp_end_date
            Order By
                dd.d_date;
        Type typ_tab_emp_smart_plan Is Table Of cur_emp_smart_attend_plan%rowtype;
        tab_emp_smart_plan typ_tab_emp_smart_plan;
    Begin

        Select
            *
        Into
            row_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;

        Open cur_sws_emp_list(row_config_week.start_date, row_config_week.end_date);
        Loop
            Fetch cur_sws_emp_list Bulk Collect Into tab_sws_emp_list Limit 50;
            For i In 1..tab_sws_emp_list.count
            Loop
                Begin
                    Select
                        email
                    Into
                        v_emp_mail
                    From
                        ss_emplmast
                    Where
                        empno      = tab_sws_emp_list(i).empno
                        And status = 1;
                    If v_emp_mail Is Null Then
                        Continue;
                    End If;
                Exception
                    When Others Then
                        Continue;
                End;


                --PRIMARY WORK SPACE
                If tab_sws_emp_list(i).primary_workspace = 1 Then
                    v_mail_body := v_ows_mail_body;
                    v_mail_body := replace(v_mail_body, '!@User@!', tab_sws_emp_list(i).employee_name);
                    v_mail_body := replace(v_mail_body, '!@StartDate@!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
                    v_mail_body := replace(v_mail_body, '!@EndDate@!', to_char(row_config_week.end_date, 'dd-Mon-yyyy'));

                    /*
                    v_emp_desk := get_swp_planned_desk(
                            p_empno => emp_row.empno
                    );
                    */
                    --SMART WORK SPACE
                Elsif tab_sws_emp_list(i).primary_workspace = 2 Then
                    If cur_emp_smart_attend_plan%isopen Then
                        Close cur_emp_smart_attend_plan;
                    End If;
                    Open cur_emp_smart_attend_plan(tab_sws_emp_list(i).empno, row_config_week.start_date, row_config_week.
                    end_date);
                    Fetch cur_emp_smart_attend_plan Bulk Collect Into tab_emp_smart_plan Limit 5;
                    For i In 1..tab_emp_smart_plan.count
                    Loop

                        v_day_row := nvl(v_day_row, '') || v_sws_empty_day_row;
                        v_day_row := replace(v_day_row, 'DESKID', tab_emp_smart_plan(i).deskid);
                        v_day_row := replace(v_day_row, 'DATE', tab_emp_smart_plan(i).d_date);
                        v_day_row := replace(v_day_row, 'DAY', tab_emp_smart_plan(i).d_day);
                        v_day_row := replace(v_day_row, 'OFFICE', tab_emp_smart_plan(i).office);
                        v_day_row := replace(v_day_row, 'FLOOR', tab_emp_smart_plan(i).floor);
                        v_day_row := replace(v_day_row, 'WING', tab_emp_smart_plan(i).wing);

                    End Loop;

                    If v_day_row = v_sws_empty_day_row Or v_day_row Is Null Then
                        Continue;
                    End If;
                    v_mail_body := v_sws_mail_body;
                    v_mail_body := replace(v_mail_body, '!@StartDate@!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
                    v_mail_body := replace(v_mail_body, '!@EndDate@!', to_char(row_config_week.end_date, 'dd-Mon-yyyy'));
                    v_mail_body := replace(v_mail_body, '!@User@!', tab_sws_emp_list(i).employee_name);
                    v_mail_body := replace(v_mail_body, '!@WEEKLYPLANNING@!', v_day_row);

                End If;
                tcmpl_app_config.pkg_app_mail_queue.sp_add_to_hold_queue(
                    p_person_id    => Null,
                    p_meta_id      => Null,
                    p_mail_to      => v_emp_mail,
                    p_mail_cc      => Null,
                    p_mail_bcc     => Null,
                    p_mail_subject => 'SWP : Attendance schedule for Smart Workspace',
                    p_mail_body1   => v_mail_body,
                    p_mail_body2   => Null,
                    p_mail_type    => 'HTML',
                    p_mail_from    => 'SELFSERVICE',
                    p_message_type => v_msg_type,
                    p_message_text => v_msg_text
                );
                Commit;
                v_day_row   := Null;
                v_mail_body := Null;
                v_msg_type  := Null;
                v_msg_text  := Null;
            End Loop;
            Exit When cur_sws_emp_list%notfound;

        End Loop;

    End;
    --
    Procedure sp_add_new_joinees_to_pws
    As
    Begin
        Insert Into swp_primary_workspace (key_id, empno, primary_workspace, start_date, modified_on, modified_by, active_code,
            assign_code)
        Select
            dbms_random.string('X', 10),
            empno,
            Case
                When dd.assign = Null Then
                    1
                Else
                    2
            End pws,
            greatest(doj, to_date('31-Jan-2022')),
            sysdate,
            'Sys',
            2,
            e.assign
        From
            ss_emplmast                e,
            swp_deputation_departments dd
        Where
            e.status     = 1
            And e.assign = dd.assign(+)
            And emptype In (
                Select
                    emptype
                From
                    swp_include_emptype
            )
            And e.assign Not In (
                Select
                    assign
                From
                    swp_exclude_assign
            )
            And empno Not In (
                Select
                    empno
                From
                    swp_primary_workspace
            );
    End sp_add_new_joinees_to_pws;

    Procedure init_configuration(p_sysdate Date) As
        v_cur_week_mon        Date;
        v_cur_week_fri        Date;
        v_next_week_key_id    Varchar2(8);
        v_current_week_key_id Varchar2(8);
        v_count               Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            swp_config_weeks;
        If v_count > 0 Then
            Return;
        End If;
        v_cur_week_mon        := iot_swp_common.get_monday_date(p_sysdate);
        v_cur_week_fri        := iot_swp_common.get_friday_date(p_sysdate);
        v_current_week_key_id := dbms_random.string('X', 8);
        --Insert New Plan dates
        Insert Into swp_config_weeks(
            key_id,
            start_date,
            end_date,
            planning_flag,
            pws_open,
            ows_open,
            sws_open
        )
        Values(
            v_current_week_key_id,
            v_cur_week_mon,
            v_cur_week_fri,
            c_cur_plan_code,
            c_plan_close_code,
            c_plan_close_code,
            c_plan_close_code
        );

    End;

    --
    Procedure close_planning As
        b_update_planning_flag Boolean := false;
    Begin
        Update
            swp_config_weeks
        Set
            pws_open = c_plan_close_code,
            ows_open = c_plan_close_code,
            sws_open = c_plan_close_code
        Where
            pws_open    = c_plan_open_code
            Or ows_open = c_plan_open_code
            Or sws_open = c_plan_open_code;
        If b_update_planning_flag Then
            Update
                swp_config_weeks
            Set
                planning_flag = c_past_plan_code
            Where
                planning_flag = c_cur_plan_code;

            Update
                swp_config_weeks
            Set
                planning_flag = c_cur_plan_code
            Where
                planning_flag = c_future_plan_code;

        End If;
    End close_planning;
    --

    Procedure do_dms_data_to_plan(p_week_key_id Varchar2) As
    Begin
        Delete
            From dms.dm_usermaster_swp_plan;
        Delete
            From dms.dm_deskallocation_swp_plan;
        Delete
            From dms.dm_desklock_swp_plan;
        Commit;

        Insert Into dms.dm_usermaster_swp_plan(
            fk_week_key_id,
            empno,
            deskid,
            costcode,
            dep_flag
        )
        Select
            p_week_key_id,
            empno,
            deskid,
            costcode,
            dep_flag
        From
            dms.dm_usermaster;

        Insert Into dms.dm_deskallocation_swp_plan(
            fk_week_key_id,
            deskid,
            assetid
        )
        Select
            p_week_key_id,
            deskid,
            assetid
        From
            dms.dm_deskallocation;

        Insert Into dms.dm_desklock_swp_plan(
            fk_week_key_id,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        )
        Select
            p_week_key_id,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        From
            dms.dm_desklock;
    End;

    Procedure do_dms_snapshot(p_sysdate Date) As

    Begin
        Delete
            From dms.dm_deskallocation_snapshot;

        Insert Into dms.dm_deskallocation_snapshot(
            snapshot_date,
            deskid,
            assetid
        )
        Select
            p_sysdate,
            deskid,
            assetid
        From
            dms.dm_deskallocation;

        Delete
            From dms.dm_usermaster_snapshot;

        Insert Into dms.dm_usermaster_snapshot(
            snapshot_date,
            empno,
            deskid,
            costcode,
            dep_flag
        )
        Select
            p_sysdate,
            empno,
            deskid,
            costcode,
            dep_flag
        From
            dms.dm_usermaster;

        Delete
            From dms.dm_desklock_snapshot;

        Insert Into dms.dm_desklock_snapshot(
            snapshot_date,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        )
        Select
            p_sysdate,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        From
            dms.dm_desklock;

        Commit;

    End;
    --
    Procedure toggle_plan_future_to_curr(
        p_sysdate Date
    ) As
        rec_config_week swp_config_weeks%rowtype;
        v_sysdate       Date;
    Begin
        v_sysdate := trunc(p_sysdate);

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            key_id In (
                Select
                    key_id
                From
                    (
                        Select
                            key_id
                        From
                            swp_config_weeks
                        Order By start_date Desc
                    )
                Where
                    Rownum = 1
            );

        If rec_config_week.start_date != v_sysdate Then
            Return;
        End If;
        --Close Planning
        close_planning;

        --toggle CURRENT to PAST
        Update
            swp_config_weeks
        Set
            planning_flag = c_past_plan_code
        Where
            planning_flag = c_cur_plan_code;

        --toggle FUTURE to CURRENT 
        Update
            swp_config_weeks
        Set
            planning_flag = c_cur_plan_code
        Where
            planning_flag = c_future_plan_code;

        --Toggle WorkSpace planning FUTURE to CURRENT
        Update
            swp_primary_workspace
        Set
            active_code = c_past_plan_code
        Where
            active_code = c_cur_plan_code
            And empno In (
                Select
                    empno
                From
                    swp_primary_workspace
                Where
                    active_code = c_future_plan_code
            );

        Update
            swp_primary_workspace
        Set
            active_code = c_cur_plan_code
        Where
            active_code = c_future_plan_code;

    End toggle_plan_future_to_curr;
    --
    Procedure rollover_n_open_planning(p_sysdate Date) As
        v_next_week_mon    Date;
        v_next_week_fri    Date;
        v_next_week_key_id Varchar2(8);

        rec_config_week    swp_config_weeks%rowtype;
    Begin
        --Close and toggle existing planning
        toggle_plan_future_to_curr(p_sysdate);

        v_next_week_mon    := iot_swp_common.get_monday_date(p_sysdate + 6);
        v_next_week_fri    := iot_swp_common.get_friday_date(p_sysdate + 6);
        v_next_week_key_id := dbms_random.string('X', 8);
        --Insert New Plan dates
        Insert Into swp_config_weeks(
            key_id,
            start_date,
            end_date,
            planning_flag,
            pws_open,
            ows_open,
            sws_open
        )
        Values(
            v_next_week_key_id,
            v_next_week_mon,
            v_next_week_fri,
            c_future_plan_code,
            c_plan_close_code,
            c_plan_close_code,
            c_plan_close_code
        );

        --Get current week key id
        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            key_id In (
                Select
                    key_id
                From
                    (
                        Select
                            key_id
                        From
                            swp_config_weeks
                        Where
                            key_id <> v_next_week_key_id
                        Order By start_date Desc
                    )
                Where
                    Rownum = 1
            );

        Insert Into swp_smart_attendance_plan(
            key_id,
            ws_key_id,
            empno,
            attendance_date,
            modified_on,
            modified_by,
            deskid,
            week_key_id
        )
        Select
            dbms_random.string('X', 10),
            a.ws_key_id,
            a.empno,
            trunc(a.attendance_date) + 7,
            p_sysdate,
            'Sys',
            a.deskid,
            v_next_week_key_id
        From
            swp_smart_attendance_plan a
        Where
            week_key_id = rec_config_week.key_id;

        --
        --do snapshot of DESK+USER & DESK+ASSET & Also DESKLOCK mapping
        do_dms_snapshot(trunc(p_sysdate));
        ---

        do_dms_data_to_plan(v_next_week_key_id);
    End rollover_n_open_planning;

    --
    Procedure sp_configuration Is
        v_secondlast_workdate Date;
        v_sysdate             Date;
        v_fri_date            Date;
        v_is_second_last_day  Boolean;
        Type rec Is Record(
                work_date     Date,
                work_day_desc Varchar2(100),
                rec_num       Number
            );

        Type typ_tab_work_day Is Table Of rec;
        tab_work_day          typ_tab_work_day;
    Begin
        sp_add_new_joinees_to_pws;
        v_sysdate            := trunc(sysdate);
        v_fri_date           := iot_swp_common.get_friday_date(trunc(v_sysdate));
        --
        init_configuration(v_sysdate);

        v_is_second_last_day := fn_is_second_last_day_of_week(v_sysdate);

        If v_is_second_last_day Then --SECOND_LAST working day (THURSDAY)
            rollover_n_open_planning(v_sysdate);
            --v_sysdate EQUAL LAST working day "FRIDAY"
            --        ElsIf V_SYSDATE = tab_work_day(1).work_date Then --LAST working day
        Elsif v_sysdate = v_fri_date Then
            close_planning;
        Elsif to_char(v_sysdate, 'Dy') = 'Mon' Then
            toggle_plan_future_to_curr(v_sysdate);
        Else
            Null;
            --ToBeDecided
        End If;
    End sp_configuration;

End iot_swp_config_week;
/
---------------------------
--New FUNCTION
--N_OTPERIOD_INLCUDE_2ND_SHIFT
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_OTPERIOD_INLCUDE_2ND_SHIFT" (
    p_empno       In Varchar2,
    p_date       In Date,
    p_shift_code  In Varchar2,
    p_delta_hrs   In Number,
    p_compoff_hrs In Number Default 0
) Return Number Is

    v_ret_ot_hrs       Number;

    Type typ_tab_hrs Is
        Table Of Number Index By Binary_Integer;
    v_tab_hrs           typ_tab_hrs;
    cntr               Number;
    thrs               Varchar2(10);
    v_shift_out_time   Number;
    v_shift_in_time    Number;
    v_is_ot_applicable Number;
    v_punchnos         Number;
    vtrno              Char(5);
    v4ot               Boolean := true;
    v_is_train_ot      Number;

    v_ot_start_time    Number;
    v_ot_end_time      Number;

    v_from_hrs         Number;
    v_to_hrs           Number;
Begin
    If p_shift_code = 'TN' Or p_shift_code = 'PA' Or p_shift_code = 'GE' Or p_shift_code = 'GV' Then
        Return 0;
    End If;

    Select
        Count(*)
    Into
        v_is_ot_applicable
    From
        ss_shiftmast
    Where
        shiftcode                 = Trim(p_shift_code)
        And nvl(ot_applicable, 0) = 1;

    If trunc(p_date) In (
            trunc(To_Date('21-FEB-2017', 'dd-MON-yyyy')),
            trunc(To_Date('28-SEP-2017', 'dd-MON-yyyy'))
        )
    Then
        Return 0;
    End If;

    If v_is_ot_applicable = 0 And trim(p_shift_code) <> 'HH' And trim(p_shift_code) <> 'OO' Then
        Return 0;
    End If;

    --Training

    v_is_train_ot    := n_ot_4_training(p_empno, p_date);
    If v_is_train_ot = ss.ss_false Then
        Return 0;
    End If;
    --Training

    If p_date < To_Date('', '') Then
        Return n_otperiod(
            p_empno,
            p_date,
            p_shift_code,
            p_delta_hrs,
            p_compoff_hrs
        );
    End If;

    v_ret_ot_hrs     := 0;

    Select
        ((hh * 60) + mm) mins Bulk Collect
    Into
        v_tab_hrs
    From
        ss_integratedpunch
    Where
        empno         = ltrim(rtrim(p_empno))
        And pdate     = p_date
        And falseflag = 1
        And Trim(mach) <> 'WFH0'
    Order By
        pdate,
        hhsort,
        mmsort,
        hh,
        mm;
    If (v_tab_hrs.count Mod 2) <> 0 Then
        Return 0;
    End If;

    v_shift_out_time := getshiftouttime(p_empno, p_date, p_shift_code, v4ot);

    v_shift_in_time  := getshiftintime(p_empno, p_date, p_shift_code);

    If v_shift_in_time > (12 * 60) Then
        v_ot_start_time := 0;
        v_ot_end_time   := v_shift_in_time;
    Else
        v_ot_start_time := v_shift_out_time;
        v_ot_end_time   := 0;
    End If;

    v_ret_ot_hrs     := 0;
    For i In 1..v_tab_hrs.count
    Loop
        If Mod(i, 2) = 0 Then
            If v_tab_hrs(i) < v_ot_start_time Then
                Continue;
            End If;
            If v_tab_hrs(i - 1) > v_ot_end_time Then
                Exit;
            End If;

            v_from_hrs   := greatest(v_ot_start_time, v_tab_hrs(i - 1));

            v_to_hrs     := least(v_ot_end_time, v_tab_hrs(i));

            v_ret_ot_hrs := v_ret_ot_hrs + v_to_hrs - v_from_hrs;

        End If;
    End Loop;

    If p_shift_code <> 'OO' And p_shift_code <> 'HH' Then

        v_ret_ot_hrs := least(p_delta_hrs, v_ret_ot_hrs);

    Elsif p_shift_code = 'OO' Or p_shift_code = 'HH' Then

        v_ret_ot_hrs := v_ret_ot_hrs - availedlunchtime1(p_empno, p_date, p_shift_code);

    End If;

    If p_compoff_hrs = 1 Then
        If v_ret_ot_hrs >= 120 Then
            v_ret_ot_hrs := (floor(v_ret_ot_hrs / 60) * 60);
        Else
            v_ret_ot_hrs := 0;
        End If;
    Else
        If p_shift_code = 'OO' Or p_shift_code = 'HH' Then
            If v_ret_ot_hrs >= 240 Then
                v_ret_ot_hrs := (floor(v_ret_ot_hrs / 60) * 60);
            Else
                v_ret_ot_hrs := 0;
            End If;

        Else
            If v_ret_ot_hrs >= 120 Then
                v_ret_ot_hrs := 120;
            Else
                v_ret_ot_hrs := 0;
            End If;
        End If;
    End If;

    Return v_ret_ot_hrs;
End;
/
