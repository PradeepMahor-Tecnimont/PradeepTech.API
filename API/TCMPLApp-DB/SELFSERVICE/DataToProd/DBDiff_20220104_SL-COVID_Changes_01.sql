--------------------------------------------------------
--  File created - Tuesday-January-04-2022   
--------------------------------------------------------
---------------------------
--Changed TABLE
--SS_LEAVE_ADJ
---------------------------
ALTER TABLE "SELFSERVICE"."SS_LEAVE_ADJ" ADD ("IS_COVID_SICK_LEAVE" NUMBER(1,0));

---------------------------
--Changed TABLE
--SS_LEAVELEDG
---------------------------
ALTER TABLE "SELFSERVICE"."SS_LEAVELEDG" ADD ("IS_COVID_SICK_LEAVE" NUMBER(1,0));

---------------------------
--Changed TABLE
--SS_LEAVEAPP
---------------------------
ALTER TABLE "SELFSERVICE"."SS_LEAVEAPP" ADD ("IS_COVID_SICK_LEAVE" NUMBER(1,0));
COMMENT ON COLUMN "SELFSERVICE"."SS_LEAVEAPP"."IS_COVID_SICK_LEAVE" IS '1-Yes';

---------------------------
--Changed VIEW
--SS_DISPLEDG
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_DISPLEDG" 
 ( "APP_NO", "APP_DATE", "LEAVETYPE", "DESCRIPTION", "EMPNO", "LEAVEPERIOD", "DB_CR", "DISPBDATE", "DISPEDATE", "DBDAY", "CRDAY", "ADJ_TYPE", "IS_COVID_SICK_LEAVE"
  )  AS 
  SELECT SS_LEAVELEDG.APP_NO,
    SS_LEAVELEDG.APP_DATE,
    SS_LEAVELEDG.LEAVETYPE,
    SS_LEAVELEDG.DESCRIPTION,
    SS_LEAVELEDG.EMPNO,
    SS_LEAVELEDG.LEAVEPERIOD,
    SS_LEAVELEDG.DB_CR,
    SS_Leaveledg.BDate DispBDate,
    SS_Leaveledg.EDate DispEDate,
    DECODE(SS_LEAVELEDG.DB_CR, 'D', SS_LEAVELEDG.LEAVEPERIOD*-1, NULL) DbDay,
    DECODE(SS_LEAVELEDG.DB_CR, 'C', SS_LEAVELEDG.LEAVEPERIOD, NULL) CrDay,
    SS_LEAVE_ADJ.ADJ_TYPE,
    SS_LEAVELEDG.IS_COVID_SICK_LEAVE
  FROM SS_LEAVE_ADJ,
    SS_LEAVEAPP,
    SS_LEAVELEDG
  WHERE (SS_LEAVELEDG.APP_NO=SS_LEAVE_ADJ.ADJ_NO(+))
  AND (SS_LEAVELEDG.APP_NO  =SS_LEAVEAPP.APP_NO(+))
  AND (SS_LEAVELEDG.EMPNO   =SS_LEAVE_ADJ.EMPNO(+))
  AND (SS_LEAVELEDG.EMPNO   =SS_LEAVEAPP.EMPNO(+));
  --AND (ss_leaveledg.bdate  >= add_months(sysdate,-24));
---------------------------
--Changed PACKAGE
--IOT_SWP_OFFICE_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_OFFICE_WORKSPACE_QRY" As

    c_qry_office_planning Varchar2(4000) := ' 
With
    params As (
        Select
            :p_empno As p_empno, :p_row_number As p_row_number, :p_page_length As p_page_length,
            :p_start_date as p_start_date , :p_end_date as p_end_date,:p_meta_id as p_meta_id,:p_person_id as p_person_id
        From
            dual
    ),
    assign_codes As (
        Select
            costcode As assign
        From
            ss_costmast, params
        Where
            hod = params.p_empno
        Union
        Select
            parent As assign
        From
            ss_user_dept_rights, params
        Where
            empno = params.p_empno
    ),
    attend_plan As (
        Select
            empno, attendance_date
        From
            swp_smart_attendance_plan
        Where
            attendance_date In (
                Select
                    d_date
                From
                    ss_days_details, params
                Where
                    d_date Between params.p_start_date And params.p_end_date
            )
            And empno In (
                Select
                    empno
                From
                    ss_emplmast                  ce, assign_codes cac
                Where
                    ce.assign  = cac.assign
                    And status = 1
            )
    )
Select
    full_data.*
From
    (
        Select
            data.*,
            Row_Number() Over(Order By empno) As row_number,
            Count(*) Over()                   As total_row
        From (
        select * from (

                    Select
                        e.empno                          As empno,
                        e.empno || '' - '' || e.name       As employee_name,
                        e.parent                         As parent,
                        e.grade                          As emp_grade,
                        iot_swp_common.get_emp_work_area(params.p_person_id,params.p_meta_id,e.empno) As work_area,
                        e.emptype                        As emptype,
                        e.assign                         As assign,
                        iot_swp_common.get_desk_from_dms(e.empno) As deskid,
                        Null                             As pending,
                        to_char(a.attendance_date, ''yyyymmdd'') As d_days
                    From
                        ss_emplmast  e,
                        attend_plan  a,
                        assign_codes ac,
                        params
                    Where
                        e.empno In (
                            Select
                                empno
                            From
                                swp_primary_workspace w
                            Where
                                w.primary_workspace = 1
                        )
                        And e.assign = ac.assign
                        And e.status = 1
                        And e.empno  = a.empno(+)                

                    )
            ) data
    ) full_data, params
