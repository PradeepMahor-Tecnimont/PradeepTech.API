--------------------------------------------------------
--  File created - Thursday-April-21-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--IOT_SWP_SMART_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE_QRY" As

    c_qry_attendance_planning Varchar2(6000) := ' 
With
    params As (
        Select
            :p_person_id   As p_person_id,
            :p_meta_id     As p_meta_id,
            :p_row_number  As p_row_number,
            :p_page_length As p_page_length,
            
            :p_start_date  As p_start_date,
            :p_end_date    As p_end_date,
            :p_assign_code    As p_assign_code,
            :p_assign_csv     As p_assign_csv,
            :p_emptype_csv    As p_emptype_csv,
            :p_grades_csv     As p_grades_csv,
            :p_generic_search As p_generic_search,
            :p_desk_assignment_status as p_desk_assignment_status
        From
            dual
    ),
    attend_plan As (
        Select
            empno, attendance_date,deskid
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
                    ss_emplmast                  ce, 
					params 
                Where
                    status = 1
                    !CE_ASSIGN!
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
                        case when a.empno is null then 0 else 1 end planned,
                        a.deskid as deskid,
                        to_char(a.attendance_date, ''yyyymmdd'') As d_days
                    From
                        ss_emplmast  e,
                        attend_plan  a,
                        
                        params
                    Where
                        e.empno In (
                            select empno from (
                                Select
                                    *
                                From
                                    swp_primary_workspace m
                                Where
                                    start_date =
                                    (
                                        Select
                                            Max(start_date)
                                        From
                                            swp_primary_workspace c,params
                                        Where
                                            c.empno = m.empno
                                            And start_date <= params.p_end_date
                                    )) where primary_workspace=2
                        )
                        !E_ASSIGN!
                        And e.status = 1
                        And e.empno  = a.empno(+)                
                            !DESK_ASSIGNMENT_STATUS!
                            !GENERIC_SEARCH!            
                            And e.emptype In (
                            !EMPTYPE_SUBQUERY!
                    )
                            !GRADES_SUBQUERY!

                    ) 
                    
                    
                    Pivot
                    (
                    !PIVOT_FOR!
                    For d_days In (!MON! As mon, !TUE! As tue, !WED! As wed, !THU! As thu,
                    !FRI! As fri)
                    )

            ) data
    ) full_data, params
Where
    row_number Between (nvl(params.p_row_number, 0) + 1) And (nvl(params.p_row_number, 0) + params.p_page_length)';

    where_clause_generic_search Varchar2(200) := ' and (e.name like params.p_generic_search or e.empno like params.p_generic_search ) ';
    where_clause_e_assign_code Varchar2(100) := ' And e.assign = params.p_assign_code ';
    where_clause_ce_assign_code Varchar2(100) := ' And ce.assign = params.p_assign_code ';

    sub_qry_ce_assign_csv Varchar2(400) := ' And ce.assign in (
                    Select
                        regexp_substr(params.p_assign_csv, ''[^,]+'', 1, level) assign
                    From
                        dual
                    Connect By
                        level <=
                        length(params.p_assign_csv) - length(replace(params.p_assign_csv, '','')) + 1
                )';

    sub_qry_e_assign_csv Varchar2(400) := ' And e.assign in (
                    Select
                        regexp_substr(params.p_assign_csv, ''[^,]+'', 1, level) assign
                    From
                        dual
                    Connect By
                        level <=
                        length(params.p_assign_csv) - length(replace(params.p_assign_csv, '','')) + 1
                )';

    sub_qry_emptype_default Varchar2(200) := ' 
Select
    emptype
From
    swp_include_emptype
';

    sub_qry_emptype_csv Varchar2(400) := ' 
Select
    regexp_substr(params.p_emptype_csv, ''[^,]+'', 1, level) emptype
From
    dual
Connect By
    level <=
    length(params.p_emptype_csv) - length(replace(params.p_emptype_csv, '','')) + 1
';

    sub_qry_grades_csv Varchar2(400) := ' and e.grade in (
Select
    regexp_substr(params.p_grades_csv, ''[^,]+'', 1, level) grade
From
    dual
Connect By
    level <=
    length(params.p_grades_csv) - length(replace(params.p_grades_csv, '','')) + 1 )
