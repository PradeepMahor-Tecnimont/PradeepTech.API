--------------------------------------------------------
--  File created - Saturday-October-23-2021   
--------------------------------------------------------
---------------------------
--Changed VIEW
--SS_HA_APP_STAT
---------------------------
CREATE OR REPLACE FORCE VIEW "SS_HA_APP_STAT" 
 ( "EMPNO", "PDATE", "APP_NO", "APP_DATE", "DESCRIPTION", "LEAD_APPRLDESC", "HOD_APPRLDESC", "HRD_APPRLDESC", "LEAD_APPRL_EMPNO", "LEAD_REASON", "HODREASON", "HRDREASON", "HOD_APPRL", "HRD_APPRL", "FROMTAB"
  )  AS 
  SELECT empno,
    TO_CHAR(PDate,'dd-Mon-yyyy')PDate,
    app_No,
    app_date,
    description,
    DECODE(Lead_apprl, 0,'Pending',1,'Apprd',2,'DisApprd',4,'NA') Lead_ApprlDesc,
    DECODE(Hod_apprl, 0,'Pending',1,'Apprd',2,'DisApprd') Hod_ApprlDesc,
    DECODE(Hrd_apprl, 0,'Pending',1,'Apprd',2,'DisApprd') Hrd_ApprlDesc,
    lead_apprl_empno,
    lead_reason,
    HodReason,
    HrdReason,
    Hod_apprl,
    Hrd_Apprl,
    'DP' FromTab
  FROM ss_holiday_attendance;