Where
    row_number Between (nvl(params.p_row_number, 0) + 1) And (nvl(params.p_row_number, 0) + params.p_page_length)';

    Cursor cur_general_area_list(p_office      Varchar2,
                                 p_floor       Varchar2,
                                 p_wing        Varchar2,
                                 p_row_number  Number,
                                 p_page_length Number) Is

        Select
            *
        From
            (
                Select
                Distinct a.office,
                    a.floor,
                    a.wing,
                    a.work_area,
                    a.area_desc,
                    a.area_catg_code,
                    a.total,
                    a.occupied,
                    a.available,
                    Row_Number() Over (Order By office Desc) As row_number,
                    Count(*) Over ()                         As total_row
                From
                    swp_vu_area_list a
                Where
                    a.area_catg_code = 'A002'
                Order By a.area_desc, a.office, a.floor                 
            /*
             From SWP_VU_AREA_LIST a
              Where a.AREA_CATG_CODE = 'KO'
                And Trim(a.office) = Trim(p_office)
                And Trim(a.floor) = Trim(p_floor)
              Order By a.area_desc, a.office, a.floor
            */
            )
        Where
            row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

    Type typ_area_list Is Table Of cur_general_area_list%rowtype;

    Function fn_office_planning(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_general_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_work_area_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_date        Date,
        p_work_area   Varchar2,
        p_wing        Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

End iot_swp_office_workspace_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_OFFICE_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_OFFICE_WORKSPACE_QRY" As

    Function fn_office_planning(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query              Varchar2(4000);
        v_start_date         Date := (iot_swp_common.get_monday_date(p_date) - 1);
        v_end_date           Date := (iot_swp_common.get_friday_date(p_date));
        Cursor cur_days Is
            Select
                to_char(d_date, 'yyyymmdd') yymmdd, to_char(d_date, 'DY') dday
            From
                ss_days_details
            Where
                d_date Between v_start_date And v_end_date;
    Begin
        --v_start_date := get_monday_date(p_date);
        --v_end_date   := get_friday_date(p_date);

        v_query := c_qry_office_planning;

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;
        /*
                Insert Into swp_mail_log (subject, mail_sent_to_cc_bcc, modified_on)
                Values (v_empno || '-' || p_row_number || '-' || p_page_length || '-' || to_char(v_start_date, 'yyyymmdd') || '-' ||
                    to_char(v_end_date, 'yyyymmdd'),
                    v_query, sysdate);
                Commit;
                */
        Open c For v_query Using v_empno, p_row_number, p_page_length, v_start_date, v_end_date, p_person_id, p_meta_id;

        Return c;

    End;

    Function fn_general_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                    Distinct a.office,
                        a.floor,
                        a.wing,
                        a.work_area,
                        a.area_desc,
                        a.area_catg_code,
                        a.total,
                        a.occupied,
                        a.available,
                        Row_Number() Over (Order By office Desc) As row_number,
                        Count(*) Over ()                         As total_row
                    From
                        swp_vu_area_list a
                    Where
                        a.area_catg_code = 'A002'
                    Order By a.area_desc, a.office, a.floor
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_general_area_list;

    Function fn_work_area_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_date        Date,
        p_work_area   Varchar2,
        p_wing        Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
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
                        mast.deskid                              As deskid,
                        mast.office                              As office,
                        mast.floor                               As floor,
                        mast.seatno                              As seat_no,
                        mast.wing                                As wing,
                        mast.assetcode                           As asset_code,
                        mast.bay                                 As bay,
                        Row_Number() Over (Order By deskid Desc) row_number,
                        Count(*) Over ()                         total_row
                    From
                        dms.dm_deskmaster mast
                    Where
                        mast.work_area                   = Trim(p_work_area)
                        And (p_wing Is Null Or mast.wing = p_wing)
                        And mast.deskid
                        Not In(
                            Select
                            Distinct swptbl.deskid
                            From
                                swp_smart_attendance_plan swptbl
                            --where (trunc(ATTENDANCE_DATE) = TRUNC(p_date) or p_date is null)
                            Union
                            Select
                            Distinct c.deskid
                            From
                                dm_vu_emp_desk_map c
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                deskid,
                seat_no;
        Return c;
    End fn_work_area_desk;

End iot_swp_office_workspace_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SELECT_LIST_QRY" As

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
                is_active = 1
            Order By
                leavetype;
        Return c;
    End fn_leave_type_list;

    Function fn_leave_types_for_leaveclaims(
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
            Order By
                leavetype;
        Return c;
    End fn_leave_types_for_leaveclaims;

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
                        e.metaid = p_meta_id
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

    Function fn_onduty_types_list_4_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2
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
                is_active = 1
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
                (status = 1
                    Or nvl(dol, sysdate) > sysdate - 730)
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
        v_mngr_empno := get_empno_from_meta_id(p_meta_id);
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
        v_mngr_onbehalf_empno := get_empno_from_meta_id(p_meta_id);
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

    Function fn_employee_list_4_secretary(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_secretary_empno    Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_secretary_empno := get_empno_from_meta_id(p_meta_id);
        If v_secretary_empno = 'ERRRR' Then
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
                And parent In (
                    Select
                        parent
                    From
                        ss_user_dept_rights
                    Where
                        empno = v_secretary_empno
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
        v_empno := get_empno_from_meta_id(p_meta_id);

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

    Function fn_costcode_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                 Sys_Refcursor;
        v_empno           Varchar2(5);
        timesheet_allowed Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        Open c For
            Select
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                ss_costmast
            Where
                noofemps > 0;

        Return c;
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

        -- v_empno := get_empno_from_meta_id(p_meta_id);
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

        v_empno := get_empno_from_meta_id(p_meta_id);
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

        v_empno := get_empno_from_meta_id(p_meta_id);

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

        v_empno := get_empno_from_meta_id(p_meta_id);

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
--IOT_LEAVE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_LEAVE_QRY" As

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
                        db_cr,
                        is_pl,
                        can_delete_app,
                        Sum(is_pl) Over (Order By start_date Desc, app_no)   As pl_total,
                        Case
                            When Sum(is_pl) Over (Order By start_date Desc, app_no) <= 3
                                And is_pl = 1
                            Then
                                1
                            Else
                                0
                        End                                                  As can_edit_pl_app,
                        Trim(med_cert_file_name)                             As med_cert_file_name,
                        Row_Number() Over (Order By start_date Desc, app_no) As row_number,
                        Count(*) Over ()                                     As total_row

                    From
                        (
                                (
                        Select
                            ss_leaveapp.app_date                             As app_date_4_sort,
                            get_emp_name(ss_leaveapp.lead_apprl_empno)       As lead,
                            ltrim(rtrim(ss_leaveapp.app_no))                 As app_no,
                            to_char(ss_leaveapp.app_date, 'dd-Mon-yyyy')     As application_date,
                            ss_leaveapp.bdate                                As start_date,
                            ss_leaveapp.edate                                As end_date,
                            Case
                                When nvl(is_covid_sick_leave, 0) = 1
                                    And Trim(leavetype)          = 'SL'
                                Then
                                    'SL-COVID'
                                Else
                                    Trim(leavetype)
                            End                                              As leave_type,
                            to_days(ss_leaveapp.leaveperiod)                 As leave_period,
                            ss.approval_text(nvl(ss_leaveapp.lead_apprl, 0)) As lead_approval_desc,
                            ss.approval_text(nvl(ss_leaveapp.hod_apprl, 0))  As hod_approval_desc,
                            ss.approval_text(nvl(ss_leaveapp.hrd_apprl, 0))  As hrd_approval_desc,
                            ss_leaveapp.lead_reason,
                            ss_leaveapp.hodreason                            As hod_reason,
                            ss_leaveapp.hrdreason                            As hrd_reason,
                            '1'                                              As from_tab,
                            'D'                                              As db_cr,
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
                                When p_req_for_self                           = 'OK'
                                    And nvl(ss_leaveapp.lead_apprl, c_pending) In (c_pending, c_apprl_none)
                                    And nvl(ss_leaveapp.hod_apprl, c_pending) = c_pending
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
                            a.bdate                                                           As start_date,
                            a.edate                                                           As end_date,
                            Case
                                When nvl(is_covid_sick_leave, 0) = 1
                                    And Trim(leavetype)          = 'SL'
                                Then
                                    'SL-COVID'
                                Else
                                    Trim(leavetype)
                            End                                                               As leave_type,
                            to_days(decode(a.db_cr, 'D', a.leaveperiod * - 1, a.leaveperiod)) As leave_period,
                            'NONE'                                                            As lead_approval_desc,
                            'Approved'                                                        As hod_approval_desc,
                            'Approved'                                                        As hrd_approval_desc,
                            ''                                                                As lead_reason,
                            ''                                                                As hod_reason,
                            ''                                                                As hrd_reason,
                            '2'                                                               As from_tab,
                            db_cr                                                             As db_cr,
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
                        And trunc(start_date) Between nvl(p_start_date, trunc(start_date)) And nvl(p_end_date, trunc(start_date))
                    Order By start_date Desc
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
                        Case
                            When nvl(is_covid_sick_leave, 0) = 1
                                And Trim(leavetype)          = 'SL'
                            Then
                                'SL-COVID'
                            Else
                                Trim(leavetype)
                        End                                    As leave_type,
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
        v_empno := get_empno_from_meta_id(p_meta_id);
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
            empno = p_empno;
        --And status = 1;
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
        v_self_empno := get_empno_from_meta_id(p_meta_id);
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
            empno = p_empno;
        --And status = 1;
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
        v_empno := get_empno_from_meta_id(p_meta_id);
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
        v_hod_empno := get_empno_from_meta_id(p_meta_id);
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
                        Case
                            When nvl(is_covid_sick_leave, 0) = 1
                                And Trim(leavetype)          = 'SL'
                            Then
                                'SL-COVID'
                            Else
                                Trim(leavetype)
                        End                                          As leave_type,
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        Trim(med_cert_file_name)                     As med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_remarks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row

                    From
                        ss_leaveapp                l, ss_emplmast e
                    Where
                        (nvl(hod_apprl, c_pending) = c_pending)
                        And l.empno                = e.empno
                        And e.status               = 1
                        And nvl(lead_apprl, c_pending) In (c_approved, c_apprl_none)
                        And e.mngr                 = Trim(v_hod_empno)
                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_hod_approval;

    Function fn_pending_onbehalf_approval(

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
        v_hod_empno := get_empno_from_meta_id(p_meta_id);
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
                        Trim(med_cert_file_name)                     As med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_remarks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row

                    From
                        ss_leaveapp                l, ss_emplmast e
                    Where
                        (nvl(hod_apprl, c_pending) = c_pending)
                        And l.empno                = e.empno
                        And e.status               = 1
                        And nvl(lead_apprl, c_pending) In (c_approved, c_apprl_none)
                        And e.mngr In (
                            Select
                                mngr
                            From
                                ss_delegate
                            Where
                                empno = Trim(v_hod_empno)
                        )
                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_onbehalf_approval;

    Function fn_pending_hr_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_parent      Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hr_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        /*
            v_hr_empno := get_empno_from_meta_id(p_meta_id);
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
                        Case
                            When nvl(is_covid_sick_leave, 0) = 1
                                And Trim(leavetype)          = 'SL'
                            Then
                                'SL-COVID'
                            Else
                                Trim(leavetype)
                        End                                          As leave_type,
                        Case leavetype
                            When 'CL' Then
                                closingclbal(l.empno, trunc(sysdate), 0)
                            When 'SL' Then
                                closingslbal(l.empno, trunc(sysdate), 0)
                            When 'PL' Then
                                closingplbal(l.empno, trunc(sysdate), 0)
                            When 'CO' Then
                                closingcobal(l.empno, trunc(sysdate), 0)
                            When 'EX' Then
                                closingexbal(l.empno, trunc(sysdate), 0)
                            When 'OH' Then
                                closingohbal(l.empno, trunc(sysdate), 0)
                            Else
                                0
                        End                                          As leave_balance,
                        --Get_Leave_Balance(l.empno,sysdate,ss.closing_bal,leavetype, :param_Leave_Count)                        
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        Trim(med_cert_file_name)                     As med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_marks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row

                    From
                        ss_leaveapp                l, ss_emplmast e
                    Where
                        l.empno                         = e.empno
                        And nvl(l.hod_apprl, c_pending) = c_approved
                        And nvl(l.hrd_apprl, c_pending) = c_pending
                        And e.status                    = 1
                        And e.parent                    = nvl(p_parent, e.parent)
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
        v_lead_empno := get_empno_from_meta_id(p_meta_id);
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
                        Case
                            When nvl(is_covid_sick_leave, 0) = 1
                                And Trim(leavetype)          = 'SL'
                            Then
                                'SL-COVID'
                            Else
                                Trim(leavetype)
                        End                                          As leave_type,
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        Trim(med_cert_file_name)                     As med_cert_file_name,
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
--Changed PACKAGE BODY
--IOT_LEAVE_CLAIMS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_LEAVE_CLAIMS" As

    Procedure sp_add_leave_claim(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_leave_type       Varchar2,
        p_leave_period     Number,
        p_start_date       Date,
        p_end_date         Date,
        p_half_day_on      Number,
        p_description      Varchar2,
        p_med_cert_file_nm Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As

        v_empno               Varchar2(5);
        v_app_date            Date;
        v_message_type        Varchar2(2);
        v_count               Number;
        v_adj_date            Date;
        v_adj_seq_no          Number;
        v_hd_date             Date;
        v_entry_by_empno      Varchar2(5);
        v_hd_presnt_part      Number;
        v_adj_no              Varchar2(60);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_leave_type          Varchar2(2);
        v_is_covid_sick_leave Number(1);
    Begin
        v_leave_type     := p_leave_type;
        If v_leave_type = 'SC' Then
            v_leave_type          := 'SL';
            v_is_covid_sick_leave := 1;
        End If;
        v_entry_by_empno := get_empno_from_meta_id(p_meta_id);
        v_app_date       := sysdate;
        If v_entry_by_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;

        v_empno          := p_empno;
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

        v_adj_seq_no     := leave_adj_seq.nextval;
        v_adj_no         := 'LC/' || v_empno || '/' || to_char(sysdate, 'ddmmyyyy') || '/' || v_adj_seq_no;
        If nvl(p_half_day_on, half_day_on_none) = hd_bdate_presnt_part_2 Then
            v_hd_date        := p_start_date;
            v_hd_presnt_part := 2;
        Elsif nvl(p_half_day_on, half_day_on_none) = hd_edate_presnt_part_1 Then
            v_hd_date        := p_end_date;
            v_hd_presnt_part := 1;
        End If;

        Insert Into ss_leave_adj (
            empno,
            adj_dt,
            adj_no,
            leavetype,
            dataentryby,
            db_cr,
            adj_type,
            bdate,
            edate,
            leaveperiod,
            description,
            tcp_ip,
            hd_date,
            hd_part,
            entry_date,
            med_cert_file_name,
            is_covid_sick_leave
        )
        Values(
            v_empno,
            sysdate,
            v_adj_no,
            v_leave_type,
            v_entry_by_empno,
            'D',
            'LC',
            p_start_date,
            p_end_date,
            p_leave_period * 8,
            p_description,
            Null,
            v_hd_date,
            v_hd_presnt_part,
            v_app_date,
            p_med_cert_file_nm,
            v_is_covid_sick_leave
        );
        Insert Into ss_leaveledg(
            app_no,
            app_date,
            leavetype,
            description,
            empno,
            leaveperiod,
            db_cr,
            tabletag,
            bdate,
            edate,
            adj_type,
            hd_date,
            hd_part,
            is_covid_sick_leave
        )
        Values(
            v_adj_no,
            v_app_date,
            v_leave_type,
            p_description,
            v_empno,
            p_leave_period * 8 * - 1,
            'D',
            0,
            p_start_date,
            p_end_date,
            'LC',
            v_hd_date,
            v_hd_presnt_part,
            v_is_covid_sick_leave
        );
        Commit;
        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;

    End;
    /*
        Procedure sp_delete_leave_claim(
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
            v_empno        := get_empno_from_meta_id(p_meta_id);
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
                ss_leave_adj
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
    */
End iot_leave_claims;
/
---------------------------
--Changed PACKAGE BODY
--LEAVE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."LEAVE" As
    /*PROCEDURE validate_cl_nu(
        param_empno VARCHAR2,
        param_bdate DATE,
        param_edate DATE,
        param_half_day_on NUMBER,
        param_leave_period out number,
        param_msg_type OUT NUMBER,
        param_msg OUT VARCHAR2);*/

    Function get_date_4_continuous_leave(
        param_empno           Varchar2,
        param_date            Date,
        param_leave_type      Varchar2,
        param_forward_reverse Varchar2
    ) Return Date;

    Function check_co_with_adjacent_leave(
        param_empno           Varchar2,
        param_date            Date,
        param_forward_reverse Varchar2
    ) Return Number;

    Function validate_spc_co_spc(
        param_empno       Varchar2,
        param_bdate       Date,
        param_edate       Date,
        param_half_day_on Number
    ) Return Number;

    Function get_continuous_cl_sum(
        param_empno           Varchar2,
        param_date            Date,
        param_reverse_forward Varchar2
    ) Return Number;

    Function get_continuous_sl_sum(
        param_empno           Varchar2,
        param_date            Date,
        param_reverse_forward Varchar2
    ) Return Number;

    --function validate_co_spc_co(param_empno varchar2, param_bdate date, param_edate date) return number ;

    Function validate_co_spc_co(
        param_empno       Varchar2,
        param_bdate       Date,
        param_edate       Date,
        param_half_day_on Number
    ) Return Number;

    Function validate_cl_sl_co(
        param_empno       Varchar2,
        param_bdate       Date,
        param_edate       Date,
        param_half_day_on Number,
        param_leave_type  Varchar2
    ) Return Number;

    Function get_continuous_leave_sum(
        param_empno           Varchar2,
        param_date            Date,
        param_leave_type      Varchar2,
        param_reverse_forward Varchar2
    ) Return Number;

    Function check_pl_combination(
        param_empno In   Varchar2,
        param_leave_type Varchar2,
        param_bdate      Date,
        param_edate      Date,
        param_app_no     Varchar2 Default ' '
    ) Return Number;
    /*
  function calc_leave_period ( 
        param_bdate date, 
        param_edate date,
        param_leave_type varchar2,
        param_half_day_on number
        ) return number ;

    /*function validate_cl_sl_co
    (
      param_empno VARCHAR2,
      param_bdate DATE,
      param_edate DATE,
      param_half_day_on NUMBER,
      param_leave_type varchar2
    ) return number ;
*/

    Procedure validate_pl(
        param_empno            Varchar2,
        param_bdate            Date,
        param_edate            Date,
        param_half_day_on      Number   Default half_day_on_none,
        param_app_no           Varchar2 Default ' ',
        param_leave_period Out Number,
        param_msg_type     Out Number,
        param_msg          Out Varchar2
    ) As

        v_leave_period   Number;
        v_minimum_days   Number;
        v_failure_number Number := 0;
        v_pl_combined    Number;
        v_co_spc_co      Number;
        v_spc_co_spc     Number;
    Begin
        param_msg_type     := ss.success;

        --Cannot avail leave on holiday.
        If checkholiday(param_bdate) > 0 Or checkholiday(param_edate) > 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Cannot avail leave on holiday. ';
        End If;

        --PL cannot be less then 4 days.

        v_minimum_days     := 0.5;
        v_leave_period     := calc_leave_period(
                                  param_bdate,
                                  param_edate,
                                  'PL',
                                  param_half_day_on
                              );
        param_leave_period := v_leave_period;
        If v_leave_period < v_minimum_days Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - PL cannot be less then 4 days. ';
        End If;

        --Check PL Combined with other Leave

        v_pl_combined      := check_pl_combination(
                                  param_empno,
                                  'PL',
                                  param_bdate,
                                  param_edate,
                                  param_app_no
                              );
        If v_pl_combined = leave_combined_with_none Then
            Return;
        End If;
        If v_pl_combined = leave_combined_with_csp Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - PL and CL/PL/SL cannot be availed together. ';
        Elsif v_pl_combined = leave_combined_over_lap Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Leave has already been availed on same day. ';
        End If;

        -- R E T U R N 

        Return;
        -- R E T U R N 
        --Below processing not required since rule has Changed
        --Can avail leave adjacent to any leavetype except SL cannot be adjacent to SL

        -- X X X X X X X X X X X 
        v_co_spc_co        := validate_co_spc_co(
                                  param_empno,
                                  param_bdate,
                                  param_edate,
                                  param_half_day_on
                              );
        If v_co_spc_co = ss.failure Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - PL cannot be availed with trailing and preceding CO - CO-PL-CO. ';
        End If;

        v_spc_co_spc       := validate_spc_co_spc(
                                  param_empno,
                                  param_bdate,
                                  param_edate,
                                  param_half_day_on
                              );
        If v_spc_co_spc = ss.failure Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - PL cannot be availed when trailing and preceding to CO. "CL-SL-PL  -CO-  CL-SL-PL"';
        End If;

    End validate_pl;

    Function check_pl_combination(
        param_empno In   Varchar2,
        param_leave_type Varchar2,
        param_bdate      Date,
        param_edate      Date,
        param_app_no     Varchar2 Default ' '
    ) Return Number Is
        v_count          Number;
        v_next_work_date Date;
        v_prev_work_date Date;
    Begin
        --Check Overlap
        Select
            Count(*)
        Into
            v_count
        From
            ss_leave_app_ledg
        Where
            empno = param_empno
            And (param_bdate Between bdate And edate
                Or param_edate Between bdate And edate)
            And app_no <> nvl(param_app_no, ' ');

        If v_count > 0 Then
            Return leave_combined_over_lap;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_leave_app_ledg
        Where
            empno = param_empno
            And (bdate Between param_bdate And param_edate
                Or edate Between param_bdate And param_edate)
            And app_no <> nvl(param_app_no, ' ');

        If v_count > 0 Then
            Return leave_combined_over_lap;
        End If;
        --Check Overlap

        --Check CL/SL/PL Combination
        v_prev_work_date := getlastworkingday(param_bdate, '-');
        v_next_work_date := getlastworkingday(param_edate, '+');
        Select
            Count(*)
        Into
            v_count
        From
            ss_leave_app_ledg
        Where
            empno = param_empno
            And (trunc(v_prev_work_date) Between bdate And edate
                Or trunc(v_next_work_date) Between bdate And edate)
            And leavetype Not In (
                'CO', 'PL', 'CL', 'SL'
            )
            And app_no <> nvl(param_app_no, ' ');

        If v_count > 0 Then
            Return leave_combined_with_csp;
        End If;
        --Check CL/SL/PL Combination

        --Check CO Combination
        Declare
            v_prev_co_count Number;
            v_next_co_count Number;
        Begin
            Return leave_combined_with_none;
            /*
            Select
                Count(*)
            Into v_prev_co_count
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And ( Trunc(v_prev_work_date) Between bdate And edate )
                And leavetype = 'CO'
                And app_no <> Nvl(param_app_no, ' ');

            Select
                Count(*)
            Into v_next_co_count
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And ( Trunc(v_next_work_date) Between bdate And edate )
                And leavetype = 'CO'
                And app_no <> Nvl(param_app_no, ' ');

            If v_prev_co_count > 0 Or v_next_co_count > 0 Then
                Return leave_combined_with_co;
            Else
                Return leave_combined_with_none;
            End If;
            */
        End;
        --Check CO Combination
    End check_pl_combination;

    Procedure validate_sl(
        param_empno            Varchar2,
        param_bdate            Date,
        param_edate            Date,
        param_half_day_on      Number,
        param_leave_period Out Number,
        param_msg_type     Out Number,
        param_msg          Out Varchar2
    ) As

        v_minimum_days   Number;
        v_failure_number Number := 0;
        v_sl_combined    Number;
        v_co_spc_co      Number;
        v_cumu_sl        Number;
        v_max_days       Number := 3;
        v_leave_period   Number;
        v_bdate          Date;
        v_edate          Date;
        v_spc_co_spc     Number;
        v_co_combined    Number;
    Begin
        param_msg_type     := ss.success;

        --Cannot avail leave on holiday.
        If checkholiday(param_bdate) > 0 Or checkholiday(param_edate) > 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Cannot avail leave on holiday. ';
        End If;

        param_leave_period := calc_leave_period(
                                  param_bdate,
                                  param_edate,
                                  'SL',
                                  param_half_day_on
                              );
        v_leave_period     := param_leave_period;
        v_sl_combined      := validate_cl_sl_co(
                                  param_empno,
                                  param_bdate,
                                  param_edate,
                                  param_half_day_on,
                                  'SL'
                              );
        If v_sl_combined = leave_combined_sl_with_sl Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - SL cannot precede / succeed SL. ';
        Elsif v_sl_combined = leave_combined_over_lap Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Leave has already been availed on same day. ';
        End If;

        -- R E T U R N 

        Return;
        -- R E T U R N 
        --Below processing not required since rule has Changed
        --Can avail leave adjacent to any leavetype except SL cannot be adjacent to SL

        -- X X X X X X X X X X X 
        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            v_cumu_sl := get_continuous_sl_sum(
                             param_empno,
                             param_edate,
                             c_forward
                         );
        End If;

        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            v_cumu_sl := nvl(v_cumu_sl, 0) + get_continuous_sl_sum(
                             param_empno,
                             param_bdate,
                             c_reverse
                         );
        End If;

        v_cumu_sl          := nvl(v_cumu_sl, 0);
        v_cumu_sl          := v_cumu_sl / 8;
        If v_cumu_sl <> 0 And v_cumu_sl + v_leave_period > v_max_days Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - SL cannot be availed for more than 3 days in succession. ';
        End If;

        v_bdate            := Null;
        v_edate            := Null;
        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            v_bdate := get_date_4_continuous_leave(
                           param_empno,
                           param_bdate,
                           leave_type_sl,
                           c_reverse
                       );
        End If;

        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            v_edate := get_date_4_continuous_leave(
                           param_empno,
                           param_edate,
                           leave_type_sl,
                           c_forward
                       );
        End If;

        v_co_spc_co        := validate_co_spc_co(
                                  param_empno,
                                  nvl(v_bdate, param_bdate),
                                  nvl(v_edate, param_edate),
                                  param_half_day_on
                              );

        If v_co_spc_co = ss.failure Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - SL cannot be availed with trailing and preceding CO - CO-SL-CO. ';
        End If;

        v_spc_co_spc       := validate_spc_co_spc(
                                  param_empno,
                                  nvl(v_bdate, param_bdate),
                                  nvl(v_edate, param_edate),
                                  param_half_day_on
                              );

        If v_spc_co_spc = ss.failure Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - SL cannot be availed when trailing and preceding to CO. "CL-SL-PL  -CO-  CL-SL-PL"';
        End If;

    End validate_sl;

    Procedure validate_lv(
        param_empno            Varchar2,
        param_bdate            Date,
        param_edate            Date,
        param_half_day_on      Number,
        param_leave_period Out Number,
        param_msg_type     Out Number,
        param_msg          Out Varchar2
    ) As
        v_failure_number Number := 0;
        v_leave_period   Number;
        v_count          Number;
    Begin
        param_msg_type     := ss.success;
        Select
            Count(empno)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno             = param_empno
            And status        = 1
            And (emptype      = 'C'
                Or expatriate = 1);

        If v_count = 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - You Cannot avail leave type "LV". ';
        End If;

        --Cannot avail leave on holiday.

        If checkholiday(param_bdate) > 0 Or checkholiday(param_edate) > 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Cannot avail leave on holiday. ';
        End If;

        param_leave_period := calc_leave_period(
                                  param_bdate,
                                  param_edate,
                                  'LV',
                                  param_half_day_on
                              );
        Select
            Count(*)
        Into
            v_count
        From
            ss_leave_app_ledg
        Where
            empno = param_empno
            And (param_bdate Between bdate And edate
                Or param_edate Between bdate And edate);

        If v_count > 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Leave has already been availed on same day. ';
        End If;

    End;

    Procedure validate_co(
        param_empno            Varchar2,
        param_bdate            Date,
        param_edate            Date,
        param_half_day_on      Number,
        param_leave_period Out Number,
        param_msg_type     Out Number,
        param_msg          Out Varchar2
    ) As

        v_leave_period        Number;
        v_max_days            Number := 3;
        v_failure_number      Number := 0;
        v_co_combined_forward Number;
        v_co_combined_reverse Number;
        v_cumu_co             Number;
        v_co_combined         Number;
    Begin
        param_msg_type     := ss.success;

        --Cannot avail leave on holiday.
        If checkholiday(param_bdate) > 0 Or checkholiday(param_edate) > 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Cannot avail leave on holiday. ';
        End If;

        --CO cannot be less then 3 days.

        v_leave_period     := calc_leave_period(
                                  param_bdate,
                                  param_edate,
                                  'CO',
                                  param_half_day_on
                              );
        param_leave_period := v_leave_period;
        If v_leave_period > v_max_days Then
            param_msg_type := ss.failure;
            param_msg_type := ss.failure;
            param_msg      := param_msg || to_char(v_failure_number) || ' - CO cannot be more then 3 days. ';
        End If;
        --CO cannot be less then 3 days.

        -- R E T U R N 

        Return;
        -- R E T U R N 
        --Below processing not required since rule has Changed
        --Can avail leave adjacent to any leavetype except SL cannot be adjacent to SL

        -- X X X X X X X X X X X 
        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            v_cumu_co := get_continuous_leave_sum(
                             param_empno,
                             param_edate,
                             leave_type_co,
                             c_forward
                         );
        End If;

        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            v_cumu_co := nvl(v_cumu_co, 0) + get_continuous_leave_sum(
                             param_empno,
                             param_bdate,
                             leave_type_co,
                             c_reverse
                         );
        End If;

        v_cumu_co          := v_cumu_co / 8;
        If v_cumu_co + v_leave_period > v_max_days Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CO cannot be availed for more than 3 days continuously. ';
        End If;

        v_co_combined      := validate_cl_sl_co(
                                  param_empno,
                                  param_bdate,
                                  param_edate,
                                  param_half_day_on,
                                  'CO'
                              );
        If v_co_combined = leave_combined_over_lap Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Leave has already been availed on same day. ';
        End If;

        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            v_co_combined_forward := check_co_with_adjacent_leave(
                                         param_empno,
                                         param_edate,
                                         c_forward
                                     );
            If v_co_combined_forward = ss.failure Then
                v_failure_number := v_failure_number + 1;
                param_msg_type   := ss.failure;
                param_msg        := param_msg || to_char(v_failure_number) || ' - CO + CL/SL/PL + CL/SL/PL/CO cannot be availed together. ';
                Return;
            End If;

        End If;

        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            v_co_combined_reverse := check_co_with_adjacent_leave(
                                         param_empno,
                                         param_bdate,
                                         c_reverse
                                     );
            If v_co_combined_reverse = ss.failure Then
                v_failure_number := v_failure_number + 1;
                param_msg_type   := ss.failure;
                param_msg        := param_msg || to_char(v_failure_number) || ' - CL/SL/PL/CO + CL/SL/PL + CO cannot be availed together. ';
            Elsif leave_with_adjacent = v_co_combined_reverse And leave_with_adjacent = v_co_combined_forward Then
                v_failure_number := v_failure_number + 1;
                param_msg_type   := ss.failure;
                param_msg        := param_msg || to_char(v_failure_number) || ' - CL/SL/PL + CO + CL/SL/PL cannot be availed together. ';
            End If;

        End If;

    End validate_co;

    Procedure validate_cl_old(
        param_empno            Varchar2,
        param_bdate            Date,
        param_edate            Date,
        param_half_day_on      Number,
        param_leave_period Out Number,
        param_msg_type     Out Number,
        param_msg          Out Varchar2
    ) As
        v_leave_period   Number;
        v_max_days       Number;
        v_failure_number Number := 0;
        v_cl_combined    Number;
    Begin
        param_msg_type     := ss.success;

        --Cannot avail leave on holiday.
        If checkholiday(param_bdate) > 0 Or checkholiday(param_edate) > 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Cannot avail leave on holiday. ';
        End If;

        --CL cannot be more then 3 days.

        If param_half_day_on = half_day_on_none Then
            v_max_days := 3;
        Else
            v_max_days := 3;
        End If;

        v_leave_period     := calc_leave_period(
                                  param_bdate,
                                  param_edate,
                                  'CL',
                                  param_half_day_on
                              );
        param_leave_period := v_leave_period;
        If v_leave_period > v_max_days Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL cannot be more then 3 days. ';
        End If;
        --CL cannot be less then 3 days.

        v_cl_combined      := validate_cl_sl_co(
                                  param_empno,
                                  param_bdate,
                                  param_edate,
                                  param_half_day_on,
                                  'CL'
                              );
        If v_cl_combined = leave_combined_with_csp Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL and CL/PL/SL cannot be availed together. ';
        Elsif v_cl_combined = leave_combined_over_lap Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Leave has already been availed on same day. ';
        Elsif v_cl_combined = leave_combined_with_co Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL and CO cannot be availed together. ';
        End If;

    End validate_cl_old;

    Procedure check_co_co_combination(
        param_empno       Varchar2,
        param_bdate       Date,
        param_edate       Date,
        param_success Out Number
    ) As

        Cursor prev_leave Is
            Select
                *
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And bdate < param_bdate
            Order By
                edate Desc;

        Cursor next_leave Is
            Select
                *
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And bdate > param_edate
            Order By
                bdate Asc;

        v_count          Number;
        v_prev_work_date Date;
        v_next_work_date Date;
    Begin
        v_count := 0;
        For cur_row In prev_leave
        Loop
            v_count := v_count + 1;
            If v_count = 1 Then
                v_prev_work_date := getlastworkingday(param_bdate, '-');
                If Not (trunc(v_prev_work_date) Between cur_row.bdate And cur_row.edate) Or cur_row.leavetype = 'CO' Then
                    --No Error
                    param_success := ss.success;
                    Exit;
                Else
                    v_prev_work_date := getlastworkingday(cur_row.bdate, '-');
                End If;

            End If;

            If v_count = 2 Then
                If trunc(v_prev_work_date) Between cur_row.bdate And cur_row.edate And cur_row.leavetype = 'CO' Then
                    --Error
                    param_success := ss.failure;
                    Return;
                Else
                    --No Error
                    param_success := ss.success;
                    Null;
                End If;

                Exit;
            End If;

        End Loop;

        If param_success = ss.failure Then
            Return;
        End If;
        v_count := 0;
        For cur_row In next_leave
        Loop
            v_count := v_count + 1;
            If v_count = 1 Then
                v_next_work_date := getlastworkingday(param_edate, '+');
                If Not (trunc(v_next_work_date) Between cur_row.bdate And cur_row.edate) Or cur_row.leavetype = 'CO' Then
                    param_success := ss.success;
                    Exit;
                Else
                    v_next_work_date := getlastworkingday(cur_row.edate, '+');
                End If;

            End If;

            If v_count = 2 Then
                If trunc(v_next_work_date) Between cur_row.bdate And cur_row.edate And cur_row.leavetype = 'CO' Then
                    --Error
                    param_success := ss.failure;
                    Return;
                Else
                    param_success := ss.success;
                    Null;
                End If;

                Exit;
            End If;

        End Loop;

    End;

    Procedure validate_leave(
        param_empno              Varchar2,
        param_leave_type         Varchar2,
        param_bdate              Date,
        param_edate              Date,
        param_half_day_on        Number,
        param_app_no             Varchar2 Default Null,
        param_leave_period   Out Number,
        param_last_reporting Out Varchar2,
        param_resuming       Out Varchar2,
        param_msg_type       Out Number,
        param_msg            Out Varchar2
    ) As
        v_last_reporting Varchar2(100);
        v_resuming       Varchar2(100);
        v_count          Number;
        v_leave_type     Varchar2(2);
    Begin
        If param_bdate > param_edate Then
            param_msg_type := ss.failure;
            param_msg      := 'Invalid date range. Cannot proceed.';
            Return;
        End If;

        Begin
            go_come_msg(
                param_bdate,
                param_edate,
                param_half_day_on,
                v_last_reporting,
                v_resuming
            );
            param_last_reporting := v_last_reporting;
            param_resuming       := v_resuming;
        Exception
            When Others Then
                Null;
        End;
        v_leave_type := param_leave_type;
        If v_leave_type = 'SC' Then
            v_leave_type := 'SL';
        End If;
        Case
            When v_leave_type = leave_type_cl Then 
                --if param_empno in ('02320','02079') then
                validate_cl(
                    param_empno,
                    param_bdate,
                    param_edate,
                    param_half_day_on,
                    param_leave_period,
                    param_msg_type,
                    param_msg
                );
                /*else
                  validate_cl( param_empno ,param_bdate , param_edate , param_half_day_on ,param_leave_period , param_msg_type ,param_msg ) ;
                end if;*/
            When v_leave_type = leave_type_pl Then
                validate_pl(
                    param_empno,
                    param_bdate,
                    param_edate,
                    param_half_day_on,
                    param_app_no,
                    param_leave_period,
                    param_msg_type,
                    param_msg
                );
            When v_leave_type = leave_type_sl Then
                validate_sl(
                    param_empno,
                    param_bdate,
                    param_edate,
                    param_half_day_on,
                    param_leave_period,
                    param_msg_type,
                    param_msg
                );
            When v_leave_type = leave_type_co Then
                validate_co(
                    param_empno,
                    param_bdate,
                    param_edate,
                    param_half_day_on,
                    param_leave_period,
                    param_msg_type,
                    param_msg
                );
            When v_leave_type = leave_type_lv Then
                validate_lv(
                    param_empno,
                    param_bdate,
                    param_edate,
                    param_half_day_on,
                    param_leave_period,
                    param_msg_type,
                    param_msg
                );
            When v_leave_type = leave_type_ex Then 
                --validate_ex( param_empno ,param_bdate , param_edate , param_half_day_on ,param_leave_period , param_msg_type ,param_msg ) ;
                param_msg_type := ss.failure;
                param_msg      := 'Cannot avail "' || v_leave_type || '" Leave. Cannot proceed.';
            Else
                param_msg_type := ss.failure;
                param_msg      := '"' || v_leave_type || '" Leave Type not defined. Cannot proceed.';
        End Case;

    Exception
        When Others Then
            param_leave_period := 0;
            param_msg_type     := ss.failure;
            param_msg          := sqlcode || ' - ' || sqlerrm;
    End;

    Procedure go_come_msg(
        param_bdate              Date,
        param_edate              Date,
        param_half_day_on        Number,
        param_last_reporting Out Varchar2,
        param_resuming       Out Varchar2
    ) As
        v_prev_work_date Date;
        v_next_work_date Date;
    Begin
        v_prev_work_date := getlastworkingday(param_bdate, '-');
        v_next_work_date := getlastworkingday(param_edate, '+');
        Case
            When param_half_day_on = hd_bdate_presnt_part_2 Then
                param_last_reporting := to_char(param_bdate, daydateformat) || in_first_half;
                param_resuming       := to_char(v_next_work_date, daydateformat);
            When param_half_day_on = hd_edate_presnt_part_1 Then
                param_last_reporting := to_char(v_prev_work_date, daydateformat);
                param_resuming       := to_char(param_edate, daydateformat) || in_second_half;
            Else
                param_last_reporting := to_char(v_prev_work_date, daydateformat);
                param_resuming       := to_char(v_next_work_date, daydateformat);
        End Case;

    End;

    Function calc_leave_period(
        param_bdate       Date,
        param_edate       Date,
        param_leave_type  Varchar2,
        param_half_day_on Number
    ) Return Number As
        v_ret_val Number := 0;
    Begin
        If param_leave_type = leave_type_sl Then
            v_ret_val := param_edate - param_bdate + 1;
            If nvl(param_half_day_on, half_day_on_none) <> half_day_on_none Then
                v_ret_val := v_ret_val -.5;
            End If;

            Return v_ret_val;
        End If;

        v_ret_val := (param_edate - param_bdate + 1) - holidaysbetween(param_bdate, param_edate);
        If nvl(param_half_day_on, half_day_on_none) <> half_day_on_none Then
            v_ret_val := v_ret_val -.5;
        End If;

        Return v_ret_val;
    End;

    Function get_app_no(
        param_empno Varchar2
    ) Return Varchar2 As

        my_exception Exception;
        Pragma exception_init(my_exception, -20001);
        v_max_app_no Number;
        v_ret_val    Varchar2(60);
    Begin
        Select
            Count(*)
        Into
            v_max_app_no
        From
            ss_leaveapp
        Where
            empno = param_empno
            And app_date >= trunc(sysdate, 'YEAR');

        If v_max_app_no > 0 Then
            Select
                Max(to_number(substr(app_no, instr(app_no, '/', - 1) + 1)))
            Into
                v_max_app_no
            From
                ss_leaveapp
            Where
                empno = Trim(param_empno)
                And app_date >= trunc(sysdate, 'YEAR')
            Order By
                to_number(substr(app_no, instr(app_no, '/', - 1) + 1));

        End If;

        v_ret_val := param_empno || '/' || to_char(sysdate, 'yyyymmdd') || '/' || (v_max_app_no + 1);

        Return v_ret_val;
    Exception
        When Others Then
            raise_application_error(
                -20001,
                'GET_APP_NO - ' || sqlcode || ' - ' || sqlerrm
            );
    End;

    Procedure add_leave_app(
        param_empno            Varchar2,
        param_app_no           Varchar2 Default ' ',
        param_leave_type       Varchar2,
        param_bdate            Date,
        param_edate            Date,
        param_half_day_on      Number,
        param_projno           Varchar2,
        param_caretaker        Varchar2,
        param_reason           Varchar2,
        param_cert             Number,
        param_contact_add      Varchar2,
        param_contact_std      Varchar2,
        param_contact_phn      Varchar2,
        param_office           Varchar2,
        param_dataentryby      Varchar2,
        param_lead_empno       Varchar2,
        param_discrepancy      Varchar2,
        param_tcp_ip           Varchar2,
        param_nu_app_no Out    Varchar2,
        param_msg_type  Out    Number,
        param_msg       Out    Varchar2,
        param_med_cert_file_nm Varchar2 Default Null
    ) As

        v_app_no              Varchar2(60);
        v_last_reporting      Varchar2(150);
        v_resuming_on         Varchar2(150);
        v_l_rep_dt            Date;
        v_resume_dt           Date;
        v_hd_date             Date;
        v_hd_presnt_part      Number;
        v_lead_apprl          Number;
        v_mngr_email          Varchar2(100);
        v_leave_period        Number;
        v_email_success       Number;
        v_email_message       Varchar2(100);
        v_leave_type          Varchar2(2);
        v_is_covid_sick_leave Number(1);
    Begin
        v_leave_type     := param_leave_type;
        If v_leave_type = 'SC' Then
            v_leave_type          := 'SL';
            v_is_covid_sick_leave := 1;
        End If;

        validate_leave(
            param_empno,
            v_leave_type,
            param_bdate,
            param_edate,
            param_half_day_on,
            param_app_no,
            v_leave_period,
            v_last_reporting,
            v_resuming_on,
            param_msg_type,
            param_msg
        );
        --v_leave_period := calc_leave_period( param_bdate, param_edate, v_leave_type, param_half_day_on);

        If param_msg_type = ss.failure Then
            Return;
        End If;
        If v_leave_type = 'SL' And v_leave_period >= 2 Then
            If param_med_cert_file_nm Is Null Then
                param_msg_type := ss.failure;
                param_msg      := 'Err - Medical Certificate not attached.';
                Return;
            End If;
        End If;

        If nvl(param_half_day_on, half_day_on_none) = hd_bdate_presnt_part_2 Then
            v_hd_date        := param_bdate;
            v_hd_presnt_part := 2;
        Elsif nvl(param_half_day_on, half_day_on_none) = hd_edate_presnt_part_1 Then
            v_hd_date        := param_edate;
            v_hd_presnt_part := 1;
        End If;

        If param_lead_empno = 'None' Then
            v_lead_apprl := ss.apprl_none;
        Else
            v_lead_apprl := ss.pending;
        End If;

        v_app_no         := get_app_no(param_empno);
        param_nu_app_no  := v_app_no;
        --go_come_msg( param_bdate, param_edate, param_half_day_on, v_last_reporting, v_resuming_on);
        v_last_reporting := replace(v_last_reporting, in_first_half);
        v_last_reporting := replace(v_last_reporting, in_second_half);
        v_resuming_on    := replace(v_resuming_on, in_first_half);
        v_resuming_on    := replace(v_resuming_on, in_second_half);
        v_l_rep_dt       := to_date(v_last_reporting, daydateformat);
        v_resume_dt      := to_date(v_resuming_on, daydateformat);
        v_leave_period   := v_leave_period * 8;
        Insert Into ss_leaveapp (
            empno,
            app_no,
            app_date,
            projno,
            caretaker,
            leavetype,
            bdate,
            edate,
            mcert,
            work_ldate,
            resm_date,
            contact_phn,
            contact_std,
            dataentryby,
            office,
            hod_apprl,
            discrepancy,
            user_tcp_ip,
            hd_date,
            hd_part,
            lead_apprl,
            lead_apprl_empno,
            hrd_apprl,
            leaveperiod,
            reason,
            med_cert_file_name,
            is_covid_sick_leave
        )
        Values (
            param_empno,
            v_app_no,
            sysdate,
            param_projno,
            param_caretaker,
            v_leave_type,
            param_bdate,
            param_edate,
            param_cert,
            v_l_rep_dt,
            v_resume_dt,
            param_contact_phn,
            param_contact_std,
            param_dataentryby,
            param_office,
            ss.pending,
            param_discrepancy,
            param_tcp_ip,
            v_hd_date,
            v_hd_presnt_part,
            v_lead_apprl,
            param_lead_empno,
            ss.pending,
            v_leave_period,
            param_reason,
            param_med_cert_file_nm,
            v_is_covid_sick_leave
        );

        Commit;
        param_msg        := 'Application successfully Saved. ' || v_app_no;
        param_msg_type   := ss.success;
        If param_empno = '02320' Then
            v_email_success := ss.success;
        Else
            ss_mail.send_msg_new_leave_app(
                v_app_no,
                v_email_success,
                v_email_message
            );
        End If;

        If v_email_success = ss.failure Then
            param_msg_type := ss.warning;
            param_msg      := param_msg || ' Email could not be sent. - ';
        Else
            param_msg := param_msg || ' Email sent to HoD / Lead.';
        End If;

    Exception
        When Others Then
            param_msg_type := ss.failure;
            param_msg      := nvl(param_msg, ' ') || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure save_pl_revision(
        param_empno         Varchar2,
        param_app_no        Varchar2,
        param_bdate         Date,
        param_edate         Date,
        param_half_day_on   Number,
        param_dataentryby   Varchar2,
        param_lead_empno    Varchar2,
        param_discrepancy   Varchar2,
        param_tcp_ip        Varchar2,
        param_nu_app_no Out Varchar2,
        param_msg_type  Out Number,
        param_msg       Out Varchar2
    ) As

        v_contact_add Varchar2(60);
        v_contact_phn Varchar2(30);
        v_contact_std Varchar2(30);
        v_projno      Varchar2(60);
        v_caretaker   Varchar2(60);
        v_mcert       Number(1);
        v_office      Varchar2(30);
        v_count       Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_pl_revision_mast
        Where
            Trim(old_app_no)    = Trim(param_app_no)
            Or Trim(new_app_no) = Trim(param_app_no);

        If v_count > 0 Then
            param_msg_type := ss.failure;
            param_msg      := 'PL application "' || trim(param_app_no) || '" has already been revised.';
            Return;
        End If;

        Begin
            Select
                projno,
                caretaker,
                mcert,
                contact_add,
                contact_phn,
                contact_std,
                office
            Into
                v_projno,
                v_caretaker,
                v_mcert,
                v_contact_add,
                v_contact_phn,
                v_contact_std,
                v_office
            From
                ss_leaveapp
            Where
                Trim(app_no) = Trim(param_app_no);

        Exception
            When Others Then
                param_msg_type := ss.failure;
                param_msg      := nvl(param_msg, ' ') || sqlcode || ' - ' || sqlerrm || '. "' || param_app_no || '" Application not found.';

                Return;
        End;

        add_leave_app(
            param_empno       => param_empno,
            param_app_no      => param_app_no,
            param_leave_type  => 'PL',
            param_bdate       => param_bdate,
            param_edate       => param_edate,
            param_half_day_on => param_half_day_on,
            param_projno      => v_projno,
            param_caretaker   => v_caretaker,
            param_reason      => param_app_no || ' P L   R e v i s e d',
            param_cert        => v_mcert,
            param_contact_add => v_contact_add,
            param_contact_std => v_contact_std,
            param_contact_phn => v_contact_phn,
            param_office      => v_office,
            param_dataentryby => param_dataentryby,
            param_lead_empno  => param_lead_empno,
            param_discrepancy => param_discrepancy,
            param_tcp_ip      => param_tcp_ip,
            param_nu_app_no   => param_nu_app_no,
            param_msg_type    => param_msg_type,
            param_msg         => param_msg
        );

        If param_msg_type = ss.failure Then
            Rollback;
            Return;
        End If;
        Insert Into ss_pl_revision_mast (
            old_app_no,
            new_app_no
        )
        Values (
            Trim(param_app_no),
            Trim(param_nu_app_no)
        );

        Commit;
        param_msg_type := ss.success;
    Exception
        When Others Then
            param_msg_type := ss.failure;
            param_msg      := nvl(param_msg, ' ') || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure get_leave_details(
        param_o_app_no         In  Varchar2,
        param_o_empno          Out Varchar2,
        param_o_emp_name       Out Varchar2,
        param_o_app_date       Out Varchar2,
        param_o_office         Out Varchar2,
        param_o_edate          Out Varchar2,
        param_o_bdate          Out Varchar2,
        param_o_hd_date        Out Varchar2,
        param_o_hd_part        Out Number,
        param_o_leave_period   Out Number,
        param_o_leave_type     Out Varchar2,
        param_o_rep_to         Out Varchar2,
        param_o_projno         Out Varchar2,
        param_o_care_taker     Out Varchar2,
        param_o_reason         Out Varchar2,
        param_o_mcert          Out Number,
        param_o_work_ldate     Out Varchar2,
        param_o_resm_date      Out Varchar2,
        param_o_last_reporting Out Varchar2,
        param_o_resuming       Out Varchar2,
        param_o_contact_add    Out Varchar2,
        param_o_contact_phn    Out Varchar2,
        param_o_std            Out Varchar2,
        param_o_discrepancy    Out Varchar2,
        param_o_lead_empno     Out Varchar2,
        param_o_lead_name      Out Varchar2,
        param_o_msg_type       Out Number,
        param_o_msg            Out Varchar2
    ) As

        v_empno          Varchar2(5);
        v_name           Varchar2(60);
        v_last_reporting Varchar2(100);
        v_resuming       Varchar2(100);
    Begin
        Select
            empno,
            get_emp_name(empno),
            to_char(app_date, 'dd-Mon-yyyy'),
            to_char(edate, 'dd-Mon-yyyy'),
            to_char(bdate, 'dd-Mon-yyyy'),
            to_char(hd_date, 'dd-Mon-yyyy'),
            nvl(hd_part, 0),
            leaveperiod,
            leavetype,
            rep_to,
            projno,
            caretaker,
            reason,
            mcert,
            to_char(work_ldate, 'dd-Mon-yyyy'),
            to_char(resm_date, 'dd-Mon-yyyy'),
            contact_add,
            contact_phn,
            contact_std,
            discrepancy,
            lead_apprl_empno,
            get_emp_name(lead_apprl_empno) leadname,
            office
        Into
            param_o_empno,
            param_o_emp_name,
            param_o_app_date,
            param_o_edate,
            param_o_bdate,
            param_o_hd_date,
            param_o_hd_part,
            param_o_leave_period,
            param_o_leave_type,
            param_o_rep_to,
            param_o_projno,
            param_o_care_taker,
            param_o_reason,
            param_o_mcert,
            param_o_work_ldate,
            param_o_resm_date,
            param_o_contact_add,
            param_o_contact_phn,
            param_o_std,
            param_o_discrepancy,
            param_o_lead_empno,
            param_o_lead_name,
            param_o_office
        From
            ss_leaveapp
        Where
            app_no In (
                param_o_app_no
            );

        Begin
            go_come_msg(
                param_o_bdate,
                param_o_edate,
                param_o_hd_date,
                v_last_reporting,
                v_resuming
            );
            param_o_last_reporting := v_last_reporting;
            param_o_resuming       := v_resuming;
        Exception
            When Others Then
                Null;
        End;

        param_o_msg_type := ss.success;
        param_o_msg_type := 'SUCCESS';
    Exception
        When Others Then
            param_o_msg_type := ss.failure;
            param_o_msg      := sqlcode || ' - ' || sqlerrm;
    End get_leave_details;

    Procedure post_leave_apprl(
        param_list_appno   Varchar2,
        param_msg_type Out Number,
        param_msg      Out Varchar2
    ) As

        Cursor app_recs Is
            Select
                Trim(substr(txt, instr(txt, ',', 1, level) + 1, instr(txt, ',', 1, level + 1) - instr(txt, ',', 1, level) - 1))
                As app_no
            From
                (
                    Select
                        ',' || param_list_appno || ',' As txt
                    From
                        dual
                )
            Connect By
                level <= length(txt) - length(replace(txt, ',', '')) - 1;

        v_cur_app Varchar2(60);
        v_old_app Varchar2(60);
        v_count   Number;
    Begin
        For cur_app In app_recs
        Loop
            v_cur_app := replace(cur_app.app_no, chr(39));

            --check leave is approved
            Select
                Count(*)
            Into
                v_count
            From
                ss_leaveapp
            Where
                Trim(app_no)          = Trim(v_cur_app)
                And nvl(hrd_apprl, 0) = 1;
            If v_count = 0 Then
                Continue;
            End If;
            ---***----

            Select
                Count(*)
            Into
                v_count
            From
                ss_pl_revision_mast
            Where
                Trim(new_app_no) = Trim(v_cur_app);

            If v_count > 0 Then
                Select
                    old_app_no
                Into
                    v_old_app
                From
                    ss_pl_revision_mast
                Where
                    Trim(new_app_no) = Trim(v_cur_app);

                Insert Into ss_pl_revision_app (
                    app_no,
                    empno,
                    app_date,
                    rep_to,
                    projno,
                    caretaker,
                    leaveperiod,
                    leavetype,
                    bdate,
                    edate,
                    reason,
                    mcert,
                    work_ldate,
                    resm_date,
                    contact_add,
                    contact_phn,
                    contact_std,
                    last_hrs,
                    last_mn,
                    resm_hrs,
                    resm_mn,
                    dataentryby,
                    office,
                    hod_apprl,
                    hod_apprl_dt,
                    hod_code,
                    hrd_apprl,
                    hrd_apprl_dt,
                    hrd_code,
                    discrepancy,
                    user_tcp_ip,
                    hod_tcp_ip,
                    hrd_tcp_ip,
                    hodreason,
                    hrdreason,
                    hd_date,
                    hd_part,
                    lead_apprl,
                    lead_apprl_dt,
                    lead_code,
                    lead_tcp_ip,
                    lead_apprl_empno,
                    lead_reason
                )
                Select
                    app_no,
                    empno,
                    app_date,
                    rep_to,
                    projno,
                    caretaker,
                    leaveperiod,
                    leavetype,
                    bdate,
                    edate,
                    reason,
                    mcert,
                    work_ldate,
                    resm_date,
                    contact_add,
                    contact_phn,
                    contact_std,
                    last_hrs,
                    last_mn,
                    resm_hrs,
                    resm_mn,
                    dataentryby,
                    office,
                    hod_apprl,
                    hod_apprl_dt,
                    hod_code,
                    hrd_apprl,
                    hrd_apprl_dt,
                    hrd_code,
                    discrepancy,
                    user_tcp_ip,
                    hod_tcp_ip,
                    hrd_tcp_ip,
                    hodreason,
                    hrdreason,
                    hd_date,
                    hd_part,
                    lead_apprl,
                    lead_apprl_dt,
                    lead_code,
                    lead_tcp_ip,
                    lead_apprl_empno,
                    lead_reason
                From
                    ss_leaveapp
                Where
                    Trim(app_no) = Trim(v_old_app);

                Delete
                    From ss_leaveapp
                Where
                    Trim(app_no) = Trim(v_old_app);

                Delete
                    From ss_leaveledg
                Where
                    Trim(app_no) = Trim(v_old_app);

            End If;

            Insert Into ss_leaveledg(
                app_no,
                app_date,
                leavetype,
                description,
                empno,
                leaveperiod,
                db_cr,
                tabletag,
                bdate,
                edate,
                adj_type,
                hd_date,
                hd_part,
                is_covid_sick_leave
            )
            Select
                app_no,
                app_date,
                leavetype,
                reason,
                empno,
                leaveperiod * - 1,
                'D',
                1,
                bdate,
                edate,
                'LA',
                hd_date,
                hd_part,
                is_covid_sick_leave
            From
                ss_leaveapp
            Where
                Trim(app_no) = Trim(v_cur_app);

            v_cur_app := Null;
        End Loop;

        param_msg_type := ss.success;

    /*      
          for cur_app in app_recs loop
              v_cur_app := trim(replace(cur_app.app_no,chr(39)));
              Select v_old_app_no from ss_pl_revision_mast
                where trim(new_app_no) = trim(v_cur_app);
          end loop;
    */
    Exception
        When Others Then
            param_msg_type := ss.failure;
    End;

    Function is_pl_revision(
        param_app_no Varchar2
    ) Return Number Is
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_pl_revision_mast
        Where
            Trim(new_app_no) = Trim(param_app_no);

        If v_count = 0 Then
            Return 0;
        Else
            Return 1;
        End If;
    End;

    Procedure validate_cl(
        param_empno            Varchar2,
        param_bdate            Date,
        param_edate            Date,
        param_half_day_on      Number,
        param_leave_period Out Number,
        param_msg_type     Out Number,
        param_msg          Out Varchar2
    ) As

        v_leave_period   Number;
        v_max_days       Number;
        v_failure_number Number := 0;
        v_cl_combined    Number;
        v_cumu_cl        Number;
        v_co_spc_co      Number;
        v_spc_co_spc     Number;
        v_bdate          Date;
        v_edate          Date;
    Begin
        param_msg_type     := ss.success;
        v_cumu_cl          := 0;
        --Cannot avail leave on holiday.
        If checkholiday(param_bdate) > 0 Or checkholiday(param_edate) > 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Cannot avail leave on holiday. ';
        End If;

        --CL cannot be more then 3 days.

        If param_half_day_on = half_day_on_none Then
            v_max_days := 3;
        Else
            v_max_days := 3;
        End If;

        v_leave_period     := calc_leave_period(
                                  param_bdate,
                                  param_edate,
                                  'CL',
                                  param_half_day_on
                              );
        param_leave_period := v_leave_period;
        If v_leave_period > v_max_days Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL cannot be more then 3 days. ';
        End If;
        --CL cannot be less then 3 days.

        v_cl_combined      := validate_cl_sl_co(
                                  param_empno,
                                  param_bdate,
                                  param_edate,
                                  param_half_day_on,
                                  'CL'
                              );
        If v_cl_combined = leave_combined_with_csp Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL and CL/PL/SL cannot be availed together. ';
        Elsif v_cl_combined = leave_combined_over_lap Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Leave has already been availed on same day. ';
        End If;

        --R E T U R N 

        Return;
        --R E T U R N 
        --Below processing not required since rule has Changed
        --Can avail leave adjacent to any leavetype except SL cannot be adjacent to SL

        -- X X X X X X X X X X X 
        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            v_cumu_cl := get_continuous_cl_sum(
                             param_empno,
                             param_edate,
                             c_forward
                         );
        End If;

        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            v_cumu_cl := nvl(v_cumu_cl, 0) + get_continuous_cl_sum(
                             param_empno,
                             param_bdate,
                             c_reverse
                         );
        End If;

        v_cumu_cl          := v_cumu_cl / 8;
        If v_cumu_cl + v_leave_period > v_max_days Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL cannot be availed for more than 3 days continuously. ';
        End If;

        v_bdate            := Null;
        v_edate            := Null;
        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            v_bdate := get_date_4_continuous_leave(
                           param_empno,
                           param_bdate,
                           leave_type_cl,
                           c_reverse
                       );
        End If;

        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            v_edate := get_date_4_continuous_leave(
                           param_empno,
                           param_edate,
                           leave_type_cl,
                           c_forward
                       );
        End If;

        v_co_spc_co        := validate_co_spc_co(
                                  param_empno,
                                  nvl(v_bdate, param_bdate),
                                  nvl(v_edate, param_edate),
                                  param_half_day_on
                              );

        If v_co_spc_co = ss.failure Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL cannot be availed with trailing and preceding CO - CO-CL-CO. ';
        End If;

        v_spc_co_spc       := validate_spc_co_spc(
                                  param_empno,
                                  nvl(v_bdate, param_bdate),
                                  nvl(v_edate, param_edate),
                                  param_half_day_on
                              );

        If v_spc_co_spc = ss.failure Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL cannot be availed when trailing and preceding to CO. "CL-SL-PL  -CO-  CL-SL-PL"';
        End If;

    End validate_cl;

    Function get_continuous_leave_sum(
        param_empno           Varchar2,
        param_date            Date,
        param_leave_type      Varchar2,
        param_reverse_forward Varchar2
    ) Return Number Is

        v_app_no       Varchar2(60);
        v_cumu_leave   Number;
        v_lw_date      Date;
        v_leave_period Number;
        v_leave_bdate  Date;
        v_leave_edate  Date;
    Begin
        v_cumu_leave := 0;
        v_lw_date    := getlastworkingday(param_date, param_reverse_forward);
        Loop
            Begin
                Select
                    app_no
                Into
                    v_app_no
                From
                    ss_leave_app_ledg
                Where
                    empno             = param_empno
                    And (v_lw_date Between bdate And edate
                        And leavetype = param_leave_type);

                Select
                    leaveperiod,
                    bdate,
                    edate
                Into
                    v_leave_period,
                    v_leave_bdate,
                    v_leave_edate
                From
                    ss_leaveapp
                Where
                    Trim(app_no) = Trim(v_app_no);

                v_cumu_leave := v_cumu_leave + v_leave_period;
                If param_reverse_forward = c_forward Then
                    v_lw_date := getlastworkingday(v_leave_edate, c_forward);
                Else
                    v_lw_date := getlastworkingday(v_leave_bdate, c_reverse);
                End If;

            Exception
                When Others Then
                    Exit;
            End;
        End Loop;

        Return v_cumu_leave;
    End;

    Function get_continuous_sl_sum(
        param_empno           Varchar2,
        param_date            Date,
        param_reverse_forward Varchar2
    ) Return Number Is

        v_app_no       Varchar2(60);
        v_cumu_leave   Number;
        v_lw_date      Date;
        v_leave_period Number;
        v_leave_bdate  Date;
        v_leave_edate  Date;
        v_prev_lw_dt   Date;
        v_date_diff    Number := 0;
    Begin
        v_cumu_leave := 0;
        v_prev_lw_dt := param_date;
        v_lw_date    := getlastworkingday(param_date, param_reverse_forward);
        Loop
            Begin
                Select
                    app_no
                Into
                    v_app_no
                From
                    ss_leave_app_ledg
                Where
                    empno             = param_empno
                    And (v_lw_date Between bdate And edate
                        And leavetype = leave_type_sl);

                Select
                    leaveperiod,
                    bdate,
                    edate
                Into
                    v_leave_period,
                    v_leave_bdate,
                    v_leave_edate
                From
                    ss_leaveapp
                Where
                    Trim(app_no) = Trim(v_app_no);

                v_cumu_leave := v_cumu_leave + v_leave_period;

                -- S T A R T
                -- ADD UP holidays between Continuous SL
                If param_reverse_forward = c_forward Then
                    v_date_diff  := trunc(v_lw_date, 'DDD') - trunc(v_prev_lw_dt, 'DDD');
                    v_prev_lw_dt := v_lw_date;
                    v_lw_date    := getlastworkingday(v_leave_edate, c_forward);
                Else
                    v_date_diff  := trunc(v_prev_lw_dt, 'DDD') - trunc(v_lw_date, 'DDD');
                    v_prev_lw_dt := v_lw_date;
                    v_lw_date    := getlastworkingday(v_leave_bdate, c_reverse);
                End If;

                If v_date_diff > 1 Then
                    v_cumu_leave := v_cumu_leave + (v_date_diff * 8);
                End If;

                v_date_diff  := 0;
            -- ADD UP holidays between Continuous SL
            -- E N D
            Exception
                When Others Then
                    Exit;
            End;
        End Loop;

        Return v_cumu_leave;
    End;

    Function validate_cl_sl_co(
        param_empno       Varchar2,
        param_bdate       Date,
        param_edate       Date,
        param_half_day_on Number,
        param_leave_type  Varchar2
    ) Return Number Is
        v_count          Number;
        v_prev_work_date Date;
        v_next_work_date Date;
        v_results        Number;
    Begin

        --Check Overlap
        Select
            Count(*)
        Into
            v_count
        From
            ss_leave_app_ledg
        Where
            empno = param_empno
            And ((param_bdate Between bdate And edate
                    Or param_edate Between bdate And edate)
                Or bdate Between param_bdate And param_edate);

        If v_count > 0 Then
            Return leave_combined_over_lap;
        End If;
        --Check Overlap     

        --Check CL/SL/PL Combination
        v_prev_work_date := getlastworkingday(param_bdate, '-');
        v_next_work_date := getlastworkingday(param_edate, '+');
        If param_leave_type In ('PL', 'CL', 'CO') Then
            /*
            Select
                Count(*)
            Into v_count
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And ( Trunc(v_prev_work_date) Between bdate And edate
                      Or Trunc(v_next_work_date) Between bdate And edate )
                And leavetype Not In (
                    'CO'
                ); -- Combination with CO is allowed

            If v_count > 0 Then
                Return leave_combined_with_csp;
            End If;
            */
            Null;
        Elsif param_leave_type = 'SL' Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And (trunc(v_prev_work_date) Between bdate And edate
                    Or trunc(v_next_work_date) Between bdate And edate)
                And leavetype Not In (
                    'CL', 'PL', 'CO'
                ); -- Combination with CO is allowed

            If v_count > 0 Then
                Return leave_combined_sl_with_sl;
            End If;
            /*
        Elsif param_leave_type = 'CL' Then
            Select
                Count(*)
            Into v_count
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And ( Trunc(v_prev_work_date) Between bdate And edate
                      Or Trunc(v_next_work_date) Between bdate And edate )
                And leavetype Not In (
                    'CO',
                    'CL'
                ); -- Combination with CO is allowed

            If v_count > 0 Then
                Return leave_combined_with_csp;
            End If;
        Elsif param_leave_type = 'CO' Then*/
            /*
              Select count(*) Into v_count From ss_leave_app_ledg
                Where empno = param_empno  
                and (trunc(v_prev_work_date) Between bdate And edate 
                      Or trunc(v_next_work_date) Between bdate And edate 
                    );
              if v_count <> 0 Then
                  --Check   C O   C O   combination
                  check_co_co_combination(param_empno,param_bdate,param_edate,v_results);
                  if v_results = ss.failure Then
                      return leave_combined_with_co;
                  End If;
              End if;
              */
            --Null;
        End If;

        Return leave_combined_with_none;
        --Check CL/SL/PL Combination
    End validate_cl_sl_co;

    Function validate_co_spc_co(
        param_empno       Varchar2,
        param_bdate       Date,
        param_edate       Date,
        param_half_day_on Number
    ) Return Number Is
        v_prev_date Date;
        v_next_date Date;
        v_count     Number;
    Begin
        v_prev_date := getlastworkingday(param_bdate, c_reverse);
        v_next_date := getlastworkingday(param_edate, c_forward);
        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            Begin
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_leave_app_ledg
                Where
                    empno         = param_empno
                    And leavetype = leave_type_co
                    And v_next_date Between bdate And edate;

                If v_count = 0 Then
                    Return ss.success;
                End If;
            End;
        End If;

        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            Begin
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_leave_app_ledg
                Where
                    empno         = param_empno
                    And leavetype = leave_type_co
                    And v_prev_date Between bdate And edate;

                If v_count = 0 Then
                    Return ss.success;
                Else
                    Return ss.failure;
                End If;

            End;
        End If;

    End;

    Function validate_spc_co_spc(
        param_empno       Varchar2,
        param_bdate       Date,
        param_edate       Date,
        param_half_day_on Number
    ) Return Number Is

        v_lw_date   Date;
        v_bdate     Date := param_bdate;
        v_edate     Date := param_edate;
        v_count     Number;
        v_leavetype Varchar2(2);
    Begin
        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            Begin
                Loop
                    v_edate := getlastworkingday(v_edate, c_forward);
                    Select
                        leavetype,
                        edate
                    Into
                        v_leavetype,
                        v_edate
                    From
                        ss_leave_app_ledg
                    Where
                        empno = param_empno
                        And v_edate Between bdate And edate;

                    If v_leavetype <> leave_type_co Then
                        Return ss.failure;
                    End If;
                End Loop;

            Exception
                When Others Then
                    If param_half_day_on = hd_bdate_presnt_part_2 Then
                        Return ss.success;
                    Else
                        Null;
                    End If;
            End;
        End If;

        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            Begin
                Loop
                    v_bdate := getlastworkingday(v_bdate, c_reverse);
                    Select
                        leavetype,
                        bdate
                    Into
                        v_leavetype,
                        v_bdate
                    From
                        ss_leave_app_ledg
                    Where
                        empno = param_empno
                        And v_bdate Between bdate And edate;

                    If v_leavetype <> leave_type_co Then
                        Return ss.failure;
                    End If;
                End Loop;

            Exception
                When Others Then
                    Return ss.success;
            End;

        End If;

    Exception
        When Others Then
            Return ss.success;
    End;

    Function get_date_4_continuous_leave(
        param_empno           Varchar2,
        param_date            Date,
        param_leave_type      Varchar2,
        param_forward_reverse Varchar2
    ) Return Date Is
        v_ret_date Date;
        v_date     Date;
        v_bdate    Date;
        v_edate    Date;
    Begin
        v_ret_date := param_date;
        v_date     := param_date;
        Loop
            v_date     := getlastworkingday(v_date, param_forward_reverse);
            Select
                bdate,
                edate
            Into
                v_bdate,
                v_edate
            From
                ss_leave_app_ledg
            Where
                empno         = param_empno
                And v_date Between bdate And edate
                And leavetype = param_leave_type;

            If param_forward_reverse = c_forward Then
                v_date := v_edate;
            Else
                v_date := v_bdate;
            End If;

            v_ret_date := v_date;
        End Loop;

    Exception
        When Others Then
            Return v_ret_date;
    End get_date_4_continuous_leave;

    Function check_co_with_adjacent_leave(
        param_empno           Varchar2,
        param_date            Date,
        param_forward_reverse Varchar2
    ) Return Number Is

        v_lw_date   Date;
        v_leavetype Varchar2(2) := 'CO';
        v_ret_val   Number      := ss.success;
        v_date      Date;
    Begin
        v_date := param_date;
        Loop
            If v_leavetype In ('CL', 'SL', 'CO') Then
                v_date := get_date_4_continuous_leave(
                              param_empno,
                              v_date,
                              v_leavetype,
                              param_forward_reverse
                          );
            End If;

            v_lw_date := getlastworkingday(v_date, param_forward_reverse);
            Select
                Case param_forward_reverse
                    When c_reverse Then
                        bdate
                    Else
                        edate
                End,
                leavetype
            Into
                v_date,
                v_leavetype
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And v_lw_date Between bdate And edate;

            If v_ret_val = leave_with_adjacent Then
                Return ss.failure;
            Else
                v_ret_val := leave_with_adjacent;
            End If;

        End Loop;

    Exception
        When Others Then
            Return v_ret_val;
    End;

    Function get_continuous_cl_sum(
        param_empno           Varchar2,
        param_date            Date,
        param_reverse_forward Varchar2
    ) Return Number Is

        v_app_no       Varchar2(60);
        v_cumu_leave   Number;
        v_lw_date      Date;
        v_leave_period Number;
        v_leave_bdate  Date;
        v_leave_edate  Date;
        v_prev_lw_dt   Date;
        v_date_diff    Number := 0;
    Begin
        v_cumu_leave := 0;
        v_prev_lw_dt := param_date;
        v_lw_date    := getlastworkingday(param_date, param_reverse_forward);
        Loop
            Begin
                Select
                    app_no
                Into
                    v_app_no
                From
                    ss_leave_app_ledg
                Where
                    empno             = param_empno
                    And (v_lw_date Between bdate And edate
                        And leavetype = leave_type_cl);

                Select
                    leaveperiod,
                    bdate,
                    edate
                Into
                    v_leave_period,
                    v_leave_bdate,
                    v_leave_edate
                From
                    ss_leaveapp
                Where
                    Trim(app_no) = Trim(v_app_no);

                v_cumu_leave := v_cumu_leave + v_leave_period;
                If param_reverse_forward = c_forward Then
                    v_prev_lw_dt := v_lw_date;
                    v_lw_date    := getlastworkingday(v_leave_edate, c_forward);
                Else
                    v_prev_lw_dt := v_lw_date;
                    v_lw_date    := getlastworkingday(v_leave_bdate, c_reverse);
                End If;

            Exception
                When Others Then
                    Exit;
            End;
        End Loop;

        Return v_cumu_leave;
    End;

    Procedure add_leave_adj(
        param_empno       Varchar2,
        param_adj_date    Date,
        param_adj_type    Varchar2,
        param_leave_type  Varchar2,
        param_adj_period  Number,
        param_entry_by    Varchar2,
        param_desc        Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2,
        param_narration   Varchar2 Default Null
    ) As

        v_count      Number;
        v_row_adj    ss_leave_adj%rowtype;
        v_row_count  Number;
        v_adj_no     Varchar2(30);
        v_db_cr      Varchar2(1);
        v_adj_type   Varchar2(2);
        v_leave_type Varchar2(2);
        v_adj_period Number(5, 1);
        v_adj_desc   Varchar2(30);
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno      = param_empno
            And status = 1;

        If v_count = 0 Then
            param_success := 'KO';
            param_message := 'Error :- Employee - "' || param_empno || '" does not exists.';
            Return;
        End If;

        If param_adj_date Is Null Then
            param_success := 'KO';
            param_message := 'Error - Adjustment date cannot be blank.';
            Return;
        End If;

        Begin
            Select
                *
            Into
                v_row_adj
            From
                (
                    Select
                        *
                    From
                        ss_leave_adj
                    Where
                        adj_no Like 'ADJ/%'
                        And empno = Trim(param_empno)
                    Order By adj_dt Desc,
                        adj_no Desc
                )
            Where
                Rownum = 1;

            If to_char(v_row_adj.adj_dt, 'yyyy') <> to_char(sysdate, 'yyyy') Then
                v_row_count := 0;
            Else
                v_row_count := to_number(substr(v_row_adj.adj_no, instr(v_row_adj.adj_no, '/', -1) + 1));
            End If;

        Exception
            When Others Then
                v_row_count := 0;
        End;

        Select
            Count(*)
        Into
            v_count
        From
            ss_leave_adj_mast
        Where
            adj_type || dc = param_adj_type;

        If v_count = 0 Then
            param_success := 'KO';
            param_message := 'Error - ' || 'Leave Adjustment type ' || param_adj_type || ' not found';
            Return;
        End If;

        If param_narration Is Not Null Then
            v_adj_desc := substr(param_narration, 1, 30);
        Else
            Select
                description
            Into
                v_adj_desc
            From
                ss_leave_adj_mast
            Where
                adj_type || dc = param_adj_type;

        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_leavetype
        Where
            leavetype = Trim(param_leave_type);

        If v_count = 0 Then
            param_success := 'KO';
            param_message := 'Error - ' || 'Leave type ' || param_leave_type || 'not found';
            Return;
        End If;

        v_adj_type    := substr(param_adj_type, 1, 2);
        v_db_cr       := substr(param_adj_type, 3, 1);
        v_adj_no      := 'ADJ/' || param_empno || '/' || to_char(sysdate, 'yyyy') || '/' || lpad(v_row_count + 1, 4, '0');

        If v_db_cr = 'D' Then
            v_adj_period := param_adj_period * -8;
        Else
            v_adj_period := param_adj_period * 8;
        End If;

        Insert Into ss_leave_adj (
            empno,
            adj_dt,
            adj_no,
            leavetype,
            db_cr,
            adj_type,
            bdate,
            leaveperiod,
            description,
            dataentryby,
            entry_date
        )
        Values (
            param_empno,
            sysdate,
            v_adj_no,
            param_leave_type,
            v_db_cr,
            v_adj_type,
            param_adj_date,
            v_adj_period,
            param_desc,
            param_entry_by,
            sysdate
        );

        Insert Into ss_leaveledg (
            empno,
            app_date,
            app_no,
            leavetype,
            db_cr,
            adj_type,
            bdate,
            leaveperiod,
            tabletag,
            description
        )
        Values (
            param_empno,
            sysdate,
            v_adj_no,
            param_leave_type,
            v_db_cr,
            v_adj_type,
            param_adj_date,
            v_adj_period,
            0,
            v_adj_desc
        );

        Commit;
        param_success := 'OK';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Error - ' || sqlcode || ' - ' || sqlerrm;
    End;

End leave;
/
