--------------------------------------------------------
--  File created - Sunday-October-03-2021   
--------------------------------------------------------
---------------------------
--Changed TYPE
--TYP_ROW_PUNCH_DATA
---------------------------
drop type TYP_ROW_PUNCH_DATA force;
CREATE OR REPLACE TYPE "TYP_ROW_PUNCH_DATA" As Object(
    empno                    Char(5),
    dd                       Varchar2(2),
    ddd                      Varchar2(3),
    punch_date               Date,
    shift_code               Varchar2(2),
    wk_of_year               Varchar2(2),
    first_punch              Varchar2(10),
    last_punch               Varchar2(10),
    penalty_hrs              Number,
    is_odd_punch             Number,
    is_ldt                   Number,
    is_sunday                Number,
    is_lwd                   Number,
    is_lc_app                Number,
    is_sleave_app            Number,
    is_absent                Number,
    sl_app_cntr              Number,
    ego                      Number,
    wrk_hrs                  Number,
    delta_hrs                Number,
    extra_hrs                Number,
    last_day_cfwd_dhrs       Number,
    wk_sum_work_hrs          Number,
    wk_sum_delta_hrs         Number,
    wk_bfwd_delta_hrs        Number,
    wk_cfwd_delta_hrs        Number,
    wk_penalty_leave_hrs     Number,
    day_punch_count          Number,
    remarks                  Varchar2(100),
    str_wrk_hrs              Varchar2(6),
    str_delta_hrs            Varchar2(6),
    str_extra_hrs            Varchar2(6),
    str_wk_sum_work_hrs      Varchar2(6),
    str_wk_sum_delta_hrs     Varchar2(6),
    str_wk_bfwd_delta_hrs    Varchar2(6),
    str_wk_cfwd_delta_hrs    Varchar2(6),
    str_wk_penalty_leave_hrs Varchar2(6)
);
/
---------------------------
--Changed TABLE
--SS_ONDUTYMAST
---------------------------
ALTER TABLE "SS_ONDUTYMAST" ADD ("GROUP_NO" NUMBER(2,0));

---------------------------
--New INDEX
--SS_HSESUGG_PK
---------------------------
  CREATE UNIQUE INDEX "SS_HSESUGG_PK" ON "SS_HSESUGG" ("SUGGNO");
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

End iot_select_list_qry;
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
                is_absent,
                slappcntr,
                ego,
                wrkhrs,
                deltahrs,
                extra_hours,
                last_day_cfwd_dhrs,
                Sum(wrkhrs) Over (Partition By wk_of_year),
                Sum(deltahrs) Over (Partition By wk_of_year),
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
            substr(b.office, 3, 1)                      office
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
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_leave_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date   Default Null,
        p_end_date    Date   Default Null,
        p_row_number  Number := 0,
        p_page_length Number := 15
    ) Return Sys_Refcursor;

    Function fn_leave_applications_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

