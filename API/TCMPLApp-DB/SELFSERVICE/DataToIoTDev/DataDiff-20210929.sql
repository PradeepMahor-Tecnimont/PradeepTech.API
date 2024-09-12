--------------------------------------------------------
--  File created - Wednesday-September-29-2021   
--------------------------------------------------------
---------------------------
--New TYPE
--TYP_ROW_PUNCH_DATA
---------------------------
CREATE OR REPLACE TYPE "TYP_ROW_PUNCH_DATA" As Object(
    empno                Char(5),
    dd                   Varchar2(2),
    ddd                  Varchar2(3),
    punch_date           Date,
    shift_code           Varchar2(2),
    wk_of_year           Varchar2(2),
    first_punch          Varchar2(10),
    last_punch           Varchar2(10),
    penalty_hrs          Number,
    is_odd_punch         Number,
    is_ldt               Number,
    is_sunday            Number,
    is_lwd               Number,
    is_lc_app            Number,
    is_sleave_app        Number,
    sl_app_cntr          Number,
    ego                  Number,
    wrk_hrs              Number,
    delta_hrs            Number,
    extra_hrs            Number,
    last_day_cfwd_dhrs   Number,
    wk_sum_work_hrs      Number,
    wk_sum_delta_hrs     Number,
    wk_bfwd_delta_hrs    Number,
    wk_cfwd_delta_hrs    Number,
    wk_penalty_leave_hrs Number,
    punch_count          Number,
    remarks              Varchar2(100)
);
/
---------------------------
--New TYPE
--TYP_TAB_PUNCH_DATA
---------------------------
CREATE OR REPLACE TYPE "TYP_TAB_PUNCH_DATA" Is Table Of typ_row_punch_data;
/
---------------------------
--Changed VIEW
--SS_ODAPPRL
---------------------------
CREATE OR REPLACE FORCE VIEW "SS_ODAPPRL" 
 ( "APP_NO", "EMPNO", "APP_DATE", "BDATE", "EDATE", "DESCRIPTION", "TYPE", "HOD_APPRL", "HOD_CODE", "HOD_APPRL_DT", "HRD_APPRL", "HRD_CODE", "HRD_APPRL_DT", "LEAD_APPRL", "LEAD_CODE", "LEAD_APPRL_EMPNO", "HH", "MM", "HH1", "MM1", "REASON", "FROMTAB", "HRDREASON", "HODREASON", "LEAD_REASON"
  )  AS 
  (SELECT app_no,
    empno,
    app_date,
    pdate bdate,
    to_date(NULL) edate,
    description,
    type,
    hod_apprl,
    hod_code,
    hod_apprl_dt,
    hrd_apprl,
    hrd_code,
    hrd_apprl_dt,
    lead_apprl,
    lead_code,
    lead_apprl_empno,
    hh,
    mm,
    hh1,
    mm1,
    Reason,
    4 FromTab,
    hrdreason,
    hodreason,
    lead_reason
  FROM ss_ondutyapp
  )
UNION
  (SELECT app_no,
    empno,
    app_date,
    bdate,
    edate,
    description,
    type,
    hod_apprl,
    hod_code,
    hod_apprl_dt,
    hrd_apprl,
    hrd_code,
    hrd_apprl_dt,
    lead_apprl,
    lead_code,
    lead_apprl_empno,
    to_number(NULL) hh,
    to_number(NULL) mm,
    to_number(NULL) hh1,
    to_number(NULL) mm1,
    Reason,
    3 FromTab,
    hrdreason,
    hodreason,
    lead_reason
    
  FROM ss_depu
  );
