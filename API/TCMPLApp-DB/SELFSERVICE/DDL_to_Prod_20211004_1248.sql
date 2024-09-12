--------------------------------------------------------
--  File created - Monday-October-04-2021   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--IOT_PUNCH_DETAILS
---------------------------
CREATE OR REPLACE PACKAGE "IOT_PUNCH_DETAILS" As

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
                issunday,
                islwd,
                islcapp,
                issleaveapp,
                is_absent,
                slappcntr,
                ego,
                wrkhrs,
                deltahrs,
                extra_hours,
                comp_off,
                last_day_cfwd_dhrs,
                Sum(wrkhrs) Over (Partition By wk_of_year),
                Sum(deltahrs) Over (Partition By wk_of_year),
                Sum(extra_hours) Over (Partition By wk_of_year),
                Sum(comp_off) Over (Partition By wk_of_year),
                wk_bfwd_delta_hrs,
                wk_cfwd_delta_hrs,
                wk_penalty_leave_hrs,
                day_punch_count,
                remarks,
                str_wrk_hrs,
                str_delta_hrs,
                str_extra_hrs,
                str_wk_sum_work_hrs,
                str_wk_sum_delta_hrs,
                str_wk_bfwd_delta_hrs,
                str_wk_cfwd_delta_hrs,
                str_wk_penalty_leave_hrs
            )
        From
            (
                Select
                    main_main_query.*,
                    n_otperiod(cp_empno, d_date, shiftcode, deltahrs)    As extra_hours,
                    n_otperiod(cp_empno, d_date, shiftcode, deltahrs, 1) As comp_off,
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
                    End                                                  As last_day_cfwd_dhrs

                From
                    (
                        Select
                            main_query.*, n_deltahrs(cp_empno, d_date, shiftcode, penaltyhrs) As deltahrs,
                                   case when day_punch_count > 1 then to_hrs(firstlastpunch1(cp_empno, d_date, 1)) else '' end               As last_punch
                        From
                            (
                                Select
                                    cp_empno                                                   As empno,
                                    d_dd                                                       As dd,
                                    d_day                                                      As ddd,
                                    wk_of_year,

                                    to_hrs(firstlastpunch1(cp_empno, d_date, 0))               As first_punch,


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
                                    )                                                          As penaltyhrs,
                                    is_odd_punch(cp_empno, d_date)                             As is_odd_punch,
                                    to_char(d_date, 'dd-Mon-yyyy')                             As mdate,
                                    d_dd                                                       As sday,
                                    d_date,
                                    getshift1(cp_empno, d_date)                                As shiftcode,
                                    isleavedeputour(d_date, cp_empno)                          As is_ldt,
                                    get_holiday(d_date)                                        As issunday,
                                    islastworkday1(cp_empno, d_date)                           As islwd,
                                    lc_appcount(cp_empno, d_date)                              As islcapp,
                                    issleaveapp(cp_empno, d_date)                              As issleaveapp,
                                    isabsent(cp_empno, d_date)                                 As is_absent,

                                    n_sum_slapp_count(cp_empno, d_date)                        As slappcntr,

                                    earlygo1(cp_empno, d_date)                                 As ego,
                                    n_workedhrs(cp_empno, d_date, getshift1(cp_empno, d_date)) As wrkhrs,

                                    0                                                          As wk_bfwd_delta_hrs,
                                    0                                                          As wk_cfwd_delta_hrs,
                                    0                                                          As wk_penalty_leave_hrs,
                                    punchcount(cp_empno, d_date)                               As day_punch_count,
                                    Null                                                       As remarks,
                                    ''                                                         As str_wrk_hrs,
                                    ''                                                         As str_delta_hrs,
                                    ''                                                         As str_extra_hrs,
                                    ''                                                         As str_wk_sum_work_hrs,
                                    ''                                                         As str_wk_sum_delta_hrs,
                                    ''                                                         As str_wk_bfwd_delta_hrs,
                                    ''                                                         As str_wk_cfwd_delta_hrs,
                                    ''                                                         As str_wk_penalty_leave_hrs 

                                --v_max_punch                                              tot_punch_nos

                                From
                                    ss_days_details
                                Where
                                    d_date Between cp_start_date And cp_end_date
                                Order By d_date
                            ) main_query
                    ) main_main_query
            );

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
        p_yyyymm    Varchar2
    ) Return typ_tab_punch_data
        Pipelined;

    Function fn_day_punch_list_4_self(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date
    ) Return typ_tab_day_punch_list
        Pipelined;

    /*
    Procedure punch_details_pipe(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_yyyymm    Varchar2
    );
    */
