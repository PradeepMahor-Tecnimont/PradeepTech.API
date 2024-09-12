Create Or Replace Package Body selfservice.iot_swp_qry As

    Function get_monday_date(p_date Date) Return Date As
        v_day_num Number;
    Begin
        v_day_num := to_number(to_char(p_date, 'd'));
        If v_day_num <= 2 Then
            Return p_date + (2 - v_day_num);
        Else
            Return p_date - v_day_num + 2;
        End If;

    End;

    Function get_friday_date(p_date Date) Return Date As
        v_day_num Number;
    Begin
        v_day_num := to_char(p_date, 'd');

        Return p_date + (6 - v_day_num);

    End;

    Function fn_emp_primary_workspace_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_assign_code Varchar2 Default Null,
        p_empno       Varchar2 Default Null,

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
            With
                assign_codes As (
                    Select
                        assign
                    From
                        (
                            Select
                                costcode As assign
                            From
                                ss_costmast
                            Where
                                hod = v_empno
                            Union
                            Select
                                parent As assign
                            From
                                ss_user_dept_rights
                            Where
                                empno = v_empno
                        )
                    Where
                        assign = nvl(p_assign_code, assign)
                ),
                primary_work_space As(
                    Select
                        empno, a.primary_workspace, active_code
                    From
                        swp_primary_workspace a
                    Where
                        active_code = (
                            Select
                                Max(active_code)
                            From
                                swp_primary_workspace b
                            Where
                                b.empno = a.empno
                        )
                )
            Select
                *
            From
                (
                    Select
                        a.empno                                                           As empno,
                        a.name                                                            As employee_name,
                        a.assign,
                        a.parent,
                        a.office,
                        a.emptype,
                        iot_swp_common.get_emp_work_area(p_person_id, p_meta_id, a.empno) work_area,
                        iot_swp_common.get_emp_dms_type_code(a.empno)                     emp_dms_type_code,
                        iot_swp_common.get_emp_dms_type_desc(a.empno)                     emp_dms_type_desc,
                        a.grade                                                           As emp_grade,
                        nvl(b.primary_workspace, 0)                                       As primary_workspace,
                        Row_Number() Over(Order By a.empno)                               As row_number,
                        Count(*) Over()                                                   As total_row
                    From
                        ss_emplmast        a,
                        primary_work_space b,
                        assign_codes       ac
                    Where
                        a.empno      = b.empno(+)
                        And a.assign = ac.assign
                        And a.status = 1
                        And a.empno  = nvl(p_empno, a.empno)
                        And a.assign Not In (
                            Select
                                assign
                            From
                                swp_exclude_assign
                        )
                        And a.emptype In (
                            Select
                                emptype
                            From
                                swp_include_emptype
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End fn_emp_primary_workspace_list;

    /*
    Pass Date(dd-Mon-yyyy) and Get Week days 

     select
      next_day(to_date(:x,'DD-MON-YYYY'),'MON') +
        case when to_number(to_char(to_date(:x,'DD-MON-YYYY'),'D')) in (1,7) then -1 else -8 end +
        rownum dte
    from  dual
    connect by level <= 5;

    */

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
        v_start_date         Date := get_monday_date(p_date) - 1;
        v_end_date           Date := get_friday_date(p_date);
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

    Function fn_week_attend_planning(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date     Default sysdate,
        p_assign_code Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query              Varchar2(4200);
        v_start_date         Date := get_monday_date(p_date) - 1;
        v_end_date           Date := get_friday_date(p_date);
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

        v_query := c_qry_attendance_planning;
        For c1 In cur_days
        Loop
            If c1.dday = 'MON' Then
                v_query := replace(v_query, '!MON!', chr(39) || c1.yymmdd || chr(39));
            Elsif c1.dday = 'TUE' Then
                v_query := replace(v_query, '!TUE!', chr(39) || c1.yymmdd || chr(39));
            Elsif c1.dday = 'WED' Then
                v_query := replace(v_query, '!WED!', chr(39) || c1.yymmdd || chr(39));
            Elsif c1.dday = 'THU' Then
                v_query := replace(v_query, '!THU!', chr(39) || c1.yymmdd || chr(39));
            Elsif c1.dday = 'FRI' Then
                v_query := replace(v_query, '!FRI!', chr(39) || c1.yymmdd || chr(39));
            End If;
        End Loop;
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
        Open c For v_query Using v_empno, p_row_number, p_page_length, v_start_date, v_end_date, p_person_id, p_meta_id, p_assign_code;

        Return c;

    End;

    Function fn_emp_week_attend_planning(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2,
        p_date      Date
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query              Varchar2(4000);
        v_start_date         Date := get_monday_date(trunc(p_date));
        v_end_date           Date := get_friday_date(trunc(p_date));
    Begin

        Open c For

            With
                atnd_days As (
                    Select
                        w.empno,
                        Trim(w.attendance_date) As attendance_date,
                        Trim(w.deskid)          As deskid,
                        1                       As planned
                    From
                        swp_smart_attendance_plan w
                    Where
                        w.empno = p_empno
                        And attendance_date Between v_start_date And v_end_date
                )
                
            Select
                e.empno                   As empno,
                dd.d_day,
                dd.d_date,
                nvl(atnd_days.planned, 0) As planned,
                atnd_days.deskid          As deskid
            From
                ss_emplmast     e,
                ss_days_details dd,
                atnd_days
            Where
                e.empno       = Trim(p_empno)
                And dd.d_date = atnd_days.attendance_date(+)
                And d_date Between v_start_date And v_end_date
            Order By
                dd.d_date;

        Return c;

    End;

    Function fn_work_area_for_smartwork(
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
                    /*Select
                    Distinct
                        area.area_key_id                              As work_area,
                        area.area_desc                                As area_desc,
                        area.AREA_CATG_CODE                           As AREA_CATG_CODE,
                        iot_swp_qry.get_area_total_desk(area.area_key_id)      As total_count, 
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id)   As occupied_count,                         
                        ( 
                           iot_swp_qry.get_area_total_desk(area.area_key_id) 
                                -
                           iot_swp_qry.get_area_occupied_desk(area.area_key_id)                        
                        )                                             As available_count,
                        Row_Number() Over (Order By area_key_id Desc) row_number,
                        Count(*) Over ()                              total_row
                    From
                        dms.dm_desk_areas area*/

                    Select
                    Distinct
                        area.area_key_id                                     As work_area,
                        area.area_desc                                       As area_desc,
                        area.AREA_CATG_CODE                                  As AREA_CATG_CODE,
                        iot_swp_qry.get_area_total_desk(area.area_key_id)    As total_count,
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id) As occupied_count,
                        (
                        iot_swp_qry.get_area_total_desk(area.area_key_id)
                        -
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id)
                        )                                                    As available_count,
                        Row_Number() Over (Order By area_key_id Desc)        As row_number,
                        Count(*) Over ()                                     As total_row
                    From
                        dms.dm_desk_areas area
                    Where
                        area.AREA_CATG_CODE = 'OK'
                        And ((
                        iot_swp_qry.get_area_total_desk(area.area_key_id)
                        -
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id)
                        ) > 0)
                    Union All
                    Select
                    Distinct
                        area.area_key_id                                     As work_area,
                        area.area_desc                                       As area_desc,
                        area.AREA_CATG_CODE                                  As AREA_CATG_CODE,
                        iot_swp_qry.get_area_total_desk(area.area_key_id)    As total_count,
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id) As occupied_count,
                        (
                        iot_swp_qry.get_area_total_desk(area.area_key_id)
                        -
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id)
                        )                                                    As available_count,
                        Row_Number() Over (Order By area_key_id Desc)        As row_number,
                        Count(*) Over ()                                     As total_row
                    From
                        dms.dm_desk_areas area
                    Where
                        area.AREA_CATG_CODE = 'KO'
                        And ((
                        iot_swp_qry.get_area_total_desk(area.area_key_id)
                        -
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id)
                        ) > 0)
                        And Not Exists (
                            Select
                                *
                            From
                                dms.dm_desk_areas da
                            Where
                                da.AREA_CATG_CODE = 'OK'
                                And ((
                                iot_swp_qry.get_area_total_desk(da.area_key_id)
                                -
                                iot_swp_qry.get_area_occupied_desk(da.area_key_id)
                                ) > 0)
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                work_area;
        Return c;

    End fn_work_area_for_smartwork;

    Function fn_work_area_for_officework(
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
                    Distinct
                        area.area_key_id                                     As work_area,
                        area.area_desc                                       As area_desc,
                        area.AREA_CATG_CODE                                  As AREA_CATG_CODE,
                        iot_swp_qry.get_area_total_desk(area.area_key_id)    As total_count,
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id) As occupied_count,
                        (
                        iot_swp_qry.get_area_total_desk(area.area_key_id)
                        -
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id)
                        )                                                    As available_count,
                        Row_Number() Over (Order By area_key_id Desc)        As row_number,
                        Count(*) Over ()                                     As total_row
                    From
                        dms.dm_desk_areas area
                    Where
                        area.AREA_CATG_CODE = 'KO'
                        And ((
                        iot_swp_qry.get_area_total_desk(area.area_key_id)
                        -
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id)
                        ) > 0)

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                work_area;
        Return c;

    End fn_work_area_for_officework;

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
                        --And mast.deskid Not In (Select Distinct b.deskid From swp_smart_attendance_plan b)
                        And mast.deskid
                        Not In(
                            Select
                            Distinct swptbl.deskid
                            From
                                swp_smart_attendance_plan swptbl
                                where (trunc(ATTENDANCE_DATE) = TRUNC(p_date) or p_date is null)
                            Union
                            Select
                            Distinct c.deskid
                            From
                                DM_VU_EMP_DESK_MAP_SWP_PLAN c
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                deskid,
                seat_no;
        Return c;
    End fn_work_area_desk;

    Function get_area_total_desk(
        p_area_key_id Varchar2
    ) Return Number As
        v_count Number := 0;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster mast
        Where
            Trim(mast.work_area) = Trim(p_area_key_id);

        Return v_count;
    End;

    Function get_area_occupied_desk(
        p_area_key_id Varchar2
    ) Return Number As
        v_count Number := 0;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster mast
        Where
            Trim(mast.work_area) = Trim(p_area_key_id)
            And mast.deskid
            In (
                Select
                    swptbl.deskid
                From
                    swp_smart_attendance_plan swptbl
                Where
                    swptbl.attendance_date > sysdate
            );
        Return v_count;
    End;

    Function fn_area_list_for_smartwork(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return typ_area_list
        Pipelined
    Is
        tab_area_list_ok     typ_area_list;
        tab_area_list_ko     typ_area_list;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        Open cur_area_list_for_ok(p_date,Null, Null, Null, p_row_number, p_page_length);
        Loop
            Fetch cur_area_list_for_ok Bulk Collect Into tab_area_list_ok Limit 50;
            For i In 1..tab_area_list_ok.count
            Loop
                /*
                  If (tab_area_list_ok(i).AVAILABLE_COUNT <= 0) Then
                
                               Open cur_area_list_for_ko(tab_area_list_ok(i).OFFICE, tab_area_list_ok(i).FLOOR, tab_area_list_ok(i).WING,
                               p_row_number,
                                                         p_page_length);
                               Loop
                                  Fetch cur_area_list_for_ko Bulk Collect Into tab_area_list_ko Limit 50;
                                  For i In 1..tab_area_list_ko.count
                                  Loop
                                     Pipe Row(tab_area_list_ko(i));
                                  End Loop;
                                  Exit When cur_area_list_for_ko%notfound;
                               End Loop;
                               Close cur_area_list_for_ko;
                                  
                             else
                            
                              Pipe Row(tab_area_list_ok(i));
                              
                            End If;
                */

                Pipe Row(tab_area_list_ok(i));

            End Loop;
            Exit When cur_area_list_for_ok%notfound;
        End Loop;
        Close cur_area_list_for_ok;
        Return;

    End fn_area_list_for_smartwork;

    Function fn_reserved_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return typ_area_list
        Pipelined
    Is
        tab_area_list_ok     typ_area_list;
        tab_area_list_ko     typ_area_list;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        Open cur_area_list_for_ok(p_date,Null, Null, Null, p_row_number, p_page_length);
        Loop
            Fetch cur_area_list_for_ok Bulk Collect Into tab_area_list_ok Limit 50;
            For i In 1..tab_area_list_ok.count
            Loop
                Pipe Row(tab_area_list_ok(i));

            End Loop;
            Exit When cur_area_list_for_ok%notfound;
        End Loop;
        Close cur_area_list_for_ok;
        Return;

    End fn_reserved_area_list;

    Function fn_general_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return typ_area_list
        Pipelined
    Is
        tab_area_list_ko     typ_area_list;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        Open cur_area_list_for_ko(Null, Null, Null, p_row_number, p_page_length);
        Loop
            Fetch cur_area_list_for_ko Bulk Collect Into tab_area_list_ko Limit 50;
            For i In 1..tab_area_list_ko.count
            Loop
                Pipe Row(tab_area_list_ko(i));

            End Loop;
            Exit When cur_area_list_for_ko%notfound;
        End Loop;
        Close cur_area_list_for_ko;
        Return;

    End fn_general_area_list;

End iot_swp_qry;