';

    sub_desk_pivot Varchar2(100) := ' max(deskid)  ';
    sub_days_pivot Varchar2(100) := ' Count(d_days) ';

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
            )
        Where
            row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

    Cursor cur_restricted_area_list(p_date        Date,
                                    p_office      Varchar2,
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
                    a.area_catg_code = 'A003'
                Order By a.area_desc, a.office, a.floor

            )
        Where
            row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

    Type typ_area_list Is Table Of cur_general_area_list%rowtype;

    Function fn_reserved_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_general_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2 Default Null,
        p_date        Date     Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;
    Function fn_general_area_restrictedlist(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2 Default Null,
        p_date        Date     Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_work_area_desk(
        p_person_id     Varchar2,
        p_meta_id       Varchar2,

        p_date          Date,
        p_work_area     Varchar2,
        p_area_category Varchar2 Default Null,
        p_office        Varchar2 Default Null,
        p_floor         Varchar2 Default Null,
        p_wing          Varchar2 Default Null,

        p_row_number    Number,
        p_page_length   Number
    ) Return Sys_Refcursor;

    Function fn_restricted_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return typ_area_list
        Pipelined;

    Function fn_emp_week_attend_planning(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2,
        p_date      Date
    ) Return Sys_Refcursor;

    Function fn_week_attend_planning(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_date                   Date     Default sysdate,

        p_assign_code            Varchar2 Default Null,

        p_emptype_csv            Varchar2 Default Null,
        p_grade_csv              Varchar2 Default Null,
        p_generic_search         Varchar2 Default Null,
        p_desk_assignment_status Varchar2 Default Null,
        p_desk_pivot             Number   Default 0,

        p_row_number             Number,
        p_page_length            Number
    ) Return Sys_Refcursor;

    Function fn_current_planning_xl(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_assign_code Varchar2 Default Null
    ) Return Sys_Refcursor;

    Function fn_future_planning_xl(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_assign_code Varchar2 Default Null
    ) Return Sys_Refcursor;

    Function fn_week_attend_planning_all(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_date                   Date     Default sysdate,

        p_assign_csv             Varchar2 Default Null,

        p_emptype_csv            Varchar2 Default Null,
        p_grade_csv              Varchar2 Default Null,
        p_generic_search         Varchar2 Default Null,
        p_desk_assignment_status Varchar2 Default Null,
        p_desk_pivot             Number   Default 0,

        p_row_number             Number,
        p_page_length            Number
    ) Return Sys_Refcursor;

    Function fn_all_current_planning_xl(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date

    ) Return Sys_Refcursor;

End iot_swp_smart_workspace_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_SMART_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE_QRY" As

    c_reserved_catagory    Varchar2(4)          := 'A001';
    c_restricted_area_catg Constant Varchar2(4) := 'A003';
    c_deskblock_4_swpf     Constant Number(1)   := 6;
    c_deskblock_4_swpv     Constant Number(1)   := 7;
    c_deskblock_not_swpf   Constant Number(1)   := -1;
    Function fn_reserved_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        v_area_catg_code     Constant Varchar2(4) := 'A001';
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_count              Number;
    Begin

        Open c For
            With
                plan As(
                    Select
                        deskid
                    From
                        swp_smart_attendance_plan ap
                    Where
                        ap.attendance_date = p_date
                    Union
                    Select
                        deskid
                    From
                        dm_vu_emp_desk_map_swp_plan
                )
            Select
                *
            From
                (
                    Select
                        aa.*,
                        aa.total_count - aa.occupied_count As available_count,
                        Row_Number() Over (Order By area_desc,
                                work_area,
                                office,
                                floor,
                                wing)                      row_number,
                        Count(*) Over ()                   total_row

                    From
                        (
                            Select
                                da.area_catg_code area_category,
                                da.area_desc,
                                dl.work_area,
                                dl.office,
                                dl.floor,
                                dl.wing,
                                Count(dl.deskid)  total_count,
                                Count(ap.deskid)  occupied_count
                            From
                                dm_vu_desk_list  dl,
                                dm_vu_desk_areas da,
                                plan             ap
                            Where
                                da.area_key_id        = dl.work_area
                                And da.area_catg_code = c_reserved_catagory
                                And dl.deskid         = ap.deskid(+)
                            Group By da.area_catg_code,
                                da.area_desc,
                                dl.work_area,
                                dl.office,
                                dl.floor,
                                dl.wing
                        ) aa
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                area_desc,
                work_area,
                office,
                floor,
                wing;
        Return c;

    End fn_reserved_area_list;

    Function fn_general_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2 Default Null,
        p_date        Date     Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_emp_area_code      Varchar2(3);
    Begin
        v_emp_area_code := iot_swp_common.get_emp_work_area_code(p_empno);
        Open c For
            With
                desk_list As (
                    Select
                        *
                    From
                        dm_vu_desk_list  dl,
                        dm_vu_desk_areas da
                    Where
                        da.area_key_id        = dl.work_area
                        And (da.area_catg_code != c_restricted_area_catg
                            Or da.area_key_id = v_emp_area_code
                        )
                        And deskid Not In(
                            Select
                                deskid
                            From
                                dm_vu_desk_lock_swp_plan
                            Where
                                blockreason <> c_deskblock_4_swpv

                        )
                        And deskid Not In(
                            Select
                                deskid
                            From
                                swp_smart_attendance_plan ap
                            Where
                                ap.attendance_date = p_date
                        )
                )
            Select
                *
            From
                (
                    Select
                        a.*,
                        a.total_count - a.occupied_count                            As available_count,
                        Row_Number() Over (Order By area_desc, office, wing, floor) As row_number,
                        Count(*) Over ()                                            As total_row
                    From
                        (
                            Select
                                d.work_area,
                                d.area_catg_code area_category,
                                d.area_desc,
                                d.office,
                                d.floor,
                                d.wing,
                                Count(d.deskid)  total_count,
                                Count(ed.empno)  occupied_count
                            From
                                desk_list                   d,
                                dm_vu_emp_desk_map_swp_plan ed
                            Where
                                d.deskid = ed.deskid(+)
                            Group By office, wing, floor, work_area, area_desc, area_catg_code
                            Order By area_desc, office, wing, floor
                        ) a
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_general_area_list;

    Function fn_general_area_restrictedlist(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2 Default Null,
        p_date        Date     Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_emp_area_code      Varchar2(3);
    Begin
        v_emp_area_code := iot_swp_common.get_emp_work_area_code(p_empno);
        Open c For
            With
                desk_list As (
                    Select
                        *
                    From
                        dm_vu_desk_list  dl,
                        dm_vu_desk_areas da
                    Where
                        da.area_key_id        = dl.work_area
                        And da.area_catg_code = c_restricted_area_catg
                        And da.area_key_id    = v_emp_area_code

                        And deskid Not In(
                            Select
                                deskid
                            From
                                dm_vu_desk_lock_swp_plan
                            Where
                                blockreason <> c_deskblock_4_swpv

                        )
                        And deskid Not In(
                            Select
                                deskid
                            From
                                swp_smart_attendance_plan ap
                            Where
                                ap.attendance_date = p_date
                        )
                )
            Select
                *
            From
                (
                    Select
                        a.*,
                        a.total_count - a.occupied_count                            As available_count,
                        Row_Number() Over (Order By area_desc, office, wing, floor) As row_number,
                        Count(*) Over ()                                            As total_row
                    From
                        (
                            Select
                                d.work_area,
                                d.area_catg_code area_category,
                                d.area_desc,
                                d.office,
                                d.floor,
                                d.wing,
                                Count(d.deskid)  total_count,
                                Count(ed.empno)  occupied_count
                            From
                                desk_list                   d,
                                dm_vu_emp_desk_map_swp_plan ed
                            Where
                                d.deskid = ed.deskid(+)
                            Group By office, wing, floor, work_area, area_desc, area_catg_code
                            Order By area_desc, office, wing, floor
                        ) a
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_general_area_restrictedlist;

    Function fn_work_area_desk(
        p_person_id     Varchar2,
        p_meta_id       Varchar2,

        p_date          Date,
        p_work_area     Varchar2,
        p_area_category Varchar2 Default Null,
        p_office        Varchar2 Default Null,
        p_floor         Varchar2 Default Null,
        p_wing          Varchar2 Default Null,

        p_row_number    Number,
        p_page_length   Number
    ) Return Sys_Refcursor As
        c                        Sys_Refcursor;
        v_empno                  Varchar2(5);
        e_employee_not_found     Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_office                 Varchar2(5);
        v_floor                  dm_vu_desk_list.floor%Type;
        v_wing                   dm_vu_desk_list.wing%Type;
        v_exclude_deskblock_type Number(1);

    Begin
        If p_area_category = c_reserved_catagory Then
            v_exclude_deskblock_type := c_deskblock_4_swpf;
        Else
            v_exclude_deskblock_type := c_deskblock_4_swpv;
        End If;

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        If Trim(p_office) Is Null Then
            v_office := '%';
        Else
            v_office := trim(p_office);
        End If;

        If Trim(p_floor) Is Null Then
            v_floor := '%';
        Else
            v_floor := trim(p_floor);
        End If;

        If Trim(p_wing) Is Null Then
            v_wing := '%';
        Else
            v_wing := trim(p_wing);
        End If;

        Open c For
            Select
                *
            From
                (

                    Select
                        mast.deskid                         As deskid,
                        mast.office                         As office,
                        mast.floor                          As floor,
                        mast.seatno                         As seat_no,
                        mast.wing                           As wing,
                        mast.assetcode                      As asset_code,
                        mast.bay                            As bay,
                        da.area_catg_code                   As area_category,
                        Row_Number() Over (Order By deskid) row_number,
                        Count(*) Over ()                    total_row
                    From
                        dm_vu_desk_list  mast,
                        dm_vu_desk_areas da
                    Where
                        mast.work_area     = da.area_key_id
                        And mast.work_area = Trim(p_work_area)

                        And Trim(mast.office) Like v_office
                        And Trim(mast.floor) Like v_floor
                        And nvl(Trim(mast.wing), '-') Like v_wing

                        And mast.deskid
                        Not In(
                            Select
                                swptbl.deskid
                            From
                                swp_smart_attendance_plan swptbl
                            Where
                                (attendance_date) = (p_date)
                            Union
                            Select
                                c.deskid
                            From
                                dm_vu_emp_desk_map_swp_plan c
                            Union
                            Select
                                deskid
                            From
                                dms.dm_desklock_swp_plan dl
                            Where
                                dl.blockreason <> v_exclude_deskblock_type
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                deskid,
                seat_no;
        Return c;
    End fn_work_area_desk;

    Function fn_restricted_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return typ_area_list
        Pipelined
    Is
        tab_area_list_ok     typ_area_list;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        Open cur_restricted_area_list(p_date, Null, Null, Null, p_row_number, p_page_length);
        Loop
            Fetch cur_restricted_area_list Bulk Collect Into tab_area_list_ok Limit 50;
            For i In 1..tab_area_list_ok.count
            Loop
                Pipe Row(tab_area_list_ok(i));
            End Loop;
            Exit When cur_restricted_area_list%notfound;
        End Loop;
        Close cur_restricted_area_list;
        Return;

    End fn_restricted_area_list;

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
        v_start_date         Date := iot_swp_common.get_monday_date(trunc(p_date));
        v_end_date           Date := iot_swp_common.get_friday_date(trunc(p_date));
    Begin

        Open c For
            /*
                     With
                        atnd_days As (
                           Select w.empno,
                                  Trim(w.attendance_date) As attendance_date,
                                  Trim(w.deskid) As deskid,
                                  1 As planned
                             From swp_smart_attendance_plan w
                            Where w.empno = p_empno
                              And attendance_date Between v_start_date And v_end_date
                        )

                     Select e.empno As empno,
                            dd.d_day,
                            dd.d_date,
                            nvl(atnd_days.planned, 0) As planned,
                            atnd_days.deskid As deskid
                       From ss_emplmast e,
                            ss_days_details dd,
                            atnd_days
                      Where e.empno = Trim(p_empno)
                        And dd.d_date = atnd_days.attendance_date(+)
                        And d_date Between v_start_date And v_end_date
                      Order By dd.d_date;
            */

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
                        w.empno      = p_empno
                        And w.deskid = dm.deskid(+)
                        And attendance_date Between v_start_date And v_end_date
                ),
                holiday As (
                    Select
                        holiday, 1 As is_holiday
                    From
                        ss_holidays
                    Where
                        holiday Between v_start_date And v_end_date
                )
            Select
                e.empno                   As empno,
                dd.d_day,
                dd.d_date,
                nvl(atnd_days.planned, 0) As planned,
                atnd_days.deskid          As deskid,
                nvl(hh.is_holiday, 0)     As is_holiday,
                atnd_days.office          As office,
                atnd_days.floor           As floor,
                atnd_days.wing            As wing,
                atnd_days.bay             As bay
            From
                ss_emplmast     e,
                ss_days_details dd,
                atnd_days,
                holiday         hh
            Where
                e.empno       = Trim(p_empno)

                And dd.d_date = atnd_days.attendance_date(+)
                And dd.d_date = hh.holiday(+)
                And d_date Between v_start_date And v_end_date
            Order By
                dd.d_date;
        Return c;

    End;

    Function fn_week_attend_planning(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_date                   Date     Default sysdate,

        p_assign_code            Varchar2 Default Null,

        p_emptype_csv            Varchar2 Default Null,
        p_grade_csv              Varchar2 Default Null,
        p_generic_search         Varchar2 Default Null,
        p_desk_assignment_status Varchar2 Default Null,
        p_desk_pivot             Number   Default 0,

        p_row_number             Number,
        p_page_length            Number
    ) Return Sys_Refcursor As
        c                     Sys_Refcursor;
        v_hod_sec_empno       Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query               Varchar2(7000);
        v_start_date          Date := iot_swp_common.get_monday_date(p_date) - 1;
        v_end_date            Date := iot_swp_common.get_friday_date(p_date);
        v_hod_sec_assign_code Varchar2(4);
        Cursor cur_days Is
            Select
                to_char(d_date, 'yyyymmdd') yymmdd, to_char(d_date, 'DY') dday
            From
                ss_days_details
            Where
                d_date Between v_start_date And v_end_date;
        v_assign_csv          Varchar2(100);
    Begin
        --v_start_date := get_monday_date(p_date);
        --v_end_date   := get_friday_date(p_date);

        v_query               := c_qry_attendance_planning;
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
        v_hod_sec_empno       := get_empno_from_meta_id(p_meta_id);
        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;

        v_hod_sec_assign_code := iot_swp_common.get_default_dept4plan_hod_sec(
                                     p_hod_sec_empno => v_hod_sec_empno,
                                     p_assign_code   => p_assign_code
                                 );

        v_query               := replace(v_query, '!E_ASSIGN!', where_clause_e_assign_code);
        v_query               := replace(v_query, '!CE_ASSIGN!', where_clause_ce_assign_code);

        If p_grade_csv Is Not Null Then
            v_query := replace(v_query, '!GRADES_SUBQUERY!', sub_qry_grades_csv);
        Else
            v_query := replace(v_query, '!GRADES_SUBQUERY!', '');
        End If;

        If p_emptype_csv Is Not Null Then
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_csv);
        Else
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_default);
        End If;

        If Trim(p_generic_search) Is Not Null Then
            v_query := replace(v_query, '!GENERIC_SEARCH!', where_clause_generic_search);
        Else
            v_query := replace(v_query, '!GENERIC_SEARCH!', '');
        End If;

        If p_desk_assignment_status = 'Pending' Then
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', ' and a.empno is null ');
        Elsif p_desk_assignment_status = 'Assigned' Then
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', ' and a.empno is not null ');
        Else
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', '');
        End If;

        If nvl(p_desk_pivot, 0) = 1 Then
            v_query := replace(v_query, '!PIVOT_FOR!', sub_desk_pivot);
        Else
            v_query := replace(v_query, '!PIVOT_FOR!', sub_days_pivot);
        End If;

        /*
                Insert Into swp_mail_log (subject, mail_sent_to_cc_bcc, modified_on)
                Values (v_empno || '-' || p_row_number || '-' || p_page_length || '-' || to_char(v_start_date, 'yyyymmdd') || '-' ||
                    to_char(v_end_date, 'yyyymmdd'),
                    v_query, sysdate);
                Commit;
                */
        Open c For v_query Using
            p_person_id,
            p_meta_id,
            p_row_number,
            p_page_length,

            v_start_date,
            v_end_date,

            v_hod_sec_assign_code,
            v_assign_csv,
            p_emptype_csv,
            p_grade_csv,
            '%' || upper(trim(p_generic_search)) || '%',
            p_desk_assignment_status;

        Return c;

    End;

    Function fn_current_planning_xl(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_assign_code Varchar2 Default Null
    ) Return Sys_Refcursor As
        c Sys_Refcursor;

    Begin
        c := fn_week_attend_planning(
                 p_person_id              => p_person_id,
                 p_meta_id                => p_meta_id,
                 p_date                   => sysdate,

                 p_assign_code            => p_assign_code,

                 p_emptype_csv            => Null,
                 p_grade_csv              => Null,
                 p_generic_search         => Null,
                 p_desk_assignment_status => Null,
                 p_desk_pivot             => 1,

                 p_row_number             => 0,
                 p_page_length            => 100000
             );
        Return c;
    End;

    Function fn_future_planning_xl(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_assign_code Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                Sys_Refcursor;
        rec_config_weeks swp_config_weeks%rowtype;
    Begin
        Begin
            Select
                *
            Into
                rec_config_weeks
            From
                swp_config_weeks
            Where
                planning_flag = 2;
        Exception
            When Others Then
                Return Null;
        End;
        c := fn_week_attend_planning(
                 p_person_id              => p_person_id,
                 p_meta_id                => p_meta_id,
                 p_date                   => rec_config_weeks.start_date,

                 p_assign_code            => p_assign_code,

                 p_emptype_csv            => Null,
                 p_grade_csv              => Null,
                 p_generic_search         => Null,
                 p_desk_assignment_status => Null,
                 p_desk_pivot             => 1,

                 p_row_number             => 0,
                 p_page_length            => 100000
             );
        Return c;
    End;

    Function fn_week_attend_planning_all(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_date                   Date     Default sysdate,

        p_assign_csv             Varchar2 Default Null,

        p_emptype_csv            Varchar2 Default Null,
        p_grade_csv              Varchar2 Default Null,
        p_generic_search         Varchar2 Default Null,
        p_desk_assignment_status Varchar2 Default Null,
        p_desk_pivot             Number   Default 0,

        p_row_number             Number,
        p_page_length            Number
    ) Return Sys_Refcursor As
        c                     Sys_Refcursor;
        v_hod_sec_empno       Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query               Varchar2(7000);
        v_start_date          Date := iot_swp_common.get_monday_date(p_date) - 1;
        v_end_date            Date := iot_swp_common.get_friday_date(p_date);
        v_hod_sec_assign_code Varchar2(4);
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

        /*
        v_hod_sec_empno       := get_empno_from_meta_id(p_meta_id);
        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;

        v_hod_sec_assign_code := iot_swp_common.get_default_dept4plan_hod_sec(
                                     p_hod_sec_empno => v_hod_sec_empno,
                                     p_assign_code   => p_assign_code
                                 );
        */
        If p_assign_csv Is Not Null Then
            v_query := replace(v_query, '!E_ASSIGN!', sub_qry_e_assign_csv);
            v_query := replace(v_query, '!CE_ASSIGN!', sub_qry_ce_assign_csv);
        Else
            v_query := replace(v_query, '!E_ASSIGN!', '');
            v_query := replace(v_query, '!CE_ASSIGN!', '');
        End If;

        If p_grade_csv Is Not Null Then
            v_query := replace(v_query, '!GRADES_SUBQUERY!', sub_qry_grades_csv);
        Else
            v_query := replace(v_query, '!GRADES_SUBQUERY!', '');
        End If;

        If p_emptype_csv Is Not Null Then
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_csv);
        Else
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_default);
        End If;

        If Trim(p_generic_search) Is Not Null Then
            v_query := replace(v_query, '!GENERIC_SEARCH!', where_clause_generic_search);
        Else
            v_query := replace(v_query, '!GENERIC_SEARCH!', '');
        End If;

        If p_desk_assignment_status = 'Pending' Then
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', ' and a.empno is null ');
        Elsif p_desk_assignment_status = 'Assigned' Then
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', ' and a.empno is not null ');
        Else
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', '');
        End If;

        If nvl(p_desk_pivot, 0) = 1 Then
            v_query := replace(v_query, '!PIVOT_FOR!', sub_desk_pivot);
        Else
            v_query := replace(v_query, '!PIVOT_FOR!', sub_days_pivot);
        End If;

        /*
                Insert Into swp_mail_log (subject, mail_sent_to_cc_bcc, modified_on)
                Values (v_empno || '-' || p_row_number || '-' || p_page_length || '-' || to_char(v_start_date, 'yyyymmdd') || '-' ||
                    to_char(v_end_date, 'yyyymmdd'),
                    v_query, sysdate);
                Commit;
                */
        Open c For v_query Using
            p_person_id,
            p_meta_id,
            p_row_number,
            p_page_length,

            v_start_date,
            v_end_date,

            v_hod_sec_assign_code,
            p_assign_csv,
            p_emptype_csv,
            p_grade_csv,
            '%' || upper(trim(p_generic_search)) || '%',
            p_desk_assignment_status;

        Return c;

    End;

    Function fn_all_current_planning_xl(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date

    ) Return Sys_Refcursor As
        c Sys_Refcursor;

    Begin
        c := fn_week_attend_planning_all(
                 p_person_id              => p_person_id,
                 p_meta_id                => p_meta_id,
                 p_date                   => p_date,

                 p_emptype_csv            => Null,
                 p_grade_csv              => Null,
                 p_generic_search         => Null,
                 p_desk_assignment_status => Null,
                 p_desk_pivot             => 1,

                 p_row_number             => 0,
                 p_page_length            => 100000
             );
        Return c;
    End;

End iot_swp_smart_workspace_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_DMS_REP_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_DMS_REP_QRY" As
    e_employee_not_found Exception;
    Pragma exception_init(e_employee_not_found, -20001);

    Function fn_non_sws_emp_athome(
        p_hod_sec_empno Varchar2,
        p_is_admin      Boolean,
        p_row_number    Number,
        p_page_length   Number
    ) Return Sys_Refcursor As
        v_query Varchar2(6500);
        c       Sys_Refcursor;
    Begin
        v_query := c_query_non_sws_emp_home;
        If p_is_admin Then
            v_query := replace(v_query, '!ASSIGN_SUB_QUERY!', '');
        Else
            v_query := replace(v_query, '!ASSIGN_SUB_QUERY!', c_assign_sub_query);
        End If;
        Open c For v_query Using p_hod_sec_empno, p_row_number, p_page_length;
        Return c;
    End;

    Function fn_non_sws_emp_athome_4hodsec(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c               Sys_Refcursor;
        v_hod_sec_empno Varchar2(5);
    Begin

        v_hod_sec_empno := get_empno_from_meta_id(p_meta_id);
        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        c               := fn_non_sws_emp_athome(
                               p_hod_sec_empno => v_hod_sec_empno,
                               p_is_admin      => false,
                               p_row_number    => p_row_number,
                               p_page_length   => p_page_length
                           );
        /*
                Open c For
                    Select
                        *
                    From
                        (
                            Select
                                a.empno                                   As empno,
                                a.name                                    As employee_name,
                                a.parent                                  As parent,
                                a.emptype                                 As emptype,
                                a.grade                                   As emp_grade,
                                a.is_swp_eligible                         As is_swp_eligible,
                                a.is_laptop_user                          As is_laptop_user,
                                a.email                                   As emp_email,
                                iot_swp_common.get_desk_from_dms(a.empno) As deskid,
                                a.present_count                           As present_count,
                                Row_Number() Over (Order By parent)       As row_number,
                                Count(*) Over ()                          As total_row
                            From
                                (

                                    Select
                                        *
                                    From
                                        (
                                            Select
                                                empno,
                                                name,
                                                parent,
                                                grade,
                                                emptype,
                                                is_swp_eligible,
                                                is_laptop_user,
                                                email,
                                                Sum(is_present) present_count
                                            From
                                                (
                                                    With
                                                        dates As (
                                                            Select
                                                                d_date
                                                            From
                                                                (
                                                                    Select
                                                                        dd.*
                                                                    From
                                                                        ss_days_details dd
                                                                    Where
                                                                        dd.d_date Between sysdate - 14 And sysdate
                                                                        And dd.d_date Not In (
                                                                            Select
                                                                                holiday
                                                                            From
                                                                                ss_holidays
                                                                            Where
                                                                                holiday Between sysdate - 14 And sysdate
                                                                        )
                                                                    Order By d_date Desc
                                                                )
                                                            Where
                                                                Rownum < 7

                                                        )
                                                    Select
                                                        a.*, iot_swp_common.fn_is_present_4_swp(empno, dates.d_date) is_present
                                                    From
                                                        (
                                                            Select
                                                                *
                                                            From
                                                                (

                                                                    Select
                                                                        e.empno,
                                                                        e.name,
                                                                        e.parent,
                                                                        e.grade,
                                                                        e.emptype,
                                                                        iot_swp_common.is_emp_eligible_for_swp(e.empno) is_swp_eligible,
                                                                        iot_swp_common.is_emp_laptop_user(e.empno)      is_laptop_user,
                                                                        e.email
                                                                    From
                                                                        ss_emplmast e
                                                                    Where
                                                                        e.status = 1
                                                                        And e.assign In (
                                                                            Select
                                                                                parent
                                                                            From
                                                                                ss_user_dept_rights
                                                                            Where
                                                                                empno = v_hod_sec_empno
                                                                            Union

                                                                            Select
                                                                                costcode
                                                                            From
                                                                                ss_costmast
                                                                            Where
                                                                                hod = v_hod_sec_empno
                                                                        )

                                                                )
                                                            Where
                                                                (
                                                                    is_swp_eligible != 'OK'
                                                                    Or is_laptop_user = 0
                                                                    Or emptype In ('S')
                                                                )
                                                                And emptype Not In ('O')
                                                        ) a, dates
                                                )
                                            Group By empno, name, parent, grade, emptype, is_swp_eligible, is_laptop_user, email
                                            Order By parent
                                        )
                                    Where
                                        present_count < 3

                                ) a
                        )
                    Where
                        row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
                        */
        Return c;
    End;

    Function fn_non_sws_emp_athome_4admin(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c             Sys_Refcursor;
        v_admin_empno Varchar2(5);
    Begin

        v_admin_empno := get_empno_from_meta_id(p_meta_id);
        If v_admin_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        c             := fn_non_sws_emp_athome(
                             p_hod_sec_empno => Null,
                             p_is_admin      => true,
                             p_row_number    => p_row_number,
                             p_page_length   => p_page_length
                         );

        Return c;
    End;

    Function fn_deskallocation_swp(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;

    Begin
        Open c For
            Select
                deskid,
                office,
                floor,
                wing,
                cabin,
                empno1,
                initcap(name1)                                              As name1,
                userid1,
                dept1,
                grade1,
                desg1,
                shift1,
                email1,
                empno2,
                initcap(name2)                                              As name2,
                userid2,
                dept2,
                grade2,
                desg2,
                shift2,
                email2,
                compname,
                computer,
                pcmodel                                                     As pc_model,
                monitor1,
                monmodel1                                                   As monitor1_model,
                monitor2,
                monmodel2                                                   As monitor2_model,
                telephone,
                telmodel                                                    As tel_model,
                printer,
                printmodel                                                  As printer_model,
                docstn                                                      As docking_station,
                docstnmodel                                                 As docking_station_model,
                dms.dmsv2.get_ram(computer)                                 As pc_ram,
                nvl(dms.dmsv2.get_gcard(computer), '-')                     As graphic_card,

                iot_swp_common.fn_get_emp_pws_planning(empno1)              As emp1_pws,
                iot_swp_common.get_emp_is_eligible_4swp(empno1)             As emp1_is_swp_eligible,

                selfservice.iot_swp_common.fn_get_emp_pws_planning(empno2)  As emp2_pws,
                selfservice.iot_swp_common.get_emp_is_eligible_4swp(empno2) As emp2_is_swp_eligible,

                selfservice.iot_swp_common.get_emp_projno_desc(empno1)      As emp1_project,
                selfservice.iot_swp_common.get_emp_projno_desc(empno2)      As emp2_project

            From
                desmas_allocation
            Order By
                deskid;
        Return c;
    End;

End iot_swp_dms_rep_qry;
/