---------------------------
--New PACKAGE
--IOT_ONDUTY
---------------------------
CREATE OR REPLACE PACKAGE "IOT_ONDUTY" As

    Procedure sp_add_punch_entry_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_hh1              Varchar2,
        p_mi1              Varchar2,
        p_hh2              Varchar2 Default Null,
        p_mi2              Varchar2 Default Null,
        p_date             Date,
        p_type             Varchar2,
        p_sub_type         Varchar2 Default Null,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_add_punch_entry_4_other;

    Procedure sp_add_depu_tour_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_start_date       Date,
        p_end_date         Date,
        p_type             Varchar2,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_add_depu_tour_4_other;

    Procedure sp_delete_od_app_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_onduty_details_for_self(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_application_id      Varchar2,

        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,

        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    );

    Procedure sp_onduty_details_for_other(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_application_id      Varchar2,
        p_emp_no              Varchar2,
        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,

        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    );
End iot_onduty;
/
---------------------------
--New PACKAGE
--IOT_ONDUTY_QRY
---------------------------
CREATE OR REPLACE PACKAGE "IOT_ONDUTY_QRY" As


    Function fn_onduty_applications_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;


    Function fn_onduty_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_onduty_lead_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_onduty_hod_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_onduty_hr_approval(
            p_person_id   Varchar2,
            p_meta_id     Varchar2,
            p_row_number  Number,
            p_page_length Number
    ) Return Sys_Refcursor ;
        
