--------------------------------------------------------
--  File created - Wednesday-April-27-2022   
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
                        iot_swp_common.fn_get_dept_group(e.assign)             As assign_dept_group,
                        !PIVOT_COL!
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
    sub_days_pivot Varchar2(100) := ' Count(*) ';
    pivot_desk varchar2(100) := ' a.deskid as deskid, ';
    pivot_plan varchar2(100) := ' case when a.empno is null then 0 else 1 end planned, ';
    
    
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
            v_query := replace(v_query, '!PIVOT_COL!', pivot_desk);
            v_query := replace(v_query, '!PIVOT_FOR!', sub_desk_pivot);
        Else
            v_query := replace(v_query, '!PIVOT_COL!', pivot_PLAN);
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
            v_query := replace(v_query, '!PIVOT_COL!', pivot_desk);
            v_query := replace(v_query, '!PIVOT_FOR!', sub_desk_pivot);
        Else
            v_query := replace(v_query, '!PIVOT_COL!', pivot_PLAN);
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
--IOT_SWP_SMART_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE" As
    c_planning_future  Constant Number(1) := 2;
    c_planning_current Constant Number(1) := 1;
    c_planning_is_open Constant Number(1) := 1;
    Procedure del_emp_sws_atend_plan(
        p_empno            Varchar2,
        p_date             Date,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
        rec_smart_attendance_plan swp_smart_attendance_plan%rowtype;
        v_plan_start_date         Date;
        v_plan_end_date           Date;
        v_planning_exists         Varchar2(2);
        v_planning_open           Varchar2(2);
        v_message_type            Varchar2(10);
        v_message_text            Varchar2(1000);

        v_general_area            Varchar2(4) := 'A002';
        v_count                   Number;
        rec_config_week           swp_config_weeks%rowtype;
    Begin
        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            Return;
        End If;

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future
            And sws_open  = c_planning_is_open;

        Select
            Count(*)
        Into
            v_count
        From
            swp_smart_attendance_plan
        Where
            empno         = p_empno
            And week_key_id = rec_config_week.key_id;
        If v_count < 2 Then
            p_message_type := 'KO';
            p_message_text := 'Only one attendance day availabe. Hence cannot delete.';
            return;
        End If;
        Begin
            Select
                *
            Into
                rec_smart_attendance_plan
            From
                swp_smart_attendance_plan
            Where
                empno               = p_empno
                And attendance_date = p_date;
        Exception
            When no_data_found Then
                Return;
        End;
        --Delete from Planning table

        Delete
            From swp_smart_attendance_plan
        Where
            key_id = rec_smart_attendance_plan.key_id;

        --Check if the desk is General desk.

        If Not iot_swp_common.is_desk_in_general_area(rec_smart_attendance_plan.deskid) Then
            Return;
        End If;
        --

        iot_swp_dms.sp_unlock_desk(
            p_person_id   => Null,
            p_meta_id     => Null,

            p_deskid      => rec_smart_attendance_plan.deskid,
            p_week_key_id => rec_config_week.key_id
        );

    End;

    Procedure sp_add_weekly_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        strsql                    Varchar2(600);
        v_count                   Number;
        v_status                  Varchar2(5);
        v_mod_by_empno            Varchar2(5);
        v_pk                      Varchar2(10);
        v_fk                      Varchar2(10);
        v_empno                   Varchar2(5);
        v_attendance_date         Date;
        v_desk                    Varchar2(20);
        rec_config_week           swp_config_weeks%rowtype;
        rec_smart_attendance_plan swp_smart_attendance_plan%rowtype;
    Begin

        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            p_message_type := 'KO';
            p_message_text := 'Planning not allowed for employee assign code.';
            Return;
        End If;

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future
            And sws_open  = c_planning_is_open;
        Select
            Count(*)
        Into
            v_count
        From
            swp_primary_workspace
        Where
            Trim(empno)                 = Trim(p_empno)
            And Trim(primary_workspace) = 2;

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;

        For i In 1..p_weekly_attendance.count
        Loop

            With
                csv As (
                    Select
                        p_weekly_attendance(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))          empno,
                to_date(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) attendance_date,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))          desk,
                Trim(regexp_substr(str, '[^~!~]+', 1, 4))          status
            Into
                v_empno, v_attendance_date, v_desk, v_status
            From
                csv;

            If v_status = 0 Then
                del_emp_sws_atend_plan(
                    p_empno        => v_empno,
                    p_date         => trunc(v_attendance_date),
                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
                Return;
            End If;
            Begin
                Select
                    *
                Into
                    rec_smart_attendance_plan
                From
                    swp_smart_attendance_plan
                Where
                    empno               = v_empno
                    And attendance_date = v_attendance_date;
            Exception
                When Others Then
                    Null;
            End ;
            If v_status = '1' Then
                If rec_smart_attendance_plan.empno Is Null Then
                    v_pk := dbms_random.string('X', 10);

                    Select
                        key_id
                    Into
                        v_fk
                    From
                        swp_primary_workspace
                    Where
                        Trim(empno)                 = Trim(p_empno)
                        And Trim(primary_workspace) = '2';

                    Insert Into swp_smart_attendance_plan
                    (
                        key_id,
                        ws_key_id,
                        empno,
                        attendance_date,
                        deskid,
                        modified_on,
                        modified_by,
                        week_key_id
                    )
                    Values
                    (
                        v_pk,
                        v_fk,
                        v_empno,
                        v_attendance_date,
                        v_desk,
                        sysdate,
                        v_mod_by_empno,
                        rec_config_week.key_id
                    );
                Else
                    Update
                        swp_smart_attendance_plan
                    Set
                        deskid = v_desk, modified_on = sysdate, modified_by = v_mod_by_empno
                    Where
                        key_id = rec_smart_attendance_plan.key_id;
                End If;
                If iot_swp_common.is_desk_in_general_area(v_desk) Then
                    /*
                    iot_swp_dms.sp_clear_desk(
                        p_person_id => Null,
                        p_meta_id   => p_meta_id,

                        p_deskid    => v_desk

                    );
                    */
                    iot_swp_dms.sp_lock_desk(
                        p_person_id => Null,
                        p_meta_id   => Null,

                        p_deskid    => v_desk
                    );
                End If;
            End If;

        End Loop;
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || v_desk || ' is not available. It has be assigned to other Employee.';

        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_weekly_atnd;

    Procedure sp_smart_ws_weekly_summary(
        p_person_id                     Varchar2,
        p_meta_id                       Varchar2,

        p_assign_code                   Varchar2,
        p_date                          Date,

        p_emp_count_smart_workspace Out Number,
        p_emp_count_mon             Out Number,
        p_emp_count_tue             Out Number,
        p_emp_count_wed             Out Number,
        p_emp_count_thu             Out Number,
        p_emp_count_fri             Out Number,
        p_costcode_desc             Out Varchar2,
        p_message_type              Out Varchar2,
        p_message_text              Out Varchar2
    ) As
        v_start_date Date;
        v_end_date   Date;
        Cursor cur_summary(cp_start_date Date,
                           cp_end_date   Date) Is
            Select
                attendance_day, Count(empno) emp_count
            From
                (
                    Select
                        e.empno, to_char(attendance_date, 'DY') attendance_day
                    From
                        ss_emplmast               e,
                        swp_smart_attendance_plan wa
                    Where
                        e.assign    = p_assign_code
                        And attendance_date Between cp_start_date And cp_end_date
                        And e.empno = wa.empno(+)
                        And status  = 1
                        And emptype In (
                            Select
                                emptype
                            From
                                swp_include_emptype
                        )
                )
            Group By
                attendance_day;

    Begin
        v_start_date   := iot_swp_common.get_monday_date(p_date);
        v_end_date     := iot_swp_common.get_friday_date(p_date);
        Select
            costcode || ' - ' || name
        Into
            p_costcode_desc
        From
            ss_costmast
        Where
            costcode = p_assign_code;

        For c1 In cur_summary(v_start_date, v_end_date)
        Loop
            If c1.attendance_day = 'MON' Then
                p_emp_count_mon := c1.emp_count;
            Elsif c1.attendance_day = 'TUE' Then
                p_emp_count_tue := c1.emp_count;
            Elsif c1.attendance_day = 'WED' Then
                p_emp_count_wed := c1.emp_count;
            Elsif c1.attendance_day = 'THU' Then
                p_emp_count_thu := c1.emp_count;
            Elsif c1.attendance_day = 'FRI' Then
                p_emp_count_fri := c1.emp_count;
            End If;
        End Loop;

        --Total Count
        Select
            --e.empno, emptype, status, aw.primary_workspace
            Count(*)
        Into
            p_emp_count_smart_workspace
        From
            ss_emplmast           e,
            swp_primary_workspace aw

        Where
            e.assign                 = p_assign_code
            And e.empno              = aw.empno
            And status               = 1
            And emptype In (
                Select
                    emptype
                From
                    swp_include_emptype
            )
            And aw.primary_workspace = 2
            And
            trunc(aw.start_date)     = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = aw.empno
                        And b.start_date <= v_end_date
                );

        /*

                Select
                    Count(*)
                Into
                    p_emp_count_smart_workspace
                From
                    swp_primary_workspace
                Where
                    primary_workspace = 2
                    And empno In (
                        Select
                            empno
                        From
                            ss_emplmast
                        Where
                            status     = 1
                            And assign = p_assign_code
                    );
        */
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_sys_assign_sws_desk(
        p_empno            Varchar2,
        p_attendance_date  Date,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count         Number;
        v_pk            Varchar2(10);
        v_fk            Varchar2(10);
        rec_config_week swp_config_weeks%rowtype;
    Begin

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future;

        Select
            Count(*)
        Into
            v_count
        From
            swp_primary_workspace
        Where
            Trim(empno)                 = Trim(p_empno)
            And Trim(primary_workspace) = 2;

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;

        v_pk           := dbms_random.string('X', 10);

        Select
            key_id
        Into
            v_fk
        From
            swp_primary_workspace
        Where
            Trim(empno)                 = Trim(p_empno)
            And Trim(primary_workspace) = '2';

        Insert Into swp_smart_attendance_plan
        (
            key_id,
            ws_key_id,
            empno,
            attendance_date,
            deskid,
            modified_on,
            modified_by,
            week_key_id
        )
        Values
        (
            v_pk,
            v_fk,
            p_empno,
            p_attendance_date,
            p_deskid,
            sysdate,
            'Sys',
            rec_config_week.key_id
        );
        If iot_swp_common.is_desk_in_general_area(p_deskid) Then

            iot_swp_dms.sp_lock_desk(
                p_person_id => Null,
                p_meta_id   => Null,

                p_deskid    => p_deskid
            );
        End If;
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_sys_assign_sws_desk;

End iot_swp_smart_workspace;
/