---------------------------
--Changed PACKAGE
--IOT_GUEST_MEET_QRY
---------------------------
CREATE OR REPLACE PACKAGE "IOT_GUEST_MEET_QRY" AS 

  Function fn_guest_attendance(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default null,
        p_end_date    Date Default null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    
END IOT_GUEST_MEET_QRY;
/
---------------------------
--New PACKAGE
--IOT_EXTRAHOURS_QRY
---------------------------
CREATE OR REPLACE PACKAGE "IOT_EXTRAHOURS_QRY" As
    Function fn_extra_hrs_claims_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_extra_hrs_claims_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_extra_hrs_claim_detail(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_claim_no  Varchar2
    ) Return Sys_Refcursor;

    Function fn_pending_lead_approval(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor;

    Function fn_pending_hod_approval(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor;

    Function fn_pending_hr_approval(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor;

End iot_extrahours_qry;
/
---------------------------
--Changed PACKAGE
--IOT_ONDUTY_QRY
---------------------------
CREATE OR REPLACE PACKAGE "IOT_ONDUTY_QRY" As

    Function fn_onduty_applications_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_onduty_type Varchar2 Default Null,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_onduty_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_onduty_type Varchar2 Default Null,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_pending_lead_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_pending_hod_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_pending_hr_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

End iot_onduty_qry;
/
---------------------------
--Changed PACKAGE
--IOT_LEAVE
---------------------------
CREATE OR REPLACE PACKAGE "IOT_LEAVE" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

    Procedure sp_validate_new_leave(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_leave_type         Varchar2,
        p_start_date         Date,
        p_end_date           Date,
        p_half_day_on        Number,

        p_leave_period   Out Number,
        p_last_reporting Out Varchar2,
        p_resuming       Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2

    );

    Procedure sp_add_leave_application(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_leave_type             Varchar2,
        p_start_date             Date,
        p_end_date               Date,
        p_half_day_on            Number,
        p_projno                 Varchar2,
        p_care_taker             Varchar2,
        p_reason                 Varchar2,
        p_med_cert_available     Varchar2 Default Null,
        p_contact_address        Varchar2 Default Null,
        p_contact_std            Varchar2 Default Null,
        p_contact_phone          Varchar2 Default Null,
        p_office                 Varchar2,
        p_lead_empno             Varchar2,
        p_discrepancy            Varchar2 Default Null,
        p_med_cert_file_nm       Varchar2 Default Null,

        p_new_application_id Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    );

    Procedure sp_leave_details(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,

        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_flag_is_adj        Out Varchar2,
        p_flag_can_del       Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    );

    Procedure sp_delete_leave_app(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_application_id             Varchar2,

        p_medical_cert_file_name Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    );

    Procedure sp_delete_leave_app_force(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_application_id             Varchar2,

        p_medical_cert_file_name Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    ) ;

    Procedure sp_leave_balances(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2 Default Null,
        p_start_date       Date,
        p_end_date         Date,

        p_open_cl      Out Varchar2,
        p_open_sl      Out Varchar2,
        p_open_pl      Out Varchar2,
        p_open_ex      Out Varchar2,
        p_open_co      Out Varchar2,
        p_open_oh      Out Varchar2,
        p_open_lv      Out Varchar2,

        p_close_cl     Out Varchar2,
        p_close_sl     Out Varchar2,
        p_close_pl     Out Varchar2,
        p_close_ex     Out Varchar2,
        p_close_co     Out Varchar2,
        p_close_oh     Out Varchar2,
        p_close_lv     Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_leave_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_leave_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_leave_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );
End iot_leave;
/
---------------------------
--Changed PACKAGE
--IOT_ONDUTY
---------------------------
CREATE OR REPLACE PACKAGE "IOT_ONDUTY" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

    Procedure sp_add_punch_entry(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
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

    Procedure sp_add_depu_tour(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_start_date       Date,
        p_end_date         Date,
        p_type             Varchar2,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_delete_od_app_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_onduty_application_details(
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

    Procedure sp_onduty_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_onduty_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_onduty_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

End iot_onduty;
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
                    n_otperiod(cp_empno, d_date, shiftcode, deltahrs)                       As extra_hours,
                    trunc(n_otperiod(cp_empno, d_date, shiftcode, deltahrs, 1) / 240) * 240 As comp_off_hrs,
                    Case
                        When is_sunday = 0 Then

                            n_otperiod(cp_empno, d_date, shiftcode, deltahrs)
                        Else
                            0
                    End                                                                     As weekday_extra_hours,
                    Case
                        When is_sunday > 0 Then

                            n_otperiod(cp_empno, d_date, shiftcode, deltahrs)
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
--IOT_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE "IOT_SELECT_LIST_QRY" As

    Function fn_leave_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_approvers_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_onduty_types_list_4_user(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_group_no  Number
    ) Return Sys_Refcursor;

    Function fn_onduty_types_list_4_hr(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_group_no  Number
    ) Return Sys_Refcursor;

    Function fn_employee_list_4_hr(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emplist_4_mngrhod(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;
    Function fn_emp_list_4_mngrhod_onbehalf(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor ;

    Function fn_project_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emp_list_for_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_list_for  Varchar2
     -- Lead / Hod /HR
    ) Return Sys_Refcursor;

    Function fn_emp_list_for_lead_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emp_list_for_hod_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emp_list_for_hr_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

End iot_select_list_qry;
/
---------------------------
--New PACKAGE
--IOT_EXTRAHOURS
---------------------------
CREATE OR REPLACE PACKAGE "IOT_EXTRAHOURS" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

    Procedure sp_create_claim(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_yyyymm                Varchar2,
        p_lead_approver         Varchar2,
        p_selected_compoff_days typ_tab_string,
        p_weekend_totals        typ_tab_string,
        p_sum_compoff_hrs       Number,
        p_sum_weekday_extra_hrs Number,
        p_sum_holiday_extra_hrs Number,
        p_message_type Out      Varchar2,
        p_message_text Out      Varchar2
    );

    Procedure sp_delete_claim(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_claim_no         Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_extra_hrs_adjst_details(
        p_application_id         Varchar2,
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_emp_name           Out Varchar2,
        p_claim_no           Out Varchar2,

        p_claimed_ot         Out Varchar2,
        p_claimed_hhot       Out Varchar2,
        p_claimed_co         Out Varchar2,

        p_lead_approved_ot   Out Varchar2,
        p_lead_approved_hhot Out Varchar2,
        p_lead_approved_co   Out Varchar2,

        p_hod_approved_ot    Out Varchar2,
        p_hod_approved_hhot  Out Varchar2,
        p_hod_approved_co    Out Varchar2,

        p_hr_approved_ot     Out Varchar2,
        p_hr_approved_hhot   Out Varchar2,
        p_hr_approved_co     Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    );

    Procedure sp_claim_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_claim_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_claim_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_claim_adjustment_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_no         Varchar2,
        p_approved_ot      Number,
        p_approved_hhot    Number,
        p_approved_co      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_claim_adjustment_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_no         Varchar2,
        p_approved_ot      Number,
        p_approved_hhot    Number,
        p_approved_co      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_claim_adjustment_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_no         Varchar2,
        p_approved_ot      Number,
        p_approved_hhot    Number,
        p_approved_co      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );
End iot_extrahours;
/
---------------------------
--New PACKAGE
--IOT_HOLIDAY_QRY
---------------------------
CREATE OR REPLACE PACKAGE "IOT_HOLIDAY_QRY" As

Function fn_holiday_attendance(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default null,
        p_end_date    Date Default null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;
    
end iot_holiday_qry;
/
---------------------------
--New PACKAGE
--IOT_HOLIDAY
---------------------------
CREATE OR REPLACE PACKAGE "IOT_HOLIDAY" AS 

   Procedure sp_add_holiday(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

		p_office           Varchar2,
		p_date             Date,
        p_project          Varchar2,
        p_approver         Varchar2,
        p_hh1              Varchar2,
        p_mi1              Varchar2,
        p_hh2              Varchar2,
        p_mi2              Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );
    
     Procedure sp_delete_holiday(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );
    

END iot_holiday;
/
---------------------------
--Changed PACKAGE
--IOT_LEAVE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "IOT_LEAVE_QRY" As

    Function fn_leave_ledger_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_leave_ledger_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_leave_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_leave_type  Varchar2 Default Null,
        p_row_number  Number   ,
        p_page_length Number   
    ) Return Sys_Refcursor;

    Function fn_leave_applications_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
        p_leave_type  Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_pending_hod_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_pending_hr_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_pending_lead_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

End iot_leave_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_ONDUTY_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_ONDUTY_QRY" As

    Function fn_get_onduty_applications(
        p_empno        Varchar2,
        p_req_for_self Varchar2,
        p_onduty_type  Varchar2 Default Null,
        p_start_date   Date     Default Null,
        p_end_date     Date     Default Null,
        p_row_number   Number,
        p_page_length  Number
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
                        Case
                            When p_req_for_self = 'OK' Then
                                a.can_delete_app
                            Else
                                0
                        End                                     As can_delete_app,
                        Row_Number() Over (Order By a.app_date) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_odappstat a
                    Where
                        a.empno    = p_empno
                        And a.pdate >= add_months(sysdate, - 24)
                        And a.type = nvl(p_onduty_type, a.type)
                        And a.pdate Between trunc(nvl(p_start_date, a.pdate)) And trunc(nvl(p_end_date, a.pdate))
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
        p_onduty_type Varchar2 Default Null,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_self_empno         Varchar2(5);
        v_req_for_self       Varchar2(2);
        v_for_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_self_empno := get_empno_from_person_id(p_person_id);
        If v_self_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Select
            empno
        Into
            v_for_empno
        From
            ss_emplmast
        Where
            empno      = p_empno
            And status = 1;
        If v_self_empno = v_for_empno Then
            v_req_for_self := 'OK';
        Else
            v_req_for_self := 'KO';
        End If;

        c            := fn_get_onduty_applications(v_for_empno, v_req_for_self, p_onduty_type, p_start_date, p_end_date, p_row_number,
                                                   p_page_length);
        Return c;
    End fn_onduty_applications_4_other;

    Function fn_onduty_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_onduty_type Varchar2 Default Null,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
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
        c       := fn_get_onduty_applications(v_empno, 'OK', p_onduty_type, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;

    End fn_onduty_applications_4_self;

    Function fn_pending_lead_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_lead_empno         Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_lead_empno := get_empno_from_person_id(p_person_id);
        If v_lead_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        to_char(bdate, 'dd-Mon-yyyy')           As start_date,
                        to_char(edate, 'dd-Mon-yyyy')           As end_date,
                        type                                    As onduty_type,
                        dm_get_emp_office(a.empno)              As office,
                        a.empno || ' - ' || name                As emp_name,
                        a.empno                                 As emp_no,
                        parent                                  As parent,
                        getempname(lead_apprl_empno)            As lead_name,
                        lead_reason                             As lead_remarks,
                        Row_Number() Over (Order By a.app_date) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_odapprl  a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0)    = 0)
                        And a.empno            = e.empno
                        And e.status           = 1
                        And a.lead_apprl_empno = Trim(v_lead_empno)
                    Order By parent, a.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_lead_approval;

    Function fn_pending_hod_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_hod_empno := get_empno_from_person_id(p_person_id);
        If v_hod_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        to_char(bdate, 'dd-Mon-yyyy')           As start_date,
                        to_char(edate, 'dd-Mon-yyyy')           As end_date,
                        type                                    As onduty_type,
                        dm_get_emp_office(a.empno)              As office,
                        a.empno || ' - ' || name                As emp_name,
                        a.empno                                 As emp_no,
                        parent                                  As parent,
                        getempname(lead_apprl_empno)            As lead_name,
                        hodreason                               As hod_remarks,
                        Row_Number() Over (Order By a.app_date) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_odapprl  a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0) In (1, 4))
                        And (nvl(hod_apprl, 0) = 0)
                        And a.empno            = e.empno
                        And e.status           = 1
                        And a.empno In (
                            Select
                                empno
                            From
                                ss_emplmast
                            Where
                                mngr = Trim(v_hod_empno)
                        )
                    Order By parent, a.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_hod_approval;

    Function fn_pending_hr_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin

        Open c For
            Select
                *
            From
                (
                    Select
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        to_char(bdate, 'dd-Mon-yyyy')           As start_date,
                        to_char(edate, 'dd-Mon-yyyy')           As end_date,
                        type                                    As onduty_type,
                        dm_get_emp_office(a.empno)              As office,
                        a.empno || ' - ' || name                As emp_name,
                        a.empno                                 As emp_no,
                        parent                                  As parent,
                        getempname(lead_apprl_empno)            As lead_name,
                        hrdreason                               As hr_remarks,
                        Row_Number() Over (Order By a.app_date) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_odapprl  a,
                        ss_emplmast e
                    Where
                        (nvl(hod_apprl, 0)     = 1)
                        And a.empno            = e.empno
                        And e.status           = 1
                        And (nvl(hrd_apprl, 0) = 0)
                    Order By app_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_hr_approval;

End iot_onduty_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_SELECT_LIST_QRY" As

    Function fn_leave_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                leavetype   data_value_field,
                description data_text_field
            From
                ss_leavetype
            Where
                is_active = 1;
        Return c;
    End fn_leave_type_list;

    Function fn_approvers_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                'None'          data_value_field,
                'Head Of Dept.' data_text_field
            From
                dual
            Union
            Select
                a.empno data_value_field,
                b.name  data_text_field
            From
                ss_lead_approver a,
                ss_emplmast      b
            Where
                a.empno      = b.empno
                And a.parent In
                (
                    Select
                        e.assign
                    From
                        ss_emplmast e
                    Where
                        e.personid = p_person_id
                )
                And b.status = 1;
        Return c;
    End;

    Function fn_onduty_types_list_4_user(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_group_no  Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                type        data_value_field,
                description data_text_field
            From
                ss_ondutymast
            Where
                is_active    = 1
                And group_no = p_group_no
            Order By
                sort_order;

        Return c;
    End;
    Function fn_onduty_types_list_4_hr(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_group_no  Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                type        data_value_field,
                description data_text_field
            From
                ss_ondutymast
            Where
                group_no = p_group_no
            Order By
                sort_order;

        Return c;
    End;

    Function fn_employee_list_4_hr(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                empno                  data_value_field,
                empno || ' - ' || name data_text_field
            From
                ss_emplmast
            Where
                status = 1
            Order By
                empno;

        Return c;
    End;

    Function fn_emplist_4_mngrhod(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_mngr_empno         Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_mngr_empno := get_empno_from_person_id(p_person_id);
        If v_mngr_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                empno                  data_value_field,
                empno || ' - ' || name data_text_field
            From
                ss_emplmast
            Where
                status       = 1
                And (mngr    = v_mngr_empno
                    Or empno = v_mngr_empno)
            Order By
                empno;

        Return c;
    End;

    Function fn_emp_list_4_mngrhod_onbehalf(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                     Sys_Refcursor;
        v_mngr_onbehalf_empno Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_mngr_onbehalf_empno := get_empno_from_person_id(p_person_id);
        If v_mngr_onbehalf_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                empno                  data_value_field,
                empno || ' - ' || name data_text_field
            From
                ss_emplmast
            Where
                status = 1
                And mngr In (
                    Select
                        mngr
                    From
                        ss_delegate
                    Where
                        empno = v_mngr_onbehalf_empno
                )
            Order By
                empno;

        Return c;
    End;

    Function fn_project_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                 Sys_Refcursor;
        v_empno           Varchar2(5);
        timesheet_allowed Number;
    Begin
        v_empno := get_empno_from_person_id(p_person_id);

        Select
            n_timesheetallowed(v_empno)
        Into
            timesheet_allowed
        From
            dual;

        If (timesheet_allowed = 1) Then
            Open c For
                Select
                    projno                  data_value_field,
                    projno || ' - ' || name data_text_field
                From
                    ss_projmast
                Where
                    active = 1
                    And (
                        Select
                            n_timesheetallowed(v_empno)
                        From
                            dual
                    )      = 1;

            Return c;
        Else
            Open c For
                Select
                    'None' data_value_field,
                    'None' data_text_field
                From
                    dual;
            Return c;
        End If;
    End;

    Function fn_emp_list_for_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_list_for  Varchar2
    -- Lead / Hod /HR
    ) Return Sys_Refcursor As
        c               Sys_Refcursor;
        v_empno         Varchar2(5);
        v_list_for_lead Varchar2(4) := 'Lead';
        v_list_for_hod  Varchar2(4) := 'Hod';
        v_list_for_hr   Varchar2(4) := 'HR';

    Begin

        -- v_empno := get_empno_from_person_id(p_person_id);
        v_empno := '10426';

        If (p_list_for = v_list_for_lead) Then
            Open c For
                Select
                Distinct
                    e.empno                    data_value_field,
                    a.empno || ' - ' || e.name data_text_field
                From
                    ss_leaveapp                a, ss_emplmast e
                Where
                    a.empno              = e.empno
                    And e.status         = 1
                    And personid Is Not Null
                    And lead_apprl_empno = v_empno;

            Return c;

        Elsif (p_list_for = v_list_for_hod) Then
            Open c For
                Select
                Distinct
                    e.empno                    data_value_field,
                    a.empno || ' - ' || e.name data_text_field
                From
                    ss_leaveapp                a, ss_emplmast e
                Where
                    a.empno      = e.empno
                    And e.status = 1
                    And personid Is Not Null
                    And a.empno In
                    (
                        Select
                            empno
                        From
                            ss_emplmast
                        Where
                            mngr = Trim(v_empno)
                    );

            Return c;

        Elsif (p_list_for = v_list_for_hr) Then
            Open c For
                Select
                Distinct
                    e.empno                    data_value_field,
                    a.empno || ' - ' || e.name data_text_field
                From
                    ss_leaveapp                a, ss_emplmast e
                Where
                    a.empno      = e.empno
                    And e.status = 1
                    And personid Is Not Null
                    And (
                        Select
                            Count(empno)
                        From
                            ss_usermast
                        Where
                            empno      = Trim(v_empno)
                            And active = 1
                            And type   = 1
                    ) >= 1;

            Return c;

        Else
            Open c For
                Select
                    'None' data_value_field,
                    'None' data_text_field
                From
                    dual;
            Return c;
        End If;
    End;

    Function fn_emp_list_for_lead_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin

        v_empno := get_empno_from_person_id(p_person_id);
        --v_empno := '10426';
        Open c For
            Select
            Distinct
                e.empno                    data_value_field,
                a.empno || ' - ' || e.name data_text_field
            From
                ss_leaveapp                a, ss_emplmast e
            Where
                a.empno              = e.empno
                And e.status         = 1
                And personid Is Not Null
                And lead_apprl_empno = v_empno;
        Return c;
    End;

    Function fn_emp_list_for_hod_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin

        v_empno := get_empno_from_person_id(p_person_id);

        Open c For
            Select
            Distinct
                e.empno                    data_value_field,
                a.empno || ' - ' || e.name data_text_field
            From
                ss_leaveapp                a, ss_emplmast e
            Where
                a.empno      = e.empno
                And e.status = 1
                And personid Is Not Null
                And a.empno
                In
                (
                    Select
                        empno
                    From
                        ss_emplmast
                    Where
                        mngr = Trim(v_empno)
                );

        Return c;

    End;

    Function fn_emp_list_for_hr_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin

        v_empno := get_empno_from_person_id(p_person_id);

        Open c For
            Select
            Distinct
                e.empno                    data_value_field,
                a.empno || ' - ' || e.name data_text_field
            From
                ss_leaveapp                a, ss_emplmast e
            Where
                a.empno      = e.empno
                And e.status = 1
                And personid Is Not Null
                And (
                    Select
                        Count(empno)
                    From
                        ss_usermast
                    Where
                        empno      = Trim(v_empno)
                        And active = 1
                        And type   = 1
                ) >= 1;

        Return c;

    End;

End iot_select_list_qry;
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
        v_wk_negative_delta := nvl(p_wk_bfwd_dhrs,0) + nvl(p_wk_dhrs,0);
        If v_wk_negative_delta >= 0 Then
            p_pn_hrs    := 0;
            p_cfwd_dhrs := 0;
            return;
        End If;
        If p_fri_sl_app <> 1 Then
            p_pn_hrs := ceil((v_wk_negative_delta*-1) / 60) ;
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
                p_pn_hrs := ceil((v_wk_negative_delta + (p_lday_lcome_ego * -1))*-1 / 60) ;
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
        p_pn_hrs := nvl(p_pn_hrs,0) * 60;
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
--IOT_ONDUTY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_ONDUTY" As

    Procedure sp_onduty_details(
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
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id);
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
                Trim(app_no) = Trim(p_application_id);

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

            p_emp_name      := get_emp_name(v_onduty_app.empno);
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

            p_emp_name      := get_emp_name(v_depu.empno);
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

    Procedure sp_add_punch_entry(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
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
        v_entry_by_empno Varchar2(5);
        v_count          Number;
        v_lead_approval  Number := 0;
        v_hod_approval   Number := 0;
        v_desc           Varchar2(60);
    Begin
        v_entry_by_empno := get_empno_from_person_id(p_person_id);
        If v_entry_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        od.add_onduty_type_1(
            p_empno         => p_empno,
            p_od_type       => p_type,
            p_od_sub_type   => nvl(Trim(p_sub_type), 0),
            p_pdate         => to_char(p_date, 'yyyymmdd'),
            p_hh            => to_number(Trim(p_hh1)),
            p_mi            => to_number(Trim(p_mi1)),
            p_hh1           => to_number(Trim(p_hh2)),
            p_mi1           => to_number(Trim(p_mi2)),
            p_lead_approver => p_lead_approver,
            p_reason        => p_reason,
            p_entry_by      => v_entry_by_empno,
            p_user_ip       => Null,
            p_success       => p_message_type,
            p_message       => p_message_text
        );

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_punch_entry;

    Procedure sp_add_depu_tour(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_start_date       Date,
        p_end_date         Date,
        p_type             Varchar2,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_entry_by_empno Varchar2(5);
        v_count          Number;

    Begin
        v_entry_by_empno := get_empno_from_person_id(p_person_id);
        If v_entry_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        od.add_onduty_type_2(
            p_empno         => p_empno,
            p_od_type       => p_type,
            p_b_yyyymmdd    => to_char(p_start_date, 'yyyymmdd'),
            p_e_yyyymmdd    => to_char(p_end_date, 'yyyymmdd'),
            p_entry_by      => v_entry_by_empno,
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

    End sp_add_depu_tour;

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

    Procedure sp_onduty_application_details(
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

    Procedure sp_onduty_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,
        p_approver_profile Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_app_no         Varchar2(70);
        v_approval       Number;
        v_remarks        Varchar2(70);
        c_onduty         Constant Varchar2(2) := 'OD';
        c_deputation     Constant Varchar2(2) := 'DP';
        v_count          Number;
        v_rec_count      Number;
        sqlpartod        Varchar2(60)         := 'Update SS_OnDutyApp ';
        sqlpartdp        Varchar2(60)         := 'Update SS_Depu ';
        sqlpart2         Varchar2(500);
        strsql           Varchar2(600);
        v_odappstat_rec  ss_odappstat%rowtype;
        v_approver_empno Varchar2(5);
        v_user_tcp_ip    Varchar2(30);
    Begin

        v_approver_empno := get_empno_from_person_id(p_person_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sqlpart2         := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfileREASON = :Reason where App_No = :paramAppNo';
        If p_approver_profile = user_profile.type_hod Or p_approver_profile = user_profile.type_sec Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HOD');
        Elsif p_approver_profile = user_profile.type_hrd Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HRD');
        Elsif p_approver_profile = user_profile.type_lead Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'LEAD');
        End If;

        For i In 1..p_onduty_approvals.count
        Loop

            With
                csv As (
                    Select
                        p_onduty_approvals(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))            app_no,
                to_number(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) approval,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))            remarks
            Into
                v_app_no, v_approval, v_remarks
            From
                csv;

            Select
                *
            Into
                v_odappstat_rec
            From
                ss_odappstat
            Where
                Trim(app_no) = Trim(v_app_no);

            If (v_odappstat_rec.fromtab) = c_deputation Then
                strsql := sqlpartdp || ' ' || sqlpart2;
            Elsif (v_odappstat_rec.fromtab) = c_onduty Then
                strsql := sqlpartod || ' ' || sqlpart2;
            End If;
            /*
            p_message_type := 'OK';
            p_message_text := 'Debug 1 - ' || p_onduty_approvals(i);
            Return;
            */
            strsql := replace(strsql, 'LEADREASON', 'LEAD_REASON');
            Execute Immediate strsql
                Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, trim(v_app_no);

            If v_odappstat_rec.fromtab = c_onduty And p_approver_profile = user_profile.type_hrd Then
                Insert Into ss_onduty value
                (
                    Select
                        empno,
                        hh,
                        mm,
                        pdate,
                        0,
                        dd,
                        mon,
                        yyyy,
                        type,
                        app_no,
                        description,
                        getodhh(app_no, 1),
                        getodmm(app_no, 1),
                        app_date,
                        reason,
                        odtype
                    From
                        ss_ondutyapp
                    Where
                        Trim(app_no)                   = Trim(v_app_no)
                        And nvl(hrd_apprl, ss.pending) = ss.approved
                );

                Insert Into ss_onduty value
                (
                    Select
                        empno,
                        hh1,
                        mm1,
                        pdate,
                        0,
                        dd,
                        mon,
                        yyyy,
                        type,
                        app_no,
                        description,
                        getodhh(app_no, 2),
                        getodmm(app_no, 2),
                        app_date,
                        reason,
                        odtype
                    From
                        ss_ondutyapp
                    Where
                        Trim(app_no)                   = Trim(v_app_no)
                        And (type                      = 'OD'
                            Or type                    = 'IO')
                        And nvl(hrd_apprl, ss.pending) = ss.approved
                );

                If p_approver_profile = user_profile.type_hrd And v_approval = ss.approved Then
                    generate_auto_punch_4od(v_app_no);
                End If;

            End If;

        End Loop;

        Commit;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_onduty_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_onduty_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_onduty_approvals => p_onduty_approvals,
            p_approver_profile => user_profile.type_lead,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_onduty_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_onduty_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_onduty_approvals => p_onduty_approvals,
            p_approver_profile => user_profile.type_hod,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_onduty_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_onduty_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_onduty_approvals => p_onduty_approvals,
            p_approver_profile => user_profile.type_hrd,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

End iot_onduty;
/
---------------------------
--Changed PACKAGE BODY
--IOT_LEAVE
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_LEAVE" As

    Procedure get_leave_balance_all(
        p_empno            Varchar2,
        p_pdate            Date,
        p_open_close_flag  Number,

        p_cl           Out Varchar2,
        p_sl           Out Varchar2,
        p_pl           Out Varchar2,
        p_ex           Out Varchar2,
        p_co           Out Varchar2,
        p_oh           Out Varchar2,
        p_lv           Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As

        v_cl  Number;
        v_sl  Number;
        v_pl  Number;
        v_ex  Number;
        v_co  Number;
        v_oh  Number;
        v_lv  Number;
        v_tot Number;
    Begin
        get_leave_balance(
            param_empno       => p_empno,
            param_date        => p_pdate,
            param_open_close  => p_open_close_flag,
            param_leave_type  => 'LV',
            param_leave_count => v_lv
        );

        openbal(
            v_empno       => p_empno,
            v_opbaldtfrom => p_pdate,
            v_openbal     => p_open_close_flag,
            v_cl          => v_cl,
            v_pl          => v_pl,
            v_sl          => v_sl,
            v_ex          => v_ex,
            v_co          => v_co,
            v_oh          => v_oh,
            v_tot         => v_tot
        );

        p_cl := to_days(v_cl);
        p_pl := to_days(v_pl);
        p_sl := to_days(v_sl);
        p_ex := to_days(v_ex);
        p_co := to_days(v_co);
        p_oh := to_days(v_oh);
        p_lv := to_days(v_lv);

        p_cl := nvl(trim(p_cl), '0.0');
        p_pl := nvl(trim(p_pl), '0.0');
        p_sl := nvl(trim(p_sl), '0.0');
        p_ex := nvl(trim(p_ex), '0.0');
        p_co := nvl(trim(p_co), '0.0');
        p_oh := nvl(trim(p_oh), '0.0');
        p_lv := nvl(trim(p_lv), '0.0');

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure get_leave_details_from_app(
        p_application_id         Varchar2,

        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_flag_can_del       Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As
        v_leave_app ss_leaveapp%rowtype;
    Begin
        Select
            *
        Into
            v_leave_app
        From
            ss_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);
        p_emp_name           := get_emp_name(v_leave_app.empno);
        p_leave_type         := v_leave_app.leavetype;
        p_start_date         := to_char(v_leave_app.bdate, 'dd-Mon-yyyy');
        p_end_date           := to_char(v_leave_app.edate, 'dd-Mon-yyyy');

        p_leave_period       := to_days(v_leave_app.leaveperiod);
        p_last_reporting     := to_char(v_leave_app.work_ldate, 'dd-Mon-yyyy');
        p_resuming           := to_char(v_leave_app.resm_date, 'dd-Mon-yyyy');

        p_projno             := v_leave_app.projno;
        p_care_taker         := v_leave_app.caretaker;
        p_reason             := v_leave_app.reason;
        p_med_cert_available := v_leave_app.mcert;
        p_contact_address    := v_leave_app.contact_add;
        p_contact_std        := v_leave_app.contact_std;
        p_contact_phone      := v_leave_app.contact_phn;
        p_office             := v_leave_app.office;
        p_lead_name          := get_emp_name(v_leave_app.lead_code);
        p_discrepancy        := v_leave_app.discrepancy;
        p_med_cert_file_nm   := v_leave_app.med_cert_file_name;

        If nvl(v_leave_app.lead_apprl, 0) = 1 Or nvl(v_leave_app.hod_apprl, 0) = 1 Or nvl(v_leave_app.hrd_apprl, 0) = 1 Then
            p_flag_can_del := 'KO';
        Else
            p_flag_can_del := 'OK';
        End If;

        p_lead_approval      := ss.approval_text(v_leave_app.lead_apprl);
        p_hod_approval       := ss.approval_text(v_leave_app.hod_apprl);
        p_hr_approval        := ss.approval_text(v_leave_app.hrd_apprl);

        p_message_text       := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure get_leave_details_from_adj(
        p_application_id    Varchar2,

        p_emp_name      Out Varchar2,
        p_leave_type    Out Varchar2,
        p_start_date    Out Varchar2,
        p_end_date      Out Varchar2,

        p_leave_period  Out Number,

        p_reason        Out Varchar2,

        p_lead_approval Out Varchar2,
        p_hod_approval  Out Varchar2,
        p_hr_approval   Out Varchar2,

        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
    ) As
        v_leave_adj ss_leave_adj%rowtype;
    Begin
        Select
            *
        Into
            v_leave_adj
        From
            ss_leave_adj
        Where
            adj_no = p_application_id;
        p_emp_name     := get_emp_name(v_leave_adj.empno);
        p_leave_type   := v_leave_adj.leavetype;
        p_start_date   := to_char(v_leave_adj.bdate, 'dd-Mon-yyyy');
        p_end_date     := to_char(v_leave_adj.edate, 'dd-Mon-yyyy');

        p_leave_period := to_days(v_leave_adj.leaveperiod);
        p_reason       := v_leave_adj.description;
        p_message_text := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_validate_new_leave(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_leave_type         Varchar2,
        p_start_date         Date,
        p_end_date           Date,
        p_half_day_on        Number,

        p_leave_period   Out Number,
        p_last_reporting Out Varchar2,
        p_resuming       Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2

    ) As
        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee by person id';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = v_empno;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        leave.validate_leave(
            param_empno          => v_empno,
            param_leave_type     => p_leave_type,
            param_bdate          => trunc(p_start_date),
            param_edate          => trunc(p_end_date),
            param_half_day_on    => p_half_day_on,
            param_app_no         => Null,
            param_leave_period   => p_leave_period,
            param_last_reporting => p_last_reporting,
            param_resuming       => p_resuming,
            param_msg_type       => v_message_type,
            param_msg            => p_message_text
        );
        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;
    Exception
        When Others Then
            p_message_type := ss.failure;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_new_leave;

    Procedure sp_add_leave_application(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_leave_type             Varchar2,
        p_start_date             Date,
        p_end_date               Date,
        p_half_day_on            Number,
        p_projno                 Varchar2,
        p_care_taker             Varchar2,
        p_reason                 Varchar2,
        p_med_cert_available     Varchar2 Default Null,
        p_contact_address        Varchar2 Default Null,
        p_contact_std            Varchar2 Default Null,
        p_contact_phone          Varchar2 Default Null,
        p_office                 Varchar2,
        p_lead_empno             Varchar2,
        p_discrepancy            Varchar2 Default Null,
        p_med_cert_file_nm       Varchar2 Default Null,

        p_new_application_id Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As

        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee by person id';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = v_empno;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        leave.add_leave_app(
            param_empno            => v_empno,
            param_leave_type       => p_leave_type,
            param_bdate            => p_start_date,
            param_edate            => p_end_date,
            param_half_day_on      => p_half_day_on,
            param_projno           => p_projno,
            param_caretaker        => p_care_taker,
            param_reason           => p_reason,
            param_cert             => p_med_cert_available,
            param_contact_add      => p_contact_address,
            param_contact_std      => p_contact_std,
            param_contact_phn      => p_contact_phone,
            param_office           => p_office,
            param_dataentryby      => v_empno,
            param_lead_empno       => p_lead_empno,
            param_discrepancy      => p_discrepancy,
            param_med_cert_file_nm => p_med_cert_file_nm,
            param_tcp_ip           => Null,
            param_nu_app_no        => p_new_application_id,
            param_msg_type         => v_message_type,
            param_msg              => p_message_text
        );

        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;

    End;

    Procedure sp_leave_details(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,

        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_flag_is_adj        Out Varchar2,
        p_flag_can_del       Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As
        v_count Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 1 Then
            get_leave_details_from_app(
                p_application_id     => p_application_id,

                p_emp_name           => p_emp_name,
                p_leave_type         => p_leave_type,
                p_start_date         => p_start_date,
                p_end_date           => p_end_date,

                p_leave_period       => p_leave_period,
                p_last_reporting     => p_last_reporting,
                p_resuming           => p_resuming,

                p_projno             => p_projno,
                p_care_taker         => p_care_taker,
                p_reason             => p_reason,
                p_med_cert_available => p_med_cert_available,
                p_contact_address    => p_contact_address,
                p_contact_std        => p_contact_std,
                p_contact_phone      => p_contact_phone,
                p_office             => p_office,
                p_lead_name          => p_lead_name,
                p_discrepancy        => p_discrepancy,
                p_med_cert_file_nm   => p_med_cert_file_nm,

                p_lead_approval      => p_lead_approval,
                p_hod_approval       => p_hod_approval,
                p_hr_approval        => p_hr_approval,

                p_flag_can_del       => p_flag_can_del,

                p_message_type       => p_message_type,
                p_message_text       => p_message_text
            );
            p_flag_is_adj := 'KO';
        Else
            get_leave_details_from_adj(
                p_application_id => p_application_id,

                p_emp_name       => p_emp_name,
                p_leave_type     => p_leave_type,
                p_start_date     => p_start_date,
                p_end_date       => p_end_date,

                p_leave_period   => p_leave_period,

                p_reason         => p_reason,

                p_lead_approval  => p_lead_approval,
                p_hod_approval   => p_hod_approval,
                p_hr_approval    => p_hr_approval,

                p_message_type   => p_message_type,
                p_message_text   => p_message_text
            );
            p_flag_is_adj  := 'OK';
            p_flag_can_del := 'KO';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete_leave_app(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_application_id             Varchar2,

        p_medical_cert_file_name Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    ) As
        v_count      Number;
        v_empno      Varchar2(5);
        rec_leaveapp ss_leaveapp%rowtype;
    Begin
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
            ss_leaveapp
        Where
            empno            = v_empno
            And Trim(app_no) = Trim(p_application_id);
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid application id';
            Return;
        End If;
        Select
            med_cert_file_name
        Into
            p_medical_cert_file_name
        From
            ss_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);

        deleteleave(trim(p_application_id));

        p_message_type := 'OK';
        p_message_text := 'Application deleted successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete_leave_app_force(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_application_id             Varchar2,

        p_medical_cert_file_name Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    ) As
        v_count      Number;
        v_empno      Varchar2(5);
        rec_leaveapp ss_leaveapp%rowtype;
    Begin
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
            ss_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 1 Then
            Select
                med_cert_file_name
            Into
                p_medical_cert_file_name
            From
                ss_leaveapp
            Where
                Trim(app_no) = Trim(p_application_id);
        End If;

        deleteleave(trim(p_application_id));

        p_message_type := 'OK';
        p_message_text := 'Application deleted successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_leave_app_force;

    Procedure sp_leave_balances(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2 Default Null,
        p_start_date       Date,
        p_end_date         Date,

        p_open_cl      Out Varchar2,
        p_open_sl      Out Varchar2,
        p_open_pl      Out Varchar2,
        p_open_ex      Out Varchar2,
        p_open_co      Out Varchar2,
        p_open_oh      Out Varchar2,
        p_open_lv      Out Varchar2,

        p_close_cl     Out Varchar2,
        p_close_sl     Out Varchar2,
        p_close_pl     Out Varchar2,
        p_close_ex     Out Varchar2,
        p_close_co     Out Varchar2,
        p_close_oh     Out Varchar2,
        p_close_lv     Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        If p_empno Is Null Then
            v_empno := get_empno_from_person_id(p_person_id);
            If v_empno = 'ERRRR' Then
                p_message_type := 'KO';
                p_message_text := 'Invalid employee by person id';
                Return;
            End If;
        Else
            v_empno := p_empno;
        End If;
        /*
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = p_empno;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        */
        get_leave_balance_all(
            p_empno           => v_empno,
            p_pdate           => p_start_date,
            p_open_close_flag => ss.opening_bal,

            p_cl              => p_open_cl,
            p_sl              => p_open_sl,
            p_pl              => p_open_pl,
            p_ex              => p_open_ex,
            p_co              => p_open_co,
            p_oh              => p_open_oh,
            p_lv              => p_open_lv,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        If p_message_type = 'KO' Then
            Return;
        End If;

        get_leave_balance_all(
            p_empno           => v_empno,
            p_pdate           => p_end_date,
            p_open_close_flag => ss.closing_bal,

            p_cl              => p_close_cl,
            p_sl              => p_close_sl,
            p_pl              => p_close_pl,
            p_ex              => p_close_ex,
            p_co              => p_close_co,
            p_oh              => p_close_oh,
            p_lv              => p_close_lv,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_leave_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,
        p_approver_profile Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_app_no         Varchar2(70);
        v_approval       Number;
        v_remarks        Varchar2(70);
        v_count          Number;
        v_rec_count      Number;
        sqlpart1         Varchar2(60) := 'Update SS_leaveapp ';
        sqlpart2         Varchar2(500);
        strsql           Varchar2(600);
        v_odappstat_rec  ss_odappstat%rowtype;
        v_approver_empno Varchar2(5);
        v_user_tcp_ip    Varchar2(30);
        v_msg_type       Number;
        v_msg_text       Varchar2(1000);
    Begin

        v_approver_empno := get_empno_from_person_id(p_person_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sqlpart2         := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfileREASON = :Reason where App_No = :paramAppNo';
        If p_approver_profile = user_profile.type_hod Or p_approver_profile = user_profile.type_sec Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HOD');
        Elsif p_approver_profile = user_profile.type_hrd Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HRD');
        Elsif p_approver_profile = user_profile.type_lead Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'LEAD');
        End If;

        For i In 1..p_leave_approvals.count
        Loop

            With
                csv As (
                    Select
                        p_leave_approvals(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))            app_no,
                to_number(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) approval,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))            remarks
            Into
                v_app_no, v_approval, v_remarks
            From
                csv;

            /*
            p_message_type := 'OK';
            p_message_text := 'Debug 1 - ' || p_leave_approvals(i);
            Return;
            */
            strsql := sqlpart1 || ' ' || sqlpart2;
            strsql := replace(strsql, 'LEADREASON', 'LEAD_REASON');
            Execute Immediate strsql
                Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, trim(v_app_no);

            If p_approver_profile = user_profile.type_hrd Then
                leave.post_leave_apprl(v_app_no, v_msg_type, v_msg_text);
                If v_msg_type = ss.success Then
                    If p_approver_profile = user_profile.type_hrd And v_approval = ss.approved Then
                        generate_auto_punch_4od(v_app_no);
                    End If;
                End If;
            End If;

        End Loop;

        Commit;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_leave_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_leave_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_leave_approvals  => p_leave_approvals,
            p_approver_profile => user_profile.type_lead,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_leave_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_leave_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_leave_approvals  => p_leave_approvals,
            p_approver_profile => user_profile.type_hod,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_leave_approval_hod;

    Procedure sp_leave_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_leave_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_leave_approvals  => p_leave_approvals,
            p_approver_profile => user_profile.type_hrd,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_leave_approval_hr;

End iot_leave;
/
---------------------------
--New PACKAGE BODY
--IOT_HOLIDAY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_HOLIDAY" AS

  Procedure sp_add_holiday(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

		p_office           Varchar2,
		p_date             Date,
        p_project          Varchar2,
        p_approver         Varchar2,
        p_hh1              Varchar2,
        p_mi1              Varchar2,
        p_hh2              Varchar2,
        p_mi2              Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) AS
            v_empno         Varchar2(5);
            v_user_tcp_ip   Varchar2(5) :='NA';
            v_message_type  Number := 0;
  BEGIN
   v_empno    := get_empno_from_person_id(p_person_id);
        
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
   holiday_attendance.sp_add_holiday(
            p_person_id		=> p_person_id,
            p_meta_id	    => p_meta_id,
            p_from_date		=> p_date,
            p_projno		=> p_project,
            p_last_hh		=> to_number(Trim(p_hh1)),
            p_last_mn		=> to_number(Trim(p_mi1)),
            p_last_hh1		=> to_number(Trim(p_hh2)),
            p_last_mn1		=> to_number(Trim(p_mi2)),
            p_lead_approver	=> p_approver,
            p_remarks       => p_reason,
            p_location      => Trim(P_office),
            p_user_tcp_ip   => Trim(v_user_tcp_ip),
            p_message_type		=> p_message_type,
            p_message_text		=> p_message_text
        );
  
        If v_message_type = ss.failure Then
             p_message_type := 'KO';
         Else
             p_message_type := 'OK';
         End If;
  
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            
  END sp_add_holiday;

  Procedure sp_delete_holiday(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) AS
       v_empno         Varchar2(5);
       v_user_tcp_ip   Varchar2(5) :='NA';
       v_message_type  Number := 0;
  BEGIN
    v_empno    := get_empno_from_person_id(p_person_id);
        
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
   holiday_attendance.sp_delete_holiday(
            p_person_id		    => p_person_id,
            p_meta_id	        => p_meta_id,
            p_application_id	=> p_application_id,
            p_message_type		=> p_message_type,
            p_message_text		=> p_message_text
        );
  
        If v_message_type = ss.failure Then
             p_message_type := 'KO';
         Else
             p_message_type := 'OK';
         End If;
  
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            
  END sp_delete_holiday;

END IOT_HOLIDAY;
/
---------------------------
--New PACKAGE BODY
--IOT_EXTRAHOURS_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_EXTRAHOURS_QRY" As

    Function fn_extra_hrs_claims(
        p_empno        Varchar2,
        p_req_for_self Varchar2,
        p_start_date   Date Default Null,
        p_row_number   Number,
        p_page_length  Number
    ) Return Sys_Refcursor As
        v_request_for_self Varchar2(20);
        c                  Sys_Refcursor;
    Begin
        Open c For

            Select
                claims.*
            From
                (

                    Select
                        a.app_date                                                               As claim_date,
                        a.app_no                                                                 As claim_no,
                        month || '-' || yyyy                                                     As claim_period,
                        a.lead_apprl_empno || ' - ' || get_emp_name(nvl(a.lead_apprl_empno, '')) lead_name,
                        ot                                                                       As claimed_ot,
                        hhot                                                                     As claimed_hhot,
                        co                                                                       As claimed_co,
                        ss.approval_text(nvl(a.lead_apprl, 0))                                   lead_approval_desc,
                        ss.approval_text(nvl(a.hod_apprl, 0))                                    hod_approval_desc,
                        ss.approval_text(nvl(a.hrd_apprl, 0))                                    hrd_approval_desc,
                        a.lead_remarks,
                        a.hod_remarks,
                        a.hrd_remarks,
                        nvl(a.lead_apprd_ot, 0)                                                  As lead_approved_ot,
                        nvl(a.lead_apprd_hhot, 0)                                                As lead_approved_hhot,
                        nvl(a.lead_apprd_co, 0)                                                  As lead_approved_co,
                        nvl(a.hod_apprd_ot, 0)                                                   As hod_approved_ot,
                        nvl(a.hod_apprd_hhot, 0)                                                 As hod_approved_hhot,
                        nvl(a.hod_apprd_co, 0)                                                   As hod_approved_co,
                        Case
                            When nvl(a.hrd_apprd_ot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_ot
                        End                                                                      As hrd_approved_ot,
                        Case
                            When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_hhot
                        End                                                                      As hrd_approved_hhot,
                        Case
                            When nvl(a.hrd_apprd_co, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_co
                        End                                                                      As hrd_approved_co,
                        Case
                            When p_req_for_self                  = 'OK'
                                And nvl(a.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
                                And nvl(a.hod_apprl, ss.pending) = ss.pending
                            Then
                                1
                            Else
                                0
                        End                                                                      can_delete_claim,
                        Row_Number() Over (Order By app_date Desc)                               row_number,
                        Count(*) Over ()                                                         total_row

                    From
                        ss_otmaster a
                    Where
                        a.empno             = p_empno
                        And to_number(a.yyyy || a.mon) >= to_number(to_char(add_months(sysdate, - 24), 'YYYYMM'))
                        And a.yyyy || a.mon = Case
                            When p_start_date Is Null Then
                                a.yyyy || a.mon
                            Else
                                to_char(p_start_date, 'yyyymm')
                        End
                    Order By a.app_date Desc
                ) claims
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_extra_hrs_claims;

    Function fn_extra_hrs_claims_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        c       := fn_extra_hrs_claims(
                       p_empno        => v_empno,
                       p_req_for_self => 'OK',
                       p_start_date   => p_start_date,
                       p_row_number   => p_row_number,
                       p_page_length  => p_page_length
                   );
        Return c;
    End fn_extra_hrs_claims_4_self;

    Function fn_extra_hrs_claims_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        v_count              Number;
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
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
            Return Null;
        End If;
        c := fn_extra_hrs_claims(
                 p_empno        => p_empno,
                 p_req_for_self => 'KO',
                 p_start_date   => p_start_date,
                 p_row_number   => p_row_number,
                 p_page_length  => p_page_length
             );
        Return c;
    End fn_extra_hrs_claims_4_other;

    Function fn_extra_hrs_claim_detail(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_claim_no  Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                ot_detail.*,
                to_hrs(nvl(get_time_sheet_work_hrs(empno, pdate), 0) * 60)  As ts_work_hrs,
                to_hrs(nvl(get_time_sheet_extra_hrs(empno, pdate), 0) * 60) As ts_extra_hrs
            From
                (
                    Select
                        empno,
                        yyyy || '-' || mon                                             As claim_period,
                        app_no                                                         As claim_no,
                        d_details                                                      As day_detail,
                        w_details                                                      As week_detail,
                        w_ot_max                                                       As week_extrahours_applicable,
                        w_ot_claim                                                     As week_extrahours_claim,
                        w_co                                                           As week_claimed_co,
                        w_hhot_claim                                                   As week_holiday_ot_claim,
                        w_hhot_max                                                     As week_holiday_ot_applicable,
                        to_date(day_yyyy || '-' || of_mon || '-' || day, 'yyyy-mm-dd') As pdate
                    From
                        ss_otdetail
                    Where
                        app_no = p_claim_no
                ) ot_detail
            Order By
                pdate;
        Return c;
    End fn_extra_hrs_claim_detail;

    Function fn_pending_lead_approval(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        v_empno              Varchar2(5);
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                *
            From
                (

                    Select
                        e.empno || ' - ' || e.name                                               As employee,
                        a.app_date                                                               As claim_date,
                        a.app_no                                                                 As claim_no,
                        month || '-' || yyyy                                                     As claim_period,
                        a.lead_apprl_empno || ' - ' || get_emp_name(nvl(a.lead_apprl_empno, '')) lead_name,
                        ot                                                                       As claimed_ot,
                        hhot                                                                     As claimed_hhot,
                        co                                                                       As claimed_co,
                        ss.approval_text(nvl(a.lead_apprl, 0))                                   lead_approval_desc,
                        ss.approval_text(nvl(a.hod_apprl, 0))                                    hod_approval_desc,
                        ss.approval_text(nvl(a.hrd_apprl, 0))                                    hrd_approval_desc,
                        a.lead_remarks,
                        a.hod_remarks,
                        a.hrd_remarks,
                        nvl(a.lead_apprd_ot, 0)                                                  As lead_approved_ot,
                        nvl(a.lead_apprd_hhot, 0)                                                As lead_approved_hhot,
                        nvl(a.lead_apprd_co, 0)                                                  As lead_approved_co,
                        nvl(a.hod_apprd_ot, 0)                                                   As hod_approved_ot,
                        nvl(a.hod_apprd_hhot, 0)                                                 As hod_approved_hhot,
                        nvl(a.hod_apprd_co, 0)                                                   As hod_approved_co,
                        Case
                            When nvl(a.hrd_apprd_ot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_ot
                        End                                                                      As hrd_approved_ot,
                        Case
                            When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_hhot
                        End                                                                      As hrd_approved_hhot,
                        Case
                            When nvl(a.hrd_apprd_co, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_co
                        End                                                                      As hrd_approved_co,
                        Case
                            When nvl(a.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
                                And nvl(a.hod_apprl, ss.pending) = ss.pending
                            Then
                                1
                            Else
                                0
                        End                                                                      can_delete_claim,
                        Row_Number() Over (Order By app_date Desc)                               row_number,
                        Count(*) Over ()                                                         total_row

                    From
                        ss_otmaster a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0)    = 0)
                        And e.empno            = a.empno
                        And a.lead_apprl_empno = v_empno
                        And a.app_no           = nvl(p_application_id, a.app_no)
                        And to_number(a.yyyy || a.mon) >= to_number(to_char(add_months(sysdate, - 24), 'YYYYMM'))
                    Order By a.app_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_pending_lead_approval;

    Function fn_pending_hod_approval(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        v_empno              Varchar2(5);
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                *
            From
                (

                    Select
                        e.empno || ' - ' || e.name                                               As employee,
                        a.app_date                                                               As claim_date,
                        a.app_no                                                                 As claim_no,
                        month || '-' || yyyy                                                     As claim_period,
                        a.lead_apprl_empno || ' - ' || get_emp_name(nvl(a.lead_apprl_empno, '')) lead_name,
                        ot                                                                       As claimed_ot,
                        hhot                                                                     As claimed_hhot,
                        co                                                                       As claimed_co,
                        ss.approval_text(nvl(a.lead_apprl, 0))                                   lead_approval_desc,
                        ss.approval_text(nvl(a.hod_apprl, 0))                                    hod_approval_desc,
                        ss.approval_text(nvl(a.hrd_apprl, 0))                                    hrd_approval_desc,
                        a.lead_remarks,
                        a.hod_remarks,
                        a.hrd_remarks,
                        nvl(a.lead_apprd_ot, 0)                                                  As lead_approved_ot,
                        nvl(a.lead_apprd_hhot, 0)                                                As lead_approved_hhot,
                        nvl(a.lead_apprd_co, 0)                                                  As lead_approved_co,
                        nvl(a.hod_apprd_ot, 0)                                                   As hod_approved_ot,
                        nvl(a.hod_apprd_hhot, 0)                                                 As hod_approved_hhot,
                        nvl(a.hod_apprd_co, 0)                                                   As hod_approved_co,
                        Case
                            When nvl(a.hrd_apprd_ot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_ot
                        End                                                                      As hrd_approved_ot,
                        Case
                            When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_hhot
                        End                                                                      As hrd_approved_hhot,
                        Case
                            When nvl(a.hrd_apprd_co, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_co
                        End                                                                      As hrd_approved_co,
                        Case
                            When nvl(a.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
                                And nvl(a.hod_apprl, ss.pending) = ss.pending
                            Then
                                1
                            Else
                                0
                        End                                                                      can_delete_claim,
                        Row_Number() Over (Order By app_date Desc)                               row_number,
                        Count(*) Over ()                                                         total_row

                    From
                        ss_otmaster a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0) In (1, 4))
                        And (nvl(hod_apprl, 0) = 0)
                        And a.empno            = e.empno
                        And a.app_no           = nvl(p_application_id, a.app_no)
                        And a.empno In (
                            Select
                                empno
                            From
                                ss_emplmast
                            Where
                                mngr = Trim(v_empno)
                        )
                        And to_number(a.yyyy || a.mon) >= to_number(to_char(add_months(sysdate, - 24), 'YYYYMM'))
                    Order By a.app_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

        Return c;
    End fn_pending_hod_approval;

    Function fn_pending_hr_approval(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        v_empno              Varchar2(5);
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        e.empno || ' - ' || e.name                                               As employee,
                        a.app_date                                                               As claim_date,
                        a.app_no                                                                 As claim_no,
                        month || '-' || yyyy                                                     As claim_period,
                        a.lead_apprl_empno || ' - ' || get_emp_name(nvl(a.lead_apprl_empno, '')) lead_name,
                        ot                                                                       As claimed_ot,
                        hhot                                                                     As claimed_hhot,
                        co                                                                       As claimed_co,
                        ss.approval_text(nvl(a.lead_apprl, 0))                                   lead_approval_desc,
                        ss.approval_text(nvl(a.hod_apprl, 0))                                    hod_approval_desc,
                        ss.approval_text(nvl(a.hrd_apprl, 0))                                    hrd_approval_desc,
                        a.lead_remarks,
                        a.hod_remarks,
                        a.hrd_remarks,
                        nvl(a.lead_apprd_ot, 0)                                                  As lead_approved_ot,
                        nvl(a.lead_apprd_hhot, 0)                                                As lead_approved_hhot,
                        nvl(a.lead_apprd_co, 0)                                                  As lead_approved_co,
                        nvl(a.hod_apprd_ot, 0)                                                   As hod_approved_ot,
                        nvl(a.hod_apprd_hhot, 0)                                                 As hod_approved_hhot,
                        nvl(a.hod_apprd_co, 0)                                                   As hod_approved_co,
                        Case
                            When nvl(a.hrd_apprd_ot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_ot
                        End                                                                      As hrd_approved_ot,
                        Case
                            When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_hhot
                        End                                                                      As hrd_approved_hhot,
                        Case
                            When nvl(a.hrd_apprd_co, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_co
                        End                                                                      As hrd_approved_co,
                        Case
                            When nvl(a.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
                                And nvl(a.hod_apprl, ss.pending) = ss.pending
                            Then
                                1
                            Else
                                0
                        End                                                                      can_delete_claim,
                        Row_Number() Over (Order By app_date Desc)                               row_number,
                        Count(*) Over ()                                                         total_row

                    From
                        ss_otmaster a,
                        ss_emplmast e
                    Where
                        (nvl(hod_apprl, 0)     = 1)
                        And (nvl(hrd_apprl, 0) = 0)
                        And e.empno            = a.empno
                        And a.app_no           = nvl(p_application_id, a.app_no)
                        And to_number(a.yyyy || a.mon) >= to_number(to_char(add_months(sysdate, - 24), 'YYYYMM'))
                    Order By a.app_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_pending_hr_approval;

End iot_extrahours_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_GUEST_MEET_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_GUEST_MEET_QRY" As

    Function get_guest_attendance(
        p_empno       Varchar2,
        p_start_date  Date Default null,
        p_end_date    Date Default null,
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
                        to_char(ss_guest_register.modified_on, 'dd-Mon-yyyy') As applied_on,
                        ss_guest_register.app_no                              As app_no,
                        to_char(ss_guest_register.meet_date, 'dd-Mon-yyyy')   As meeting_date,
                        to_char(ss_guest_register.meet_date, 'hh:mi AM')      As meeting_time,
                        ss_guest_register.host_name                           As host_name,
                        ss_guest_register.guest_name                          As guest_name,
                        ss_guest_register.guest_co                            As guest_company,
                        ss_guest_register.meet_off                            As meeting_place,
                        ss_guest_register.remarks                             As remarks,
                        Case
                            When trunc(ss_guest_register.meet_date) > trunc(sysdate) Then
                                1
                            Else
                                0
                        End                                                   delete_allowed,
                        Row_Number() Over (Order By ss_guest_register.modified_on Desc) row_number,
                        Count(*) Over ()                             total_row
                    From
                        ss_guest_register
                    Where                           
                        ss_guest_register.modified_by = p_empno 
                         And trunc(ss_guest_register.meet_date) >= nvl(p_start_date, trunc(sysdate))
                        And trunc(ss_guest_register.meet_date) <= nvl(p_end_date, trunc(ss_guest_register.meet_date))                             
                    Order By ss_guest_register.meet_date, ss_guest_register.modified_on
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;

    Function fn_guest_attendance(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default null,
        p_end_date    Date Default null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        c       := get_guest_attendance(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_guest_attendance;

End iot_guest_meet_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_LEAVE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_LEAVE_QRY" As

    Function get_leave_applications(
        p_empno        Varchar2,
        p_req_for_self Varchar2,
        p_start_date   Date     Default Null,
        p_end_date     Date     Default Null,
        p_leave_type   Varchar2 Default Null,
        p_row_number   Number,
        p_page_length  Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        app_date_4_sort,
                        lead,
                        app_no,
                        application_date,
                        start_date,
                        end_date,
                        leave_type,
                        leave_period,
                        lead_approval_desc,
                        hod_approval_desc,
                        hrd_approval_desc,
                        lead_reason,
                        hod_reason,
                        hrd_reason,
                        from_tab,
                        is_pl,
                        can_delete_app,
                        Sum(is_pl) Over (Order By app_date_4_sort Desc)   As pl_total,
                        Case
                            When Sum(is_pl) Over (Order By app_date_4_sort Desc) <= 3
                                And is_pl = 1
                            Then
                                1
                            Else
                                0
                        End                                               As can_edit_pl_app,
                        med_cert_file_name,
                        Row_Number() Over (Order By app_date_4_sort Desc) row_number,
                        Count(*) Over ()                                  total_row

                    From
                        (
                                (
                        Select
                            ss_leaveapp.app_date                             As app_date_4_sort,
                            get_emp_name(ss_leaveapp.lead_apprl_empno)       As lead,
                            ltrim(rtrim(ss_leaveapp.app_no))                 As app_no,
                            to_char(ss_leaveapp.app_date, 'dd-Mon-yyyy')     As application_date,
                            to_char(ss_leaveapp.bdate, 'dd-Mon-yyyy')        As start_date,
                            to_char(ss_leaveapp.edate, 'dd-Mon-yyyy')        As end_date,
                            ss_leaveapp.leavetype                            As leave_type,
                            to_days(ss_leaveapp.leaveperiod)                 As leave_period,
                            ss.approval_text(nvl(ss_leaveapp.lead_apprl, 0)) As lead_approval_desc,
                            ss.approval_text(nvl(ss_leaveapp.hod_apprl, 0))  As hod_approval_desc,
                            ss.approval_text(nvl(ss_leaveapp.hrd_apprl, 0))  As hrd_approval_desc,
                            ss_leaveapp.lead_reason,
                            ss_leaveapp.hodreason                            As hod_reason,
                            ss_leaveapp.hrdreason                            As hrd_reason,
                            '1'                                              As from_tab,
                            Case
                                When nvl(ss_leaveapp.hrd_apprl, 0) = 1
                                    And ss_leaveapp.leavetype      = 'PL'
                                Then
                                    1
                                Else
                                    0
                            End                                              As is_pl,
                            med_cert_file_name                               As med_cert_file_name,
                            Case
                                When p_req_for_self                            = 'OK'
                                    And nvl(ss_leaveapp.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
                                    And nvl(ss_leaveapp.hod_apprl, ss.pending) = ss.pending
                                Then
                                    1
                                Else
                                    0
                            End                                              can_delete_app
                        From
                            ss_leaveapp
                        Where
                            ss_leaveapp.app_no Not Like 'Prev%'
                            And Trim(ss_leaveapp.empno) = p_empno
                            And ss_leaveapp.leavetype   = nvl(p_leave_type, ss_leaveapp.leavetype)
                        )
                        Union
                        (
                        Select
                            a.app_date                                                        As app_date_4_sort,
                            ''                                                                As lead,
                            Trim(a.app_no)                                                    As app_no,
                            to_char(a.app_date, 'dd-Mon-yyyy')                                As application_date,
                            to_char(a.bdate, 'dd-Mon-yyyy')                                   As start_date,
                            to_char(a.edate, 'dd-Mon-yyyy')                                   As end_date,
                            Trim(a.leavetype)                                                 As leave_type,
                            to_days(decode(a.db_cr, 'D', a.leaveperiod * - 1, a.leaveperiod)) As leave_period,
                            'NONE'                                                            As lead_approval_desc,
                            'Approved'                                                        As hod_approval_desc,
                            'Approved'                                                        As hrd_approval_desc,
                            ''                                                                As lead_reason,
                            ''                                                                As hod_reason,
                            ''                                                                As hrd_reason,
                            '2'                                                               As from_tab,
                            0                                                                 As is_pl,
                            Null                                                              As med_cert_file_name,
                            0                                                                 As can_delete
                        From
                            ss_leaveledg a
                        Where
                            a.empno         = lpad(Trim(p_empno), 5, 0)
                            And a.app_no Not Like 'Prev%'
                            And a.leavetype = nvl(p_leave_type, a.leavetype)
                            And ltrim(rtrim(a.app_no)) Not In
                            (
                                Select
                                    ss_leaveapp.app_no
                                From
                                    ss_leaveapp
                                Where
                                    ss_leaveapp.empno = p_empno
                            )
                        )
                        )
                    Where
                        start_date >= add_months(sysdate, - 24)
                    Order By app_date_4_sort Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;

    Function get_leave_ledger(
        p_empno       Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c            Sys_Refcursor;
        v_start_date Date;
        v_end_date   Date;
    Begin
        If p_start_date Is Null Then
            v_start_date := trunc(nvl(p_start_date, sysdate), 'YEAR');
            v_end_date   := add_months(trunc(nvl(p_end_date, sysdate), 'YEAR'), 12) - 1;
        Else
            v_start_date := trunc(p_start_date);
            v_end_date   := trunc(p_end_date);
        End If;
        Open c For
            Select
                app_no,
                app_date As application_date,
                leave_type,
                description,
                b_date   start_date,
                e_date   end_date,
                no_of_days_db,
                no_of_days_cr,
                row_number,
                total_row
            From
                (
                    Select
                        app_no,
                        app_date,
                        leavetype                              leave_type,
                        description,
                        dispbdate                              b_date,
                        dispedate                              e_date,
                        to_days(dbday)                         no_of_days_db,
                        to_days(crday)                         no_of_days_cr,
                        Row_Number() Over (Order By dispbdate) row_number,
                        Count(*) Over ()                       total_row
                    From
                        ss_displedg
                    Where
                        empno = p_empno
                        And dispbdate Between v_start_date And v_end_date
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End get_leave_ledger;

    Function fn_leave_ledger_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        c       := get_leave_ledger(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_leave_ledger_4_self;

    Function fn_leave_ledger_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
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
        c := get_leave_ledger(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_leave_ledger_4_other;

    Function fn_leave_applications_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_leave_type  Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_self_empno         Varchar2(5);
        v_req_for_self       Varchar2(2);
        v_for_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_self_empno := get_empno_from_person_id(p_person_id);
        If v_self_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Select
            empno
        Into
            v_for_empno
        From
            ss_emplmast
        Where
            empno      = p_empno
            And status = 1;
        If v_self_empno = v_for_empno Then
            v_req_for_self := 'OK';
        Else
            v_req_for_self := 'KO';
        End If;
        c            := get_leave_applications(v_for_empno, v_req_for_self, p_start_date, p_end_date, p_leave_type, p_row_number,
                                               p_page_length);
        Return c;
    End fn_leave_applications_4_other;

    Function fn_leave_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_leave_type  Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        c       := get_leave_applications(v_empno, 'OK', p_start_date, p_end_date, p_leave_type, p_row_number, p_page_length);
        Return c;
    End fn_leave_applications_4_self;

    Function fn_pending_hod_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_hod_empno := get_empno_from_person_id(p_person_id);
        If v_hod_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        l.empno || ' - ' || e.name                   As employee_name,
                        parent,
                        app_date                                     As application_date,
                        app_no                                       As application_id,
                        bdate                                        As start_date,
                        edate                                        As end_date,
                        to_days(leaveperiod)                         As leave_period,
                        leavetype                                    As leave_type,
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_remarks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row

                    From
                        ss_leaveapp                l, ss_emplmast e
                    Where
                        (nvl(hod_apprl, ss.pending) = ss.pending)
                        And l.empno                 = e.empno
                        And e.status                = 1
                        And nvl(lead_apprl, ss.pending) In (ss.approved, ss.apprl_none)
                        And l.empno In (
                            Select
                                empno
                            From
                                ss_emplmast
                            Where
                                mngr = Trim(v_hod_empno)
                        )
                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_hod_approval;

    Function fn_pending_hr_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hr_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        /*
            v_hr_empno := get_empno_from_person_id(p_person_id);
            If v_hr_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;
        */
        Open c For
            Select
                *
            From
                (
                    Select
                        l.empno || ' - ' || e.name                   As employee_name,
                        parent,
                        app_date                                     As application_date,
                        app_no                                       As application_id,
                        bdate                                        As start_date,
                        edate                                        As end_date,
                        to_days(leaveperiod)                         As leave_period,
                        leavetype                                    As leave_type,
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_marks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row

                    From
                        ss_leaveapp                l, ss_emplmast e
                    Where
                        l.empno                          = e.empno
                        And nvl(l.hod_apprl, ss.pending) = ss.approved
                        And nvl(l.hrd_apprl, ss.pending) = ss.pending
                        And e.status                     = 1
                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_hr_approval;

    Function fn_pending_lead_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_lead_empno         Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_lead_empno := get_empno_from_person_id(p_person_id);
        If v_lead_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        l.empno || ' - ' || e.name                   As employee_name,
                        parent,
                        app_date                                     As application_date,
                        app_no                                       As application_id,
                        bdate                                        As start_date,
                        edate                                        As end_date,
                        to_days(leaveperiod)                         As leave_period,
                        leavetype                                    As leave_type,
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_marks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row
                    From
                        ss_leaveapp                l, ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0)    = 0)
                        And l.empno            = e.empno
                        And e.status           = 1
                        And l.lead_apprl_empno = Trim(v_lead_empno)
                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_pending_lead_approval;

End iot_leave_qry;
/
---------------------------
--New PACKAGE BODY
--IOT_HOLIDAY_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_HOLIDAY_QRY" As

    Function get_holiday_attendance(
        p_empno       Varchar2,
        p_start_date  Date,
        p_end_date    Date,
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
                            to_char(app_date, 'dd-Mon-yyyy') As applied_on,
                            a.app_no                         As app_no,
                            a.description                    As description,
                            get_emp_name(lead_apprl_empno)   As lead_name,
                            a.lead_apprldesc                 As lead_approval,
                            a.hod_apprldesc                  As hod_approval,
                            a.hrd_apprldesc                  As hr_approval,
                            a.lead_reason                    As lead_remarks,
                            a.pdate                          As holiday_attendance_date,
                            Case 
                                When (a.pdate < sysdate) or ( a.hod_apprl > 0) Then
                                    1                                   
                                Else
                                    0
                            End                              delete_allowed ,
                             Row_Number() Over (Order By app_date Desc) row_number,
                            Count(*) Over ()                             total_row
                        From
                            ss_ha_app_stat a  
                        Where
                        empno = p_empno
                        And a.app_date >= nvl(p_start_date, add_months(sysdate, - 3))
                        And trunc(a.app_date) <= nvl(p_end_date, trunc(a.app_date))
                         -- empno = p_empno And a.app_date >= add_months(sysdate, - 3)
                        Order By pdate Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;

    Function fn_holiday_attendance(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default null,
        p_end_date    Date Default null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        c       := get_holiday_attendance(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_holiday_attendance;

    --  GRANT EXECUTE ON "IOT_HOLIDAY_QRY" TO "TCMPL_APP_CONFIG";

End iot_holiday_qry;
/
---------------------------
--New PACKAGE BODY
--IOT_EXTRAHOURS
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_EXTRAHOURS" As

    Procedure sp_create_claim(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_yyyymm                Varchar2,
        p_lead_approver         Varchar2,
        p_selected_compoff_days typ_tab_string,
        p_weekend_totals        typ_tab_string,
        p_sum_compoff_hrs       Number,
        p_sum_weekday_extra_hrs Number,
        p_sum_holiday_extra_hrs Number,
        p_message_type Out      Varchar2,
        p_message_text Out      Varchar2
    ) As
        v_app_no                Varchar2(13);
        v_empno                 Varchar2(5);
        e_employee_not_found    Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_yyyymm_date           Date;
        v_app_mm                Varchar2(2);
        v_app_yyyy              Varchar2(4);
        v_lead_apprl            Number;
        v_lead_apprd_ot         Number;
        v_lead_apprd_hhot       Number;
        v_lead_apprd_co         Number;
        v_lead_apprl_empno      Varchar2(5);
        v_day_date              Date;
        v_co_day                Number;
        v_pos                   Number;
        v_prev_pos              Number;
        v_week_claim_co         Number;
        v_week_claim_othh       Number;
        v_week_claim_otwrk      Number;
        v_week_applicable_otwrk Number;
        v_week_applicable_othh  Number;

    Begin
        v_empno            := get_empno_from_person_id(p_person_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;
        v_yyyymm_date      := to_date(p_yyyymm, 'yyyymm');
        v_app_mm           := substr(p_yyyymm, 5, 2);
        v_app_yyyy         := substr(p_yyyymm, 1, 4);
        v_app_no           := v_empno || '_' || v_app_mm || '_' || v_app_yyyy;
        If nvl(p_sum_compoff_hrs, 0) = 0 And nvl(p_sum_weekday_extra_hrs, 0) = 0 And nvl(p_sum_holiday_extra_hrs, 0) = 0 Then
            p_message_type := 'KO';
            p_message_text := 'CompOff/Extrahours not claimed. Cannot create claim.';
            Return;
        End If;
        v_lead_apprl_empno := upper(trim(p_lead_approver));
        If v_lead_apprl_empno = 'NONE' Then
            v_lead_apprl      := 4;
            v_lead_apprd_ot   := 0;
            v_lead_apprd_hhot := 0;
            v_lead_apprd_co   := 0;
        End If;
        Insert Into ss_otmaster (
            app_no,
            app_date,
            empno,
            mon,
            yyyy,
            month,
            ot,
            hhot,
            co,
            lead_apprl_empno,
            lead_apprl,
            lead_apprd_ot,
            lead_apprd_hhot,
            lead_apprd_co,
            hod_apprl,
            hrd_apprl
        )
        Values(
            v_app_no,
            sysdate,
            v_empno,
            v_app_mm,
            v_app_yyyy,
            to_char(v_yyyymm_date, 'Mon'),
            p_sum_weekday_extra_hrs,
            p_sum_holiday_extra_hrs,
            p_sum_compoff_hrs,
            v_lead_apprl_empno,
            v_lead_apprl,
            v_lead_apprd_ot,
            v_lead_apprd_hhot,
            v_lead_apprd_co,
            0,
            0
        );

        Insert Into ss_otdetail(
            empno,
            mon,
            yyyy,
            day,
            d_details,
            w_details,
            of_mon,
            app_no,
            wk_of_year,
            day_yyyy
        )
        Select
            v_empno,
            v_app_mm,
            v_app_yyyy,
            dd,
            to_char(punch_date, 'dd-Mon-yyyy') || ';' ||
            ddd || ';' ||
            shift_code || ';' ||
            first_punch || ';' ||
            last_punch || ';' ||
            wrk_hrs || ';' ||
            delta_hrs || ';' ||
            extra_hrs || ';' ||
            remarks d_details,
            Case
                When is_sunday = 2 Then
                    wk_sum_work_hrs || ';' || wk_bfwd_delta_hrs || ';' || wk_cfwd_delta_hrs || ';' || wk_penalty_leave_hrs ||
                    ';' || wk_sum_delta_hrs || ';'
                Else
                    ''
            End     w_details,
            to_char(punch_date, 'mm'),
            v_app_no,
            wk_of_year,
            to_char(punch_date, 'yyyy')
        From
            Table(iot_punch_details.fn_punch_details_4_self(
                    p_person_id => p_person_id,
                    p_meta_id   => Null,
                    p_empno     => v_empno,
                    p_yyyymm    => p_yyyymm,
                    p_for_ot    => 'OK')
            );
        --p_message_type     := 'OK';
        --Return;
        For i In 1..p_selected_compoff_days.count

        Loop
            With
                csv As (
                    Select
                        p_selected_compoff_days(i) str
                    From
                        dual
                )
            Select
                to_date(regexp_substr(str, '[^,]+', 1, 1), 'dd-Mon-yyyy') c1,
                to_number(regexp_substr(str, '[^,]+', 1, 2))              c2
            Into
                v_day_date, v_pos
            From
                csv;
            Update
                ss_otdetail
            Set
                co_bool = 1
            Where
                app_no       = v_app_no
                And day_yyyy = to_char(v_day_date, 'yyyy')
                And of_mon   = to_char(v_day_date, 'mm')
                And day      = to_number(to_char(v_day_date, 'dd'));

        End Loop;
        /*
                p_message_type     := 'OK';
                Return;
        */
        For i In 1..p_weekend_totals.count
        Loop
            With
                csv As (
                    Select
                        p_weekend_totals(i) str
                    From
                        dual
                )
            Select
                to_date(regexp_substr(str, '[^,]+', 1, 1), 'dd-Mon-yyyy') c1,
                to_number(regexp_substr(str, '[^,]+', 1, 2))              c2,
                to_number(regexp_substr(str, '[^,]+', 1, 3))              c3,
                to_number(regexp_substr(str, '[^,]+', 1, 4))              c4,
                to_number(regexp_substr(str, '[^,]+', 1, 5))              c5,
                to_number(regexp_substr(str, '[^,]+', 1, 6))              c6
            Into
                v_day_date,
                v_week_claim_co,
                v_week_applicable_othh,
                v_week_claim_othh,
                v_week_applicable_otwrk,
                v_week_claim_otwrk
            From
                csv;
            Update
                ss_otdetail
            Set
                w_co = v_week_claim_co,
                w_ot_max = v_week_applicable_otwrk,
                w_ot_claim = v_week_claim_otwrk,
                w_hhot_max = v_week_applicable_othh,
                w_hhot_claim = v_week_claim_othh
            Where
                app_no       = v_app_no
                And day_yyyy = to_char(v_day_date, 'yyyy')
                And of_mon   = to_char(v_day_date, 'mm')
                And day      = to_number(to_char(v_day_date, 'dd'));
        End Loop;

        p_message_type     := 'OK';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_create_claim;

    Procedure sp_delete_claim(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_claim_no         Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin

        v_empno        := get_empno_from_person_id(p_person_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;
        Delete
            From ss_otdetail
        Where
            app_no = p_claim_no;
        Delete
            From ss_otmaster
        Where
            app_no = p_claim_no;
        Commit;
        p_message_type := 'OK';
        p_message_text := 'Claim deleted successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_claim;

    Procedure sp_extra_hrs_adjst_details(
        p_application_id         Varchar2,
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_emp_name           Out Varchar2,
        p_claim_no           Out Varchar2,

        p_claimed_ot         Out Varchar2,
        p_claimed_hhot       Out Varchar2,
        p_claimed_co         Out Varchar2,

        p_lead_approved_ot   Out Varchar2,
        p_lead_approved_hhot Out Varchar2,
        p_lead_approved_co   Out Varchar2,

        p_hod_approved_ot    Out Varchar2,
        p_hod_approved_hhot  Out Varchar2,
        p_hod_approved_co    Out Varchar2,

        p_hr_approved_ot     Out Varchar2,
        p_hr_approved_hhot   Out Varchar2,
        p_hr_approved_co     Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As

        v_onduty_app ss_ondutyapp%rowtype;
        v_depu       ss_depu%rowtype;
        v_empno      Varchar2(5);
        v_count      Number;

    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_otmaster
        Where
            Trim(app_no) = Trim(p_application_id);

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;

        Select
            e.empno || ' - ' || e.name,
            a.app_no,
            nvl(a.ot / 60, 0),
            nvl(a.hhot / 60, 0),
            nvl(a.co / 60, 0),
            nvl(a.lead_apprd_ot / 60, 0),
            nvl(a.lead_apprd_hhot, 0),
            nvl(a.lead_apprd_co, 0),
            nvl(a.hod_apprd_ot, 0),
            nvl(a.hod_apprd_hhot, 0),
            nvl(a.hod_apprd_co, 0),
            Case
                When nvl(a.hrd_apprd_ot, 0) = 0 Then
                    Null
                Else
                    a.hrd_apprd_ot
            End,
            Case
                When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                    Null
                Else
                    a.hrd_apprd_hhot
            End,
            Case
                When nvl(a.hrd_apprd_co, 0) = 0 Then
                    Null
                Else
                    a.hrd_apprd_co
            End
        Into
            p_emp_name,
            p_claim_no,
            p_claimed_ot,
            p_claimed_hhot,
            p_claimed_co,
            p_lead_approved_ot,
            p_lead_approved_hhot,
            p_lead_approved_co,
            p_hod_approved_ot,
            p_hod_approved_hhot,
            p_hod_approved_co,
            p_hr_approved_ot,
            p_hr_approved_hhot,
            p_hr_approved_co
        From
            ss_otmaster a,
            ss_emplmast e
        Where
            a.empno      = e.empno
            And a.app_no = p_application_id;

        p_message_type := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_extra_hrs_adjst_details;

    Procedure sp_claim_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_approvals  typ_tab_string,
        p_approver_profile Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_app_no         Varchar2(70);
        v_approval       Number;
        v_remarks        Varchar2(70);
        v_count          Number;
        v_rec_count      Number;
        sqlpart1         Varchar2(60) := 'Update SS_OTMaster ';
        sqlpart2         Varchar2(500);
        sqlpart3         Varchar2(500);
        strsql           Varchar2(1000);
        v_otmaster_rec   ss_otmaster%rowtype;
        v_approver_empno Varchar2(5);
        v_user_tcp_ip    Varchar2(30);
        v_msg_type       Number;
        v_msg_text       Varchar2(1000);
    Begin

        v_approver_empno := get_empno_from_person_id(p_person_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sqlpart3         := ' ';
        sqlpart2         := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfile_Remarks = :Remarks ';
        If p_approver_profile = user_profile.type_hod Or p_approver_profile = user_profile.type_sec Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HOD');

            sqlpart3 := sqlpart3 || ', HOD_Apprd_OT = Lead_Apprd_OT, ';
            sqlpart3 := sqlpart3 || 'HOD_Apprd_HHOT = Lead_Apprd_HHOT, ';
            sqlpart3 := sqlpart3 || 'HOD_Apprd_CO = Lead_Apprd_CO ';
        Elsif p_approver_profile = user_profile.type_hrd Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HRD');

            sqlpart3 := sqlpart3 || ', HRD_Apprd_OT = HOD_Apprd_OT, ';
            sqlpart3 := sqlpart3 || 'HRD_Apprd_HHOT = HOD_Apprd_HHOT, ';
            sqlpart3 := sqlpart3 || 'HRD_Apprd_CO = HOD_Apprd_CO ';
        Elsif p_approver_profile = user_profile.type_lead Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'LEAD');

            sqlpart3 := sqlpart3 || ', Lead_Apprd_OT = OT, ';
            sqlpart3 := sqlpart3 || 'Lead_Apprd_HHOT = HHOT, ';
            sqlpart3 := sqlpart3 || 'Lead_Apprd_CO = CO ';
        End If;

        For i In 1..p_claim_approvals.count
        Loop

            With
                csv As (
                    Select
                        p_claim_approvals(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))            app_no,
                to_number(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) approval
            Into
                v_app_no, v_approval
            From
                csv;

            /*
            p_message_type := 'OK';
            p_message_text := 'Debug 1 - ' || p_leave_approvals(i);
            Return;
            */
            strsql := sqlpart1 || ' ' || sqlpart2;

            If v_approval = ss.approved Then
                strsql := strsql || ' ' || sqlpart3;
            End If;
            strsql := strsql || '  Where App_No = :p_app_no';
            /*
            p_message_type := 'OK';
            p_message_text := 'Debug - ' || v_approval || ' - ' || strsql;
            Return;
            */
            Execute Immediate strsql
                Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, trim(v_app_no);

            If p_approver_profile = user_profile.type_hrd And v_approval = ss.approved Then
                Select
                    *
                Into
                    v_otmaster_rec
                From
                    ss_otmaster
                Where
                    app_no = v_app_no;

                If nvl(v_otmaster_rec.hrd_apprd_co, 0) > 0 Then
                    Insert Into ss_leaveledg(
                        app_no,
                        app_date,
                        leavetype,
                        description,
                        empno,
                        leaveperiod,
                        db_cr,
                        bdate,
                        adj_type
                    )
                    Values(
                        v_app_no,
                        sysdate,
                        'CO',
                        'Compensatory Off Credit',
                        v_otmaster_rec.empno,
                        v_otmaster_rec.hrd_apprd_co / 60,
                        'C',
                        to_date(v_otmaster_rec.yyyy || v_otmaster_rec.mon, 'yyyymm'),
                        'CO'

                    );

                End If;
            End If;

        End Loop;

        Commit;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_claim_approval;

    Procedure sp_claim_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin

        sp_claim_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_approvals  => p_claim_approvals,
            p_approver_profile => user_profile.type_lead,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_claim_approval_lead;

    Procedure sp_claim_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_claim_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_approvals  => p_claim_approvals,
            p_approver_profile => user_profile.type_hod,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_claim_approval_hod;

    Procedure sp_claim_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_claim_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_approvals  => p_claim_approvals,
            p_approver_profile => user_profile.type_hod,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_claim_approval_hr;

    Procedure sp_claim_adjustment(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_no         Varchar2,
        p_approved_ot      Number,
        p_approved_hhot    Number,
        p_approved_co      Number,
        p_approver_profile Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_app_no         Varchar2(70);
        v_approval       Number;
        v_remarks        Varchar2(70);
        v_count          Number;
        v_rec_count      Number;
        sqlpart1         Varchar2(60) := 'Update SS_OTMaster ';
        sqlpart2         Varchar2(500);
        sqlpart3         Varchar2(500);
        strsql           Varchar2(1000);
        v_otmaster_rec   ss_otmaster%rowtype;
        v_approver_empno Varchar2(5);
        v_user_tcp_ip    Varchar2(30);
        v_msg_type       Number;
        v_msg_text       Varchar2(1000);
    Begin
        v_approver_empno := get_empno_from_person_id(p_person_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        v_app_no         := trim(p_claim_no);
        v_approval       := ss.approved;
        sqlpart2         := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfile_Remarks = :Remarks ';
        sqlpart3         := ', ';
        sqlpart3         := sqlpart3 || ' ApproverProfile_Apprd_OT = :Apprd_OT, ';
        sqlpart3         := sqlpart3 || ' ApproverProfile_Apprd_HHOT = :Apprd_HHOT, ';
        sqlpart3         := sqlpart3 || ' ApproverProfile_Apprd_CO = :Apprd_CO ';

        strsql           := sqlpart1 || sqlpart2 || sqlpart3 || '  Where trim(App_No) = trim(:p_app_no)';

        If p_approver_profile = user_profile.type_hod Or p_approver_profile = user_profile.type_sec Then
            strsql := replace(strsql, 'ApproverProfile', 'HOD');

        Elsif p_approver_profile = user_profile.type_hrd Then
            strsql := replace(strsql, 'ApproverProfile', 'HRD');

        Elsif p_approver_profile = user_profile.type_lead Then
            strsql := replace(strsql, 'ApproverProfile', 'LEAD');

        End If;
        /*
        p_message_type   := 'OK';
        p_message_text   := strsql;
        return;
        */
        Execute Immediate strsql
            Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, p_approved_ot, p_approved_hhot, p_approved_co, trim(
            v_app_no);
        If p_approver_profile = user_profile.type_hrd And v_approval = ss.approved Then
            Select
                *
            Into
                v_otmaster_rec
            From
                ss_otmaster
            Where
                app_no = v_app_no;

            If nvl(v_otmaster_rec.hrd_apprd_co, 0) > 0 Then
                Insert Into ss_leaveledg(
                    app_no,
                    app_date,
                    leavetype,
                    description,
                    empno,
                    leaveperiod,
                    db_cr,
                    bdate,
                    adj_type
                )
                Values(
                    v_app_no,
                    sysdate,
                    'CO',
                    'Compensatory Off Credit',
                    v_otmaster_rec.empno,
                    v_otmaster_rec.hrd_apprd_co / 60,
                    'C',
                    to_date(v_otmaster_rec.yyyy || v_otmaster_rec.mon, 'yyyymm'),
                    'CO'

                );

            End If;
        End If;

        Commit;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_claim_adjustment_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_no         Varchar2,
        p_approved_ot      Number,
        p_approved_hhot    Number,
        p_approved_co      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_claim_adjustment(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_no         => p_claim_no,
            p_approved_ot      => p_approved_ot,
            p_approved_hhot    => p_approved_hhot,
            p_approved_co      => p_approved_co,
            p_approver_profile => user_profile.type_lead,

            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_claim_adjustment_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_no         Varchar2,
        p_approved_ot      Number,
        p_approved_hhot    Number,
        p_approved_co      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_claim_adjustment(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_no         => p_claim_no,
            p_approved_ot      => p_approved_ot,
            p_approved_hhot    => p_approved_hhot,
            p_approved_co      => p_approved_co,
            p_approver_profile => user_profile.type_hod,

            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_claim_adjustment_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_no         Varchar2,
        p_approved_ot      Number,
        p_approved_hhot    Number,
        p_approved_co      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_claim_adjustment(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_no         => p_claim_no,
            p_approved_ot      => p_approved_ot,
            p_approved_hhot    => p_approved_hhot,
            p_approved_co      => p_approved_co,
            p_approver_profile => user_profile.type_hrd,

            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

End iot_extrahours;
/
---------------------------
--Changed FUNCTION
--GET_EMPNO_FROM_PERSON_ID
---------------------------
CREATE OR REPLACE FUNCTION "GET_EMPNO_FROM_PERSON_ID" (
    p_person_id In Varchar2
) Return Varchar2 As
    v_empno     Varchar2(5);
    v_person_id Varchar2(10);
    v_host_name Varchar2(100);
    c_dev_env   Constant Varchar2(100) := 'tpldevoradb';
Begin
    v_person_id := trim(substr(p_person_id, 2));

    Select
        empno
    Into
        v_empno
    From
        ss_emplmast
    Where
        Trim(personid) In (Trim(p_person_id), v_person_id)
        And status = 1;

    Select
        sys_context('USERENV', 'SERVER_HOST')
    Into
        v_host_name
    From
        dual;
    If v_host_name = c_dev_env Then
        If v_empno = '02320' Then
            null;
            --v_empno := '02640';
            --v_empno := '02766';
            --v_empno := '01412';
            --v_empno := '04170';
            --v_empno := '10646';
            v_empno := '03150';
        End If;
    End If;
    Return v_empno;
Exception
    When Others Then
        Return 'ERRRR';
End get_empno_from_person_id;
/