End iot_onduty_qry;
/
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
                slappcntr,
                ego,
                wrkhrs,
                deltahrs,
                extra_hours,
                last_day_cfwd_dhrs,
                Sum(wrkhrs) Over (Partition By wk_of_year),
                Sum(deltahrs) Over (Partition By wk_of_year),
                0,
                0,
                0,
                0,
                null
            )
        From
            (
                Select
                    main_main_query.*,
                    n_otperiod(cp_empno, d_date, shiftcode, deltahrs) As extra_hours,
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
                    End                                               As last_day_cfwd_dhrs

                From
                    (
                        Select
                            main_query.*, n_deltahrs(cp_empno, d_date, shiftcode, penaltyhrs) As deltahrs
                        From
                            (
                                Select
                                    cp_empno                                                   As empno,
                                    d_dd                                                       As dd,
                                    d_day                                                      As ddd,
                                    wk_of_year,

                                    to_hrs(firstlastpunch1(cp_empno, d_date, 0))               As first_punch,

                                    to_hrs(firstlastpunch1(cp_empno, d_date, 1))               As last_punch,

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

                                    n_sum_slapp_count(cp_empno, d_date)                        As slappcntr,

                                    earlygo1(cp_empno, d_date)                                 As ego,
                                    n_workedhrs(cp_empno, d_date, getshift1(cp_empno, d_date)) As wrkhrs

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

    Function fn_punch_details_4_self(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_yyyymm    Varchar2
    ) Return Sys_Refcursor;

    Function fn_punch_details_pipe(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_yyyymm    Varchar2
    ) Return typ_tab_punch_data
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
--New PACKAGE BODY
--IOT_ONDUTY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_ONDUTY" As

    Procedure sp_onduty_details(
        p_empno               Varchar2,

        p_application_id      Varchar2,

        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,
        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As

        v_onduty_app ss_ondutyapp%rowtype;
        v_depu       ss_depu%rowtype;
        v_empno      Varchar2(5);
        v_count      Number;

    Begin
        v_empno        := p_empno;
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id)
            And empno    = v_empno;
        If v_count = 1 Then
            Select
                *
            Into
                v_onduty_app
            From
                ss_ondutyapp
            Where
                Trim(app_no) = Trim(p_application_id);
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_depu
            Where
                Trim(app_no) = Trim(p_application_id)
                And empno    = v_empno;
            If v_count = 1 Then
                Select
                    *
                Into
                    v_depu
                From
                    ss_depu
                Where
                    Trim(app_no) = Trim(p_application_id);
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        p_emp_name     := get_emp_name(v_empno);
        If v_onduty_app.empno Is Not Null Then
            Select
                description
            Into
                p_onduty_type
            From
                ss_ondutymast
            Where
                type = v_onduty_app.type;
            p_onduty_type   := v_onduty_app.type || ' - ' || p_onduty_type;
            If nvl(v_onduty_app.odtype, 0) <> 0 Then
                Select
                    description
                Into
                    p_onduty_type
                From
                    ss_onduty_sub_type
                Where
                    od_sub_type = v_onduty_app.odtype;
                p_onduty_sub_type := v_onduty_app.odtype || ' - ' || p_onduty_sub_type;
            End If;

            p_start_date    := to_char(v_onduty_app.pdate, 'dd-Mon-yyyy');
            p_hh1           := lpad(v_onduty_app.hh, 2, '0');
            p_mi1           := lpad(v_onduty_app.mm, 2, '0');
            p_hh2           := lpad(v_onduty_app.hh1, 2, '0');
            p_mi2           := lpad(v_onduty_app.mm1, 2, '0');
            p_reason        := v_onduty_app.reason;

            p_lead_name     := get_emp_name(v_onduty_app.lead_apprl_empno);
            p_lead_approval := ss.approval_text(v_onduty_app.lead_apprl);
            p_hod_approval  := ss.approval_text(v_onduty_app.hod_apprl);
            p_hr_approval   := ss.approval_text(v_onduty_app.hrd_apprl);

        Elsif v_depu.empno Is Not Null Then

            p_start_date    := to_char(v_depu.bdate, 'dd-Mon-yyyy');
            p_end_date      := to_char(v_depu.edate, 'dd-Mon-yyyy');
            p_reason        := v_depu.reason;

            Select
                description
            Into
                p_onduty_type
            From
                ss_ondutymast
            Where
                type = v_onduty_app.type;
            p_onduty_type   := v_onduty_app.type || ' - ' || p_onduty_type;

            p_lead_name     := get_emp_name(v_depu.lead_apprl_empno);

            p_lead_approval := ss.approval_text(v_depu.lead_apprl);
            p_hod_approval  := ss.approval_text(v_depu.hod_apprl);
            p_hr_approval   := ss.approval_text(v_depu.hrd_apprl);

        End If;

        p_message_type := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_add_punch_entry_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_hh1              Varchar2,
        p_mi1              Varchar2,
        p_hh2              Varchar2 Default Null,
        p_mi2              Varchar2 Default Null,
        p_date             Date,
        p_type             Varchar2,
        p_sub_type         Varchar2 Default Null,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno         Varchar2(5);
        v_count         Number;
        v_lead_approval Number := 0;
        v_hod_approval  Number := 0;
        v_desc          Varchar2(60);
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        od.add_onduty_type_1(
            p_empno         => v_empno,
            p_od_type       => p_type,
            p_od_sub_type   => nvl(Trim(p_sub_type), 0),
            p_pdate         => to_char(p_date, 'yyyymmdd'),
            p_hh            => to_number(Trim(p_hh1)),
            p_mi            => to_number(Trim(p_mi1)),
            p_hh1           => to_number(Trim(p_hh2)),
            p_mi1           => to_number(Trim(p_mi2)),
            p_lead_approver => p_lead_approver,
            p_reason        => p_reason,
            p_entry_by      => v_empno,
            p_user_ip       => Null,
            p_success       => p_message_type,
            p_message       => p_message_text
        );

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_punch_entry_4_self;

    Procedure sp_add_punch_entry_4_other As
    Begin
        -- TODO: Implementation required for Procedure IOT_ONDUTY.sp_add_punch_entry_4_other
        Null;
    End sp_add_punch_entry_4_other;

    Procedure sp_add_depu_tour_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_start_date       Date,
        p_end_date         Date,
        p_type             Varchar2,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_count Number;

    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        od.add_onduty_type_2(
            p_empno         => v_empno,
            p_od_type       => p_type,
            p_b_yyyymmdd    => to_char(p_start_date, 'yyyymmdd'),
            p_e_yyyymmdd    => to_char(p_end_date, 'yyyymmdd'),
            p_entry_by      => v_empno,
            p_lead_approver => p_lead_approver,
            p_user_ip       => Null,
            p_reason        => p_reason,
            p_success       => p_message_type,
            p_message       => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_depu_tour_4_self;

    Procedure sp_add_depu_tour_4_other As
    Begin
        -- TODO: Implementation required for Procedure IOT_ONDUTY.sp_add_depu_tour_4_other
        Null;
    End sp_add_depu_tour_4_other;

    Procedure sp_delete_od_app_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count    Number;
        v_empno    Varchar2(5);
        v_tab_from Varchar2(2);
    Begin
        v_count        := 0;
        v_empno        := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id)
            And empno    = v_empno;
        If v_count = 1 Then
            v_tab_from := 'OD';
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_depu
            Where
                Trim(app_no) = Trim(p_application_id)
                And empno    = v_empno;
            If v_count = 1 Then
                v_tab_from := 'DP';
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        del_od_app(p_app_no   => p_application_id,
                   p_tab_from => v_tab_from);
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_od_app_4_self;

    Procedure sp_onduty_details_for_self(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_application_id      Varchar2,

        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,

        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_count    Number;
        v_empno    Varchar2(5);
        v_tab_from Varchar2(2);
    Begin
        v_count := 0;
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sp_onduty_details(
            p_empno           => v_empno,

            p_application_id  => p_application_id,

            p_emp_name        => p_emp_name,

            p_onduty_type     => p_onduty_type,
            p_onduty_sub_type => p_onduty_sub_type,
            p_start_date      => p_start_date,
            p_end_date        => p_end_date,

            p_hh1             => p_hh1,
            p_mi1             => p_mi1,
            p_hh2             => p_hh2,
            p_mi2             => p_mi2,

            p_reason          => p_reason,

            p_lead_name       => p_lead_name,
            p_lead_approval   => p_lead_approval,
            p_hod_approval    => p_hod_approval,
            p_hr_approval     => p_hr_approval,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text

        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_onduty_details_for_other(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_application_id      Varchar2,
        p_emp_no              Varchar2,
        
        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,

        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
    Begin
        Null;
    End;

End iot_onduty;
/
---------------------------
--New PACKAGE BODY
--IOT_ONDUTY_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_ONDUTY_QRY" As

    Function fn_get_onduty_applications(
        p_empno       Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        a.pdate                                 As application_for_date,
                        description,
                        a.type                                  As onduty_type,
                        get_emp_name(a.lead_apprl_empno)        As lead_name,
                        a.lead_apprldesc                        As lead_approval,
                        hod_apprldesc                           As hod_approval,
                        hrd_apprldesc                           As hr_approval,
                        a.can_delete_app                        As can_delete_app,
                        Row_Number() Over (Order By a.app_date) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_odappstat a
                    Where
                        a.empno = p_empno
                        And a.pdate >= add_months(sysdate, - 24)
                    Order By app_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;

  Function fn_get_onduty_lead_approval(
        p_empno       Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
         v_empno varchar2(5):='01296';
    Begin
        Open c For
            Select
                *
            From
                (
					Select			
						to_char(a.app_date, 'dd-Mon-yyyy')			As application_date ,
						a.app_no							        As application_id,								
						to_char(bdate, 'dd-Mon-yyyy')				As start_date ,
						to_char(edate, 'dd-Mon-yyyy')				As end_date ,
						type			                            As onduty_type ,    
						dm_get_emp_office(a.empno) 		            As office,
						a.empno ||' - '|| name						As emp_name,
                        a.empno                 					As emp_no,
						parent										As parent,
						getempname(lead_apprl_empno)				As lead_name,
                        lead_reason                                 As lead_remarks,
						Row_Number() Over (Order By a.app_date) 	As row_number,
						Count(*) Over ()                        	As total_row
					From
						ss_odapprl a,
						ss_emplmast e
					Where                        
                            ( nvl(lead_apprl, 0) = 0 )
                        And ( nvl(hrd_apprl, 0) = 0 )
                        And ( nvl(hod_apprl, 0) = 0 )
                        And a.empno = e.empno
                        And a.empno In ( Select empno From ss_emplmast Where lead_apprl_empno = Trim(v_empno) )
                    Order By parent, a.empno
                    )
						Where
							row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;

  Function fn_get_onduty_hod_approval(
        p_empno       Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
        v_empno varchar2(5):='02346';
    Begin
    
        Open c For
            Select
                *
            From
                (
					Select			
						to_char(a.app_date, 'dd-Mon-yyyy')			As application_date ,
						a.app_no							        As application_id,								
						to_char(bdate, 'dd-Mon-yyyy')				As start_date ,
						to_char(edate, 'dd-Mon-yyyy')				As end_date ,
						type			                            As onduty_type ,    
						dm_get_emp_office(a.empno) 		            As office,
						a.empno ||' - '|| name						As emp_name,
                        a.empno                 					As emp_no,
						parent										As parent,
						getempname(lead_apprl_empno)				As lead_name,
                        hodreason                                   As hod_remarks,
						Row_Number() Over (Order By a.app_date) 	As row_number,
						Count(*) Over ()                        	As total_row
					From
						ss_odapprl a,
						ss_emplmast e
					Where
                            ( nvl(lead_apprl, 0) In ( 1, 4 ) )
                        And ( nvl(hrd_apprl, 0) = 0 ) 
                        And ( nvl(hod_apprl, 0) = 0 )    
                        And a.empno = e.empno
                        And a.empno In ( Select empno From ss_emplmast Where mngr = Trim(v_empno) )
                        Order By parent, a.empno
                    )
						Where
							row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End;

    Function fn_get_onduty_hr_approval(
        p_empno       Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
					Select			
						to_char(a.app_date, 'dd-Mon-yyyy')			As application_date ,
						a.app_no							        As application_id,								
						to_char(bdate, 'dd-Mon-yyyy')				As start_date ,
						to_char(edate, 'dd-Mon-yyyy')				As end_date ,
						type			                            As onduty_type ,    
						dm_get_emp_office(a.empno) 		            As office,
						a.empno ||' - '|| name						As emp_name,
                        a.empno                 					As emp_no,
						parent										As parent,
						getempname(lead_apprl_empno)				As lead_name,
                        HRDREASON                                   As hr_remarks,
						Row_Number() Over (Order By a.app_date) 	As row_number,
						Count(*) Over ()                        	As total_row
					From
						ss_odapprl a,
						ss_emplmast
					Where
						( nvl(hod_apprl, 0) = 1 )
						And a.empno = ss_emplmast.empno
						And ( nvl(hrd_apprl, 0) = 0 )
						 Order By app_date Desc						
				)
						Where
							row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;


    Function fn_onduty_applications_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        Select
            empno
        Into
            v_empno
        From
            ss_emplmast
        Where
            empno      = p_empno
            And status = 1;
        c := fn_get_onduty_applications(v_empno, p_row_number, p_page_length);
        Return c;
    End fn_onduty_applications_4_other;

    Function fn_onduty_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        c       := fn_get_onduty_applications(v_empno, p_row_number, p_page_length);
        Return c;

    End fn_onduty_applications_4_self;

    Function fn_onduty_lead_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        
        c := fn_get_onduty_lead_approval(v_empno, p_row_number, p_page_length);
        Return c;
    End fn_onduty_lead_approval;

    Function fn_onduty_hod_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        
        c := fn_get_onduty_hod_approval(v_empno, p_row_number, p_page_length);
        Return c;
    End fn_onduty_hod_approval;

    Function fn_onduty_hr_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        
        c := fn_get_onduty_hr_approval(v_empno, p_row_number, p_page_length);
        Return c;
    End fn_onduty_hr_approval;

End iot_onduty_qry;
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

    Function fn_punch_details_pipe(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
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
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno      := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
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
                tab_punch_data(i).remarks := 'REM';
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
    End;
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