End iot_punch_details;
/
---------------------------
--Changed PACKAGE BODY
--IOT_PUNCH_DETAILS
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_PUNCH_DETAILS" As

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
        v_wk_negative_delta := p_wk_bfwd_dhrs + p_wk_dhrs;
        If v_wk_negative_delta >= 0 Then
            p_pn_hrs    := 0;
            p_cfwd_dhrs := 0;
        End If;
        If p_fri_sl_app <> 1 Then
            p_pn_hrs := ceil(v_wk_negative_delta / 60) * -1;
            If p_pn_hrs Between 4 And 8 Then
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
                p_pn_hrs := ceil((v_wk_negative_delta + (p_lday_lcome_ego * -1)) / 60) * -1;
                If p_pn_hrs Between 4 And 8 Then
                    p_pn_hrs := 8;
                End If;
                If p_pn_hrs * 60 > v_wk_negative_delta * -1 Then
                    p_cfwd_dhrs := 0;
                Else
                    p_cfwd_dhrs := v_wk_negative_delta + p_pn_hrs * 60;
                End If;
            End If;
        End If;
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
            v_empno      := get_empno_from_person_id(p_person_id);
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
        p_yyyymm    Varchar2
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
            v_empno := get_empno_from_person_id(p_person_id);
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
        v_end_date   := last_day(to_date(p_yyyymm, 'yyyymm'));
        v_start_date := n_getstartdate(to_char(v_end_date, 'mm'), to_char(v_end_date, 'yyyy'));

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

                tab_punch_data(i).str_wrk_hrs              := to_hrs(tab_punch_data(i).wrk_hrs);
                tab_punch_data(i).str_delta_hrs            := to_hrs(tab_punch_data(i).delta_hrs);
                tab_punch_data(i).str_extra_hrs            := to_hrs(tab_punch_data(i).extra_hrs);
                tab_punch_data(i).str_wk_sum_work_hrs      := to_hrs(tab_punch_data(i).wk_sum_work_hrs);
                tab_punch_data(i).str_wk_sum_delta_hrs     := to_hrs(tab_punch_data(i).wk_sum_delta_hrs);
                tab_punch_data(i).str_wk_bfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_bfwd_delta_hrs);
                tab_punch_data(i).str_wk_cfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_cfwd_delta_hrs);
                tab_punch_data(i).str_wk_penalty_leave_hrs := to_hrs(tab_punch_data(i).wk_penalty_leave_hrs);

                If tab_punch_data(i).is_absent = 1 Then
                    tab_punch_data(i).remarks := 'Absent';
                Elsif tab_punch_data(i).penalty_hrs > 0 Then
                    If tab_punch_data(i).day_punch_count = 1 Then
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '_Hrs_Lv_Dedu(MissedPunch)';
                    Else
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '_Hrs_Lv_Deducted';
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
                Pipe Row(tab_punch_data(i));
            End Loop;
            tab_punch_data := Null;
            Exit When cur_for_punch_data%notfound;
        End Loop;
        Close cur_for_punch_data;
        Return;
    End fn_punch_details_4_self;

    Function fn_day_punch_list_4_self(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date
    ) Return typ_tab_day_punch_list
        Pipelined
    Is
        tab_day_punch_list   typ_tab_day_punch_list;
        v_empno              Varchar2(5);

        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;

        Open cur_day_punch_list(v_empno, p_date);
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
    End fn_day_punch_list_4_self;

    /*
        Procedure punch_details_pipe(
            p_person_id Varchar2,
            p_meta_id   Varchar2,
            p_yyyymm    Varchar2
        )
        As
            --Type pls_typ_tab_punch_data Is Table Of cur_for_punch_data%rowtype;
            tab_punch_data       pls_typ_tab_punch_data;
            v_start_date         Date;
            v_end_date           Date;
            v_max_punch          Number;
            v_empno              Varchar2(5);
            e_employee_not_found Exception;
            Pragma exception_init(e_employee_not_found, -20001);
            v_cur_row            cur_for_punch_data%rowtype;
        Begin
            v_empno      := get_empno_from_person_id(p_person_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return;
            End If;
            v_end_date   := last_day(to_date(p_yyyymm, 'yyyymm'));
            v_start_date := n_getstartdate(to_char(v_end_date, 'mm'), to_char(v_end_date, 'yyyy'));

            v_max_punch  := n_maxpunch(v_empno, v_start_date, v_end_date);
            Open cur_for_punch_data(v_empno, v_start_date, v_end_date);
            Loop
                Fetch cur_for_punch_data Bulk Collect Into tab_punch_data Limit 7;
                For i In 1..tab_punch_data.count
                Loop
                    v_cur_row := tab_punch_data(i);
                End Loop;
                tab_punch_data := Null;
                Exit When cur_for_punch_data%notfound;
            End Loop;
            Close cur_for_punch_data;
            Return;
        End;
    */
End iot_punch_details;
/