End iot_leave_qry;
/
---------------------------
--Changed PACKAGE
--IOT_LEAVE
---------------------------
CREATE OR REPLACE PACKAGE "IOT_LEAVE" As 

    /* TODO enter package declarations (types, exceptions, methods etc) here */
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
        p_med_cert_available     Varchar2,
        p_contact_address        Varchar2,
        p_contact_std            Varchar2,
        p_contact_phone          Varchar2,
        p_office                 Varchar2,
        p_lead_empno             Varchar2,
        p_discrepancy            Varchar2,
        p_med_cert_file_nm       Varchar2,

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

    Procedure sp_delete_leave_app_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_leave_balances_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
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
End iot_leave;
/
---------------------------
--New PACKAGE
--IOT_HSE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "IOT_HSE_QRY" AS 

    Function fn_hse_suggestion(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;
    
    Function fn_hse_suggestion_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;
    
END IOT_HSE_QRY;
/
---------------------------
--New PACKAGE
--IOT_HSE
---------------------------
CREATE OR REPLACE PACKAGE "IOT_HSE" AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 

END IOT_HSE;
/
---------------------------
--New PACKAGE
--IOT_GUEST_MEET_QRY
---------------------------
CREATE OR REPLACE PACKAGE "IOT_GUEST_MEET_QRY" AS 

  Function fn_guest_attendance(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    
END IOT_GUEST_MEET_QRY;
/
---------------------------
--New PACKAGE
--IOT_GUEST_MEET
---------------------------
CREATE OR REPLACE PACKAGE "IOT_GUEST_MEET" AS 

  Procedure sp_add_meet(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

		P_guest_name       Varchar2,
		P_guest_company    Varchar2,
        p_hh1              Varchar2,
        p_mi1              Varchar2,
        p_date             Date,
        P_office           Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );
    
     Procedure sp_delete_meet(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );
    
END iot_guest_meet;
/
---------------------------
--New PACKAGE
--IOT_EMPLMAST
---------------------------
CREATE OR REPLACE PACKAGE "IOT_EMPLMAST" As

    Procedure employee_list_dept(p_dept             Varchar2,
                                 p_out_emp_list Out Sys_Refcursor);

    Procedure employee_details(p_empno        Varchar2,
                               p_name     Out Varchar2,
                               p_parent   Out Varchar2,
                               p_metaid   Out Varchar2,
                               p_personid Out Varchar2,
                               p_success  Out Varchar2,
                               p_message  Out Varchar2
    );
    Procedure employee_details_ref_cur(p_empno               Varchar2,
                                       p_out_emp_details Out Sys_Refcursor);

    Function fn_employee_details_ref(p_empno Varchar2
    ) Return Sys_Refcursor;

    Function fn_employee_list_ref(p_dept Varchar2) Return Sys_Refcursor;
End iot_emplmast;
/
---------------------------
--Changed PACKAGE BODY
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
--New PACKAGE BODY
--IOT_EMPLMAST
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_EMPLMAST" As

    Procedure employee_list_dept(p_dept             Varchar2,
                                 p_out_emp_list Out Sys_Refcursor) As
    Begin

        Open p_out_emp_list For
            Select
                empno, name, parent, assign
            From
                ss_emplmast
            Where
                status     = 1
                And parent = p_dept;
    End employee_list_dept;

    Procedure employee_details(p_empno        Varchar2,
                               p_name     Out Varchar2,
                               p_parent   Out Varchar2,
                               p_metaid   Out Varchar2,
                               p_personid Out Varchar2,
                               p_success  Out Varchar2,
                               p_message  Out Varchar2
    ) As
    Begin
        Select
            name, parent, metaid, personid
        Into
            p_name, p_parent, p_metaid, p_personid
        From
            ss_emplmast
        Where
            empno = p_empno;
        p_success := 'OK';
        p_message := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End employee_details;

    Procedure employee_details_ref_cur(p_empno               Varchar2,
                                       p_out_emp_details Out Sys_Refcursor) As
    Begin
        Open p_out_emp_details For
            Select
                name, parent, metaid, personid
            From
                ss_emplmast
            Where
                empno = p_empno;
    End;
    /*
        Function fn_employee_details_ref(p_empno         Varchar2,
                                         p_rownum In Out Number) Return Sys_Refcursor
        As
            c Sys_Refcursor;
        Begin
            Open c For
                Select
                    name, parent, metaid, personid, p_rownum
                From
                    ss_emplmast
                Where
                    empno = p_empno;
            p_rownum := -1;
            Return c;
        End;
    */
    Function fn_employee_details_ref(p_empno Varchar2) Return Sys_Refcursor
    As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                name, parent, metaid, personid
            From
                ss_emplmast
            Where
                empno = p_empno;

        Return c;
    End;

    Function fn_employee_list_ref(p_dept Varchar2) Return Sys_Refcursor
    As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                empno, name, parent, metaid, personid
            From
                ss_emplmast
            Where
            status=1;
                --parent     = p_dept
                --And status = 1;
        --p_rownum := -1;
        Return c;
    End;
End iot_emplmast;
/
---------------------------
--Changed PACKAGE BODY
--IOT_LEAVE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_LEAVE_QRY" As

    Function get_leave_applications(
        p_empno       Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
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
                                When nvl(ss_leaveapp.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
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
                            a.empno = lpad(Trim(p_empno), 5, 0)
                            And a.app_no Not Like 'Prev%'
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
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
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
        c := get_leave_applications(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_leave_applications_4_other;

    Function fn_leave_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date,
        p_end_date    Date,
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
        c       := get_leave_applications(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_leave_applications_4_self;

End iot_leave_qry;
/
---------------------------
--New PACKAGE BODY
--IOT_GUEST_MEET
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_GUEST_MEET" AS

    Procedure sp_add_meet(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

		P_guest_name       Varchar2,
		P_guest_company    Varchar2,
        p_hh1              Varchar2,
        p_mi1              Varchar2,
        p_date             Date,
        P_office           Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno         Varchar2(5);
        v_emp_name      Varchar2(60);
        v_count         Number;
        v_lead_approval Number := 0;
        v_hod_approval  Number := 0;
        v_desc          Varchar2(60);
        v_message_type  Number := 0;
    Begin
        v_empno    := get_empno_from_person_id(p_person_id);
        
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        v_emp_name := get_emp_name(v_empno);

        meet.add_meet(
            param_host_name		=> v_emp_name,
            param_guest_name	=> P_guest_name,
            param_guest_co		=> P_guest_company,
            param_meet_date		=> to_char(p_date, 'dd/mm/yyyy'),
            param_meet_hh		=> to_number(Trim(p_hh1)),
            param_meet_mn		=> to_number(Trim(p_mi1)),
            param_meet_off		=> Trim(P_office),
            param_remarks		=> p_reason,
            param_modified_by	=> v_empno,
            param_success		=> v_message_type,
            param_msg			=> p_message_text
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
    End sp_add_meet;
    
    Procedure sp_delete_meet(
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
            ss_guest_register
        Where
            Trim(app_no) = Trim(p_application_id)
            And modified_by    = v_empno;
        
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
		
        meet.del_meet(paramappno   => p_application_id);
		
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_meet;
 
END iot_guest_meet;
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

        p_cl := nvl(trim(p_cl),'0.0');
        p_pl := nvl(trim(p_pl),'0.0');
        p_sl := nvl(trim(p_sl),'0.0');
        p_ex := nvl(trim(p_ex),'0.0');
        p_co := nvl(trim(p_co),'0.0');
        p_oh := nvl(trim(p_oh),'0.0');
        p_lv := nvl(trim(p_lv),'0.0');

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
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
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
        p_med_cert_available     Varchar2,
        p_contact_address        Varchar2,
        p_contact_std            Varchar2,
        p_contact_phone          Varchar2,
        p_office                 Varchar2,
        p_lead_empno             Varchar2,
        p_discrepancy            Varchar2,
        p_med_cert_file_nm       Varchar2,

        p_new_application_id Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As
        v_empno        Varchar2(5);
        v_message_type Number;
    Begin

        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
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

    Procedure sp_delete_leave_app_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count Number;
        v_empno Varchar2(5);
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

        deleteleave(trim(p_application_id));
        p_message_type := 'OK';
        p_message_text := 'Application deleted successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_leave_balances_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
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
        v_empno Varchar2(5);
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
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
End iot_leave;
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

End iot_select_list_qry;
/
---------------------------
--New PACKAGE BODY
--IOT_HSE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_HSE_QRY" AS


    Function get_hse_suggestion(
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
                        sysdate,
                        Row_Number() Over (Order By sysdate ) row_number,
                        Count(*) Over ()                                  total_row
                    From
                        (
                             select sysdate from dual
                        )
                 --   Where
                 --       start_date >= add_months(sysdate, - 24)
                 --   Order By app_date_4_sort Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End;    

    Function get_hse_suggestion_desk(
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
                        sysdate,
                        Row_Number() Over (Order By sysdate ) row_number,
                        Count(*) Over ()                                  total_row
                    From
                        (
                             select sysdate from dual
                        )
                 --   Where
                 --       start_date >= add_months(sysdate, - 24)
                 --   Order By app_date_4_sort Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End;

    Function fn_hse_suggestion(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date,
        p_end_date    Date,
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
        c       := get_hse_suggestion(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
  END fn_hse_suggestion;

    Function fn_hse_suggestion_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date,
        p_end_date    Date,
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
        c       := get_hse_suggestion_desk(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
  END fn_hse_suggestion_desk;

END IOT_HSE_QRY;
/
---------------------------
--New PACKAGE BODY
--IOT_GUEST_MEET_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_GUEST_MEET_QRY" As

    Function get_guest_attendance(
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
                        applied_on,
                        app_no,
                        meeting_date,
                        meeting_time,
                        host_name,
                        guest_name,
                        guest_company,
                        meeting_place,
                        remarks,
                        delete_allowed,
                        Row_Number() Over (Order By applied_on Desc) row_number,
                        Count(*) Over ()                             total_row

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
                                End                                                   delete_allowed
                            From
                                ss_guest_register
                            Where
                                ss_guest_register.modified_by = p_empno
                                And trunc(ss_guest_register.meet_date) >= trunc(sysdate)
                            Order By ss_guest_register.meet_date, ss_guest_register.modified_on
                        )
                    Where
                        meeting_date >= trunc(sysdate)
                    Order By applied_on Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;

    Function fn_guest_attendance(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date,
        p_end_date    Date,
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
--New FUNCTION
--GET_EMP_NAME_FROM_PERSON_ID
---------------------------
CREATE OR REPLACE FUNCTION "GET_EMP_NAME_FROM_PERSON_ID" (
    p_person_id In Varchar2
) Return Varchar2 As
    v_emp_name     Varchar2(60);
    v_person_id Varchar2(10);
Begin
    v_person_id := trim(substr(p_person_id, 2));

    Select
        name
    Into
        v_emp_name
    From
        ss_emplmast
    Where
        Trim(personid) In (Trim(p_person_id), v_person_id)
        And status = 1;
    Return v_emp_name;
Exception
    When Others Then
        Return 'ERRRR';
End get_emp_name_from_person_id;
/
