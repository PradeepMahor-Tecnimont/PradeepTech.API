Create Or Replace Package Body desk_book.pkg_db_summary_qry As

    Function fn_summary_list(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_generic_search       Varchar2 Default Null,
        p_area_id              Varchar2 Default Null,
        p_office               Varchar2 Default Null,
        p_office_location_code Varchar2 Default Null,

        p_row_number           Number,
        p_page_length          Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select *
              From (

                       Select Count(vu_emplmast.empno)                          As emp_count,
                              dm_offices.office_code                            As office_code,
                              dm_offices.office_location_code                   As base_office_location_code,
                              tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                  tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                      vu_emplmast.empno, sysdate
                                  )
                              )                                                 As base_office_location,

                              dm_desk_areas.area_desc                           As area_desc,
                              vu_costmast.costcode                              As costcode,
                              vu_costmast.name                                  As department,
                              Row_Number() Over (Order By vu_costmast.costcode) row_number,
                              Count(*) Over ()                                  total_row
                         From vu_emplmast
                        Inner Join vu_costmast
                           On vu_costmast.costcode = vu_emplmast.parent
                         Left Outer Join dms.dm_offices
                           On dms.dm_offices.office_location_code = tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                  vu_emplmast.empno, sysdate
                              )
                         Left Outer Join dms.dm_desk_area_office_map
                           On dms.dm_desk_area_office_map.office_code = dm_offices.office_code
                         Left Outer Join dms.dm_desk_areas
                           On dms.dm_desk_areas.area_key_id = dms.dm_desk_area_office_map.area_id
                        Where vu_emplmast.status = 1
                          And vu_costmast.active = 1
                          And vu_emplmast.parent In (
                                  Select costcode
                                    From vu_costmast
                                   Where hod = v_empno
                                  Union
                                  Select costcode
                                    From tcmpl_app_config.sec_module_user_roles_costcode
                                   Where empno = v_empno
                                     And module_id = 'M20'
                                     And role_id = 'R003'
                              )
                          And (upper(dm_desk_areas.area_desc) Like '%' || upper(Trim(p_generic_search)) || '%')
                          And nvl(dms.dm_desk_areas.area_key_id, ' ') = nvl(Trim(p_area_id), nvl(dms.dm_desk_areas.area_key_id,
                          ' '))
                          And nvl(dms.dm_offices.office_code, ' ') = nvl(Trim(p_office), nvl(dms.dm_offices.office_code, ' '))
                          And nvl(dms.dm_offices.office_location_code, ' ') = nvl(Trim(p_office_location_code), nvl(dms.dm_offices.
                          office_location_code, ' '))
                        Group By dms.dm_offices.office_code,
                              dm_offices.office_location_code,
                              tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                  tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                      vu_emplmast.empno, sysdate
                                  )
                              ),

                              dms.dm_desk_areas.area_desc,
                              vu_costmast.costcode,
                              vu_costmast.name
                   )
             Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_summary_list;


  Function fn_hod_summary_cross_office_list(
        p_person_id            Varchar2,
        p_meta_id              Varchar2
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
                  select   key_id,
                        area_desc,
                        empno,
                        emp_name,
                        office,
                        emp_office_location as Location_Emp_Office ,
                        emp_desk_book_office_location as Location_Desk ,
                        dept_code,
                        dept_name,
                        booking_date,
                        booked_desk as Desk_Id,
                        desk_book_in_office as Desk_Office,
                        shiftcode,
                        is_emp_present,
                        to_char( punch_exists)
                      From
                        (
                            Select
                                desk_book.key_id                                              As key_id,
                                dm_desk_areas.area_key_id || ' : ' || dm_desk_areas.area_desc As area_desc,
                                vu_emplmast.empno                                             As empno,
                                vu_emplmast.name                                              As emp_name,
                                dm_area_type_user_mapping.office_code                         As office,
                                tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                    tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                        vu_emplmast.empno,
                                        sysdate
                                    )
                                )                                                             As emp_office_location,
                                tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                    dm_offices.office_location_code
                                )                                                             As emp_desk_book_office_location,
                                vu_costmast.costcode                                          As dept_code,
                                vu_costmast.name                                              As dept_name,
                                desk_book.attendance_date                                     As booking_date,
                                desk_book.deskid                                              As booked_desk,
                                desk_book.office                                              As desk_book_in_office,
                                desk_book.shiftcode                                           As shiftcode,
                                ''                                                            As is_emp_present,
                                selfservice.get_punch_num(
                                    vu_emplmast.empno,
                                    trunc(sysdate),
                                    ok,
                                    Null
                                )                                                             As punch_exists
                              From
                                     vu_emplmast
                                 Inner Join vu_costmast
                                On vu_emplmast.parent = vu_costmast.costcode
                                 Inner Join desk_book.db_desk_bookings desk_book
                                On desk_book.empno = vu_emplmast.empno
                                   And desk_book.attendance_date >= trunc(sysdate)
                                 Inner Join dms.dm_deskmaster
                                On dm_deskmaster.deskid = desk_book.deskid
                                 Inner Join dms.dm_desk_areas
                                On dm_deskmaster.work_area = dm_desk_areas.area_key_id
                                  Left Outer Join dms.dm_area_type_user_mapping
                                On dm_area_type_user_mapping.empno = vu_emplmast.empno
                                 Inner Join dms.dm_offices
                                On Trim(dm_offices.office_code) = Trim(desk_book.office)
                             Where
                                    vu_emplmast.status = 1
                                   And desk_book.deskid = dm_deskmaster.deskid
                                   And desk_book.attendance_date Between trunc(sysdate) And selfservice.iot_swp_common.fn_get_next_work_date(sysdate
                                   + 1)
                                   And vu_emplmast.parent In (
                                    Select
                                        costcode
                                      From
                                        vu_costmast
                                     Where
                                        hod = v_empno
                                    Union
                                    Select
                                        costcode
                                      From
                                        tcmpl_app_config.sec_module_user_roles_costcode
                                     Where
                                            empno = v_empno
                                           And module_id = 'M20'
                                           And role_id   = 'R003'
                                )
                        )
                     Where
                          trim(emp_desk_book_office_location) != trim(emp_office_location)
                     Order By
                        booked_desk,
                        empno,
                        booking_date,
                        area_desc;
        Return c;
    End fn_hod_summary_cross_office_list;


  Function fn_summary_cross_office_list(
        p_person_id            Varchar2,
        p_meta_id              Varchar2
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
                    Select
                        key_id,
                        area_desc,
                        empno,
                        emp_name,
                        office,
                        emp_office_location as Location_Emp_Office,
                        emp_desk_book_office_location as Location_Desk,
                        dept_code,
                        dept_name,
                        booking_date,
                        booked_desk as Desk_Id,
                        desk_book_in_office as Desk_Office,
                        shiftcode,
                        is_emp_present,
                       to_char( punch_exists)
                      From
                        (
                            Select
                                desk_book.key_id                                              As key_id,
                                dm_desk_areas.area_key_id || ' : ' || dm_desk_areas.area_desc As area_desc,
                                vu_emplmast.empno                                             As empno,
                                vu_emplmast.name                                              As emp_name,
                                dm_area_type_user_mapping.office_code                         As office,
                                tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                    tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                        vu_emplmast.empno,
                                        sysdate
                                    )
                                )                                                             As emp_office_location,
                                tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                    dm_offices.office_location_code
                                )                                                             As emp_desk_book_office_location,
                                vu_costmast.costcode                                          As dept_code,
                                vu_costmast.name                                              As dept_name,
                                desk_book.attendance_date                                     As booking_date,
                                desk_book.deskid                                              As booked_desk,
                                desk_book.office                                              As desk_book_in_office,
                                desk_book.shiftcode                                           As shiftcode,
                                ''                                                            As is_emp_present,
                                selfservice.get_punch_num(
                                    vu_emplmast.empno,
                                    trunc(sysdate),
                                    ok,
                                    Null
                                )                                                             As punch_exists
                              From
                                     vu_emplmast
                                 Inner Join vu_costmast
                                On vu_emplmast.parent = vu_costmast.costcode
                                 Inner Join desk_book.db_desk_bookings desk_book
                                On desk_book.empno = vu_emplmast.empno
                                   And desk_book.attendance_date >= trunc(sysdate)
                                 Inner Join dms.dm_deskmaster
                                On dm_deskmaster.deskid = desk_book.deskid
                                 Inner Join dms.dm_desk_areas
                                On dm_deskmaster.work_area = dm_desk_areas.area_key_id
                                  Left Outer Join dms.dm_area_type_user_mapping
                                On dm_area_type_user_mapping.empno = vu_emplmast.empno
                                 Inner Join dms.dm_offices
                                On Trim(dm_offices.office_code) = Trim(desk_book.office)
                             Where
                                    vu_emplmast.status = 1
                                   And desk_book.deskid = dm_deskmaster.deskid
                                   And desk_book.attendance_date Between trunc(sysdate) And selfservice.iot_swp_common.fn_get_next_work_date(sysdate
                                   + 1) 
                        )
                     Where
                          trim(emp_desk_book_office_location) != trim(emp_office_location)
                     Order By
                        booked_desk,
                        empno,
                        booking_date,
                        area_desc;
        Return c;
    End fn_summary_cross_office_list;
End pkg_db_summary_qry;
/
  Grant Execute On desk_book.pkg_db_summary_qry To tcmpl_app_config;