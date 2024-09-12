--------------------------------------------------------
--  DDL for Package Body PKG_DESKBOOKING_QRY
--------------------------------------------------------

Create Or Replace Editionable Package Body desk_book.pkg_deskbooking_qry As

    Function fn_emp_desk_book_list (
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor Is
        c                Sys_Refcursor;
        v_count          Number;
        v_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
        v_next_work_date Date;
    Begin
        v_empno          := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        v_next_work_date := selfservice.iot_swp_common.fn_get_next_work_date(sysdate
                                                                             + 1);
        Open c For With today_punch As (
                                  Select
                                      selfservice.get_punch_num(
                                          v_empno,
                                          trunc(sysdate),
                                          ok,
                                          Null
                                      ) punch_exists
                                    From
                                      dual
                              )
                              Select
                                  *
                                From
                                  (
                                      Select
                                          a.key_id,
                                          a.empno,
                                          get_emp_name(
                                              a.empno
                                          )        emp_name,
                                          nvl(
                                              a.deskid,
                                              'N.A.'
                                          )        As deskid,
                              --a.attendance_date,
                              --to_char(b.d_date, 'dd-Mon-yyyy')                attendance_date,
                              --to_char(b.d_date, 'Dy')                         day_of_week,
                                          b.d_date attendance_date,
                                          a.start_time,
                                          a.end_time,
                                          a.modified_on,
                                          a.modified_by || ' - ' || get_emp_name(
                                              a.empno
                                          )        modified_by_emp_name,
                                          a.shiftcode,
                                          a.office,
                                          (
                                              Case
                                                  When trunc(
                                                      a.attendance_date
                                                  ) Is Null Then
                                                      'QB'
                                                  When b.d_date = trunc(sysdate)
                                                     And today.punch_exists > 0 Then
                                                      'CH'
                                                  Else
                                                      'DL'
                                              End
                                          )        As action_type,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  b.d_date
                                          )        As row_number,
                                          Count(*)
                                          Over()   As total_row
                                        From
                                               selfservice.ss_days_details b
                                           Cross Join today_punch      today
                                            Left Outer Join db_desk_bookings a
                                          On b.d_date = a.attendance_date
                                             And a.empno = v_empno
                                       Where
                                          b.d_date Between trunc(sysdate) And v_next_work_date
                                       Order By
                                          b.d_date
                                  )
                    Where
                       row_number Between ( nvl(
                           p_row_number,
                           0
                       ) + 1 ) And ( nvl(
                           p_row_number,
                           0
                       ) + p_page_length );
        Return c;
    End fn_emp_desk_book_list;

    Function fn_emp_desk_book_log_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor Is
        c       Sys_Refcursor;
        v_count Number;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          a.key_id,
                                          a.empno,
                                          get_emp_name(
                                              a.empno
                                          )      emp_name,
                                          a.deskid,
                              --a.attendance_date,
                                          to_char(
                                              a.attendance_date,
                                              'dd-Mon-yyyy'
                                          )      attendance_date,
                                          to_char(
                                              a.attendance_date,
                                              'Dy'
                                          )      day_of_week,
                                          a.start_time,
                                          a.end_time,
                                          a.modified_on,
                                          a.modified_by || ' - ' || get_emp_name(
                                              a.empno
                                          )      modified_by_emp_name,
                                          a.shiftcode,
                                          a.office,
                                          (
                                              Case
                                                  When trunc(
                                                      a.attendance_date
                                                  ) = trunc(sysdate) Then
                                                      'KO'
                                                  Else
                                                      'OK'
                                              End
                                          )      As is_delete,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.attendance_date
                                          )      As row_number,
                                          Count(*)
                                          Over() As total_row
                                        From
                                          db_desk_bookings a
                                       Where
                                              a.empno = v_empno
                                             And ( upper(
                                              a.empno
                                          ) Like '%' || upper(
                                              Trim(p_generic_search)
                                          ) || '%' )
                                       Order By
                                          trunc(
                                              a.attendance_date
                                          )
                                  )
                    Where
                       row_number Between ( nvl(
                           p_row_number,
                           0
                       ) + 1 ) And ( nvl(
                           p_row_number,
                           0
                       ) + p_page_length );
        Return c;
    End fn_emp_desk_book_log_list;

    Function fn_desk_book_4_hod_list (
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_generic_search  Varchar2 Default Null,
        p_area_id         Varchar2 Default Null,
        p_cost_code       Varchar2 Default Null,
        p_is_present      Number Default Null,
        p_is_desk_booked  Number Default Null,
        p_attendance_date Date Default Null,
        p_row_number      Number,
        p_page_length     Number
    ) Return Sys_Refcursor Is
        c                 Sys_Refcursor;
        v_count           Number;
        v_empno           Varchar2(5);
        e_employee_not_found Exception;
        v_attendance_date Date;
        Pragma exception_init ( e_employee_not_found, -20001 );
        v_next_work_date  Date;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        --v_next_work_date := selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1);

        If p_attendance_date Is Null Then
            --v_attendance_date := trunc(sysdate);
            null;
        Else
            v_attendance_date := trunc(p_attendance_date);
        End If;

        Open c For 
        Select
                    *
                  From
                    (
                        Select
                            key_id,
                            area_desc,
                            area_id,
                            empno,
                            emp_name,
                            dept_code,
                            dept_name,
                            booking_date,
                            booked_desk,
                            desk_office,
                            shiftcode,
                            is_desk_book_val,
                            is_desk_book_text    As is_desk_book,
                            is_present_val,
                            is_present_text      As is_present,
                            punch_in_office,
                            is_cross_attend_val,
                            is_cross_attend_text As is_cross_attend,
                            Row_Number()
                            Over(
                                 Order By
                                    booked_desk,
                                    empno,
                                    booking_date
                            )                    As row_number,
                            Count(*)
                            Over()               As total_row
                          From
                            (                                            
                                  With
                                    params As (
                                        Select
                                            trunc(v_attendance_date) p_date
                                        From
                                            dual
                                    ),
                                    desk_booking As (
                                        Select
                                            key_id,
                                            empno,
                                            attendance_date As booking_date,
                                            deskid          As booked_desk,
                                            office          As desk_office,
                                            shiftcode
                                        From
                                            db_desk_bookings db,
                                            params           p
                                        Where
                                            attendance_date = p.p_date
                                    ),
                                    emp_area As(
                                        Select
                                            a.empno,
                                            c.area_desc   As area_desc,
                                            c.area_key_id As area_id
                                
                                        From
                                            vu_emplmast                        a
                                            Join dms.dm_area_type_user_mapping b
                                            On a.empno = b.empno
                                            Join dms.dm_desk_areas             c
                                            On c.area_key_id = b.area_id
                                        Where
                                            a.status = 1
                                    ),
                                    emp_location As(
                                        Select
                                            empno,
                                            tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                                tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                    a.empno, trunc(sysdate)
                                                )
                                            ) As office_location_desc,
                                            tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                a.empno, trunc(sysdate)
                                            ) As office_location_code
                                        From
                                            vu_emplmast a
                                        Where
                                            a.status = 1
                                    )
                                Select
                                    booking_data.*,
                                    Case
                                        When booked_desk Is Null Then
                                            0
                                        When booked_desk Is Not Null Then
                                            1
                                        Else
                                            -1
                                    End As is_desk_book_val,
                                    Case
                                        When booked_desk Is Null Then
                                            'No'
                                        When booked_desk Is Not Null Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_desk_book_text,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            0
                                        Else
                                            1
                                    End As is_present_val,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            Null
                                        Else
                                            'Yes'
                                    End As is_present_text,
                                    replace(
                                        selfservice.self_attendance.get_emp_office(
                                            empno, (p_date)
                                        ),
                                        'ERR',
                                        ''
                                    )   As punch_in_office,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            1
                                        Else
                                            0
                                    End As is_cross_attend_val,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_cross_attend_text
                                From
                                    (
                                        Select
                                            e.empno,
                                            e.name                   emp_name,
                                            e.parent as dept_code,
                                            c.name                   dept_name,
                                            ea.area_desc,
                                            ea.area_id,
                                            el.office_location_desc,
                                            el.office_location_code,
                                            mel.office_location_code map_office_loc_code,
                                            db.key_id,
                                            db.booking_date,
                                            db.booked_desk,
                                            db.desk_office,
                                            db.shiftcode,
                                            p.p_date
                                        From
                                            vu_emplmast                             e
                                            Inner Join vu_costmast                  c
                                            On e.parent = c.costcode
                                            Left Join emp_area                      ea
                                            On e.empno = ea.empno
                                            Left Join emp_location                  el
                                            On e.empno = el.empno
                                            Left Join desk_book.db_map_emp_location mel
                                            On e.empno = mel.empno
                                            Left Join desk_booking                  db
                                            On e.empno = db.empno
                                            Cross Join params                       p
                                        Where
                                            e.status = 1
                                    ) booking_data
                                Where
                                    (office_location_code = '02' 
                                        Or office_location_code = '01'
                                        Or map_office_loc_code = '02')
                            )
                         Where
                            dept_code In (
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
                               And nvl(area_id, ' ' ) = nvl( p_area_id,nvl( area_id, ' ' ))
                               And dept_code = nvl( Trim(p_cost_code), dept_code )                                         
                               And is_desk_book_val = nvl( p_is_desk_booked, is_desk_book_val )
                               And is_present_val = nvl( p_is_present, is_present_val )
                               And ( upper(empno) Like '%' || upper( Trim(p_generic_search) ) || '%'
                                    Or upper(emp_name) Like '%' || upper( Trim(p_generic_search) ) 
                                )
                    )
                   Where
                      row_number Between ( nvl(
                          p_row_number,
                          0
                      ) + 1 ) And ( nvl(
                          p_row_number,
                          0
                      ) + p_page_length );
        Return c;
    End fn_desk_book_4_hod_list;

    Function fn_desk_book_4_dms_list (
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_generic_search  Varchar2 Default Null,
        p_area_id         Varchar2 Default Null,
        p_cost_code       Varchar2 Default Null,
        p_is_present      Number Default Null,
        p_is_desk_booked  Number Default Null,
        p_attendance_date Date Default Null,
        p_row_number      Number,
        p_page_length     Number
    ) Return Sys_Refcursor Is
        c                 Sys_Refcursor;
        v_count           Number;
        v_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
        v_next_work_date  Date;
        v_attendance_date Date;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
    
        --v_next_work_date := selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1);
        If p_attendance_date Is Null Then
            v_attendance_date := trunc(sysdate);
        Else
            v_attendance_date := trunc(p_attendance_date);
        End If;
        Open c For 
        Select
                                *
                              From
                                (
                                     Select
                            key_id,
                            area_desc,
                            area_id,
                            empno,
                            emp_name,
                            dept_code,
                            dept_name,
                            booking_date,
                            booked_desk,
                            desk_office,
                            shiftcode,
                            is_desk_book_val,
                            is_desk_book_text    As is_desk_book,
                            is_present_val,
                            is_present_text      As is_present,
                            punch_in_office,
                            is_cross_attend_val,
                            is_cross_attend_text As is_cross_attend,
                            Row_Number()
                            Over(
                                 Order By
                                    booked_desk,
                                    empno,
                                    booking_date
                            )                    As row_number,
                            Count(*)
                            Over()               As total_row
                          From
                            (                                            
                                    With
                                    params As (
                                        Select
                                            trunc(v_attendance_date) p_date
                                        From
                                            dual
                                    ),
                                    desk_booking As (
                                        Select
                                            key_id,
                                            empno,
                                            attendance_date As booking_date,
                                            deskid          As booked_desk,
                                            office          As desk_office,
                                            shiftcode
                                        From
                                            db_desk_bookings db,
                                            params           p
                                        Where
                                            attendance_date = p.p_date
                                    ),
                                    emp_area As(
                                        Select
                                            a.empno,
                                            c.area_desc   As area_desc,
                                            c.area_key_id As area_id
                                
                                        From
                                            vu_emplmast                        a
                                            Join dms.dm_area_type_user_mapping b
                                            On a.empno = b.empno
                                            Join dms.dm_desk_areas             c
                                            On c.area_key_id = b.area_id
                                        Where
                                            a.status = 1
                                    ),
                                    emp_location As(
                                        Select
                                            empno,
                                            tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                                tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                    a.empno, trunc(sysdate)
                                                )
                                            ) As office_location_desc,
                                            tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                a.empno, trunc(sysdate)
                                            ) As office_location_code
                                        From
                                            vu_emplmast a
                                        Where
                                            a.status = 1
                                    )
                                Select
                                    booking_data.*,
                                    Case
                                        When booked_desk Is Null Then
                                            0
                                        When booked_desk Is Not Null Then
                                            1
                                        Else
                                            -1
                                    End As is_desk_book_val,
                                    Case
                                        When booked_desk Is Null Then
                                            'No'
                                        When booked_desk Is Not Null Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_desk_book_text,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            0
                                        Else
                                            1
                                    End As is_present_val,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            Null
                                        Else
                                            'Yes'
                                    End As is_present_text,
                                    replace(
                                        selfservice.self_attendance.get_emp_office(
                                            empno, (p_date)
                                        ),
                                        'ERR',
                                        ''
                                    )   As punch_in_office,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            1
                                        Else
                                            0
                                    End As is_cross_attend_val,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_cross_attend_text
                                From
                                    (
                                        Select
                                            e.empno,
                                            e.name                   emp_name,
                                            e.parent as dept_code,
                                            c.name                   dept_name,
                                            ea.area_desc,
                                            ea.area_id,
                                            el.office_location_desc,
                                            el.office_location_code,
                                            mel.office_location_code map_office_loc_code,
                                            db.key_id,
                                            db.booking_date,
                                            db.booked_desk,
                                            db.desk_office,
                                            db.shiftcode,
                                            p.p_date
                                        From
                                            vu_emplmast                             e
                                            Inner Join vu_costmast                  c
                                            On e.parent = c.costcode
                                            Left Join emp_area                      ea
                                            On e.empno = ea.empno
                                            Left Join emp_location                  el
                                            On e.empno = el.empno
                                            Left Join desk_book.db_map_emp_location mel
                                            On e.empno = mel.empno
                                            Left Join desk_booking                  db
                                            On e.empno = db.empno
                                            Cross Join params                       p
                                        Where
                                            e.status = 1
                                    ) booking_data
                                Where
                                    (office_location_code = '02' 
                                        Or office_location_code = '01'
                                        Or map_office_loc_code = '02')
                            )
                         Where
                            nvl(area_id, ' ' ) = nvl( p_area_id,nvl( area_id, ' ' ))
                               And dept_code = nvl( Trim(p_cost_code), dept_code )                                         
                               And is_desk_book_val = nvl( p_is_desk_booked, is_desk_book_val )
                               And is_present_val = nvl( p_is_present, is_present_val )
                               And ( upper(empno) Like '%' || upper( Trim(p_generic_search) ) || '%'
                                    Or upper(emp_name) Like '%' || upper( Trim(p_generic_search) ) 
                                )
                                )
                   Where
                      row_number Between ( nvl(
                          p_row_number,
                          0
                      ) + 1 ) And ( nvl(
                          p_row_number,
                          0
                      ) + p_page_length );
        Return c;
    End fn_desk_book_4_dms_list;

    Function fn_desk_book_4_hod_history_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_area_id        Varchar2 Default Null,
        p_cost_code      Varchar2 Default Null,
        p_start_date     Date Default Null,
        p_end_date       Date Default Null,
        p_is_present     Number Default Null,
        p_is_desk_booked Number Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor Is
        c                Sys_Refcursor;
        v_count          Number;
        v_empno          Varchar2(5);
        V_ATTENDANCE_DATE date;
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
        v_next_work_date Date;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        --v_next_work_date := selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1);
        If p_start_date Is Null Then
            v_attendance_date := trunc(sysdate);
        Else
            v_attendance_date := trunc(p_start_date);
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                         Select
                            key_id,
                            area_desc,
                            area_id,
                            empno,
                            emp_name,
                            dept_code,
                            dept_name,
                            booking_date,
                            booked_desk,
                            desk_office,
                            shiftcode,
                            is_desk_book_val,
                            is_desk_book_text    As is_desk_book,
                            is_present_val,
                            is_present_text      As is_present,
                            punch_in_office,
                            is_cross_attend_val,
                            is_cross_attend_text As is_cross_attend,
                            Row_Number()
                            Over(
                                 Order By
                                    booked_desk,
                                    empno,
                                    booking_date
                            )                    As row_number,
                            Count(*)
                            Over()               As total_row
                          From
                            (                                            
                                   With
                                    params As (
                                        Select
                                            trunc(v_attendance_date) p_date
                                        From
                                            dual
                                    ),
                                    desk_booking As (
                                        Select
                                            key_id,
                                            empno,
                                            attendance_date As booking_date,
                                            deskid          As booked_desk,
                                            office          As desk_office,
                                            shiftcode
                                        From
                                            db_desk_bookings db,
                                            params           p
                                        Where
                                            attendance_date = p.p_date
                                    ),
                                    emp_area As(
                                        Select
                                            a.empno,
                                            c.area_desc   As area_desc,
                                            c.area_key_id As area_id
                                
                                        From
                                            vu_emplmast                        a
                                            Join dms.dm_area_type_user_mapping b
                                            On a.empno = b.empno
                                            Join dms.dm_desk_areas             c
                                            On c.area_key_id = b.area_id
                                        Where
                                            a.status = 1
                                    ),
                                    emp_location As(
                                        Select
                                            empno,
                                            tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                                tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                    a.empno, trunc(sysdate)
                                                )
                                            ) As office_location_desc,
                                            tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                a.empno, trunc(sysdate)
                                            ) As office_location_code
                                        From
                                            vu_emplmast a
                                        Where
                                            a.status = 1
                                    )
                                Select
                                    booking_data.*,
                                    Case
                                        When booked_desk Is Null Then
                                            0
                                        When booked_desk Is Not Null Then
                                            1
                                        Else
                                            -1
                                    End As is_desk_book_val,
                                    Case
                                        When booked_desk Is Null Then
                                            'No'
                                        When booked_desk Is Not Null Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_desk_book_text,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            0
                                        Else
                                            1
                                    End As is_present_val,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            Null
                                        Else
                                            'Yes'
                                    End As is_present_text,
                                    replace(
                                        selfservice.self_attendance.get_emp_office(
                                            empno, (p_date)
                                        ),
                                        'ERR',
                                        ''
                                    )   As punch_in_office,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            1
                                        Else
                                            0
                                    End As is_cross_attend_val,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_cross_attend_text
                                From
                                    (
                                        Select
                                            e.empno,
                                            e.name                   emp_name,
                                            e.parent as dept_code,
                                            c.name                   dept_name,
                                            ea.area_desc,
                                            ea.area_id,
                                            el.office_location_desc,
                                            el.office_location_code,
                                            mel.office_location_code map_office_loc_code,
                                            db.key_id,
                                            db.booking_date,
                                            db.booked_desk,
                                            db.desk_office,
                                            db.shiftcode,
                                            p.p_date
                                        From
                                            vu_emplmast                             e
                                            Inner Join vu_costmast                  c
                                            On e.parent = c.costcode
                                            Left Join emp_area                      ea
                                            On e.empno = ea.empno
                                            Left Join emp_location                  el
                                            On e.empno = el.empno
                                            Left Join desk_book.db_map_emp_location mel
                                            On e.empno = mel.empno
                                            Left Join desk_booking                  db
                                            On e.empno = db.empno
                                            Cross Join params                       p
                                        Where
                                            e.status = 1
                                    ) booking_data
                                Where
                                    (office_location_code = '02' 
                                        Or office_location_code = '01'
                                        Or map_office_loc_code = '02')
                            )
                         Where
                            dept_code In (
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
                               And nvl(area_id, ' ' ) = nvl( p_area_id,nvl( area_id, ' ' ))
                               And dept_code = nvl( Trim(p_cost_code), dept_code )                                         
                               And is_desk_book_val = nvl( p_is_desk_booked, is_desk_book_val )
                               And is_present_val = nvl( p_is_present, is_present_val )
                               And ( upper(empno) Like '%' || upper( Trim(p_generic_search) ) || '%'
                                    Or upper(emp_name) Like '%' || upper( Trim(p_generic_search) ) 
                                )
                                  )
                    Where
                       row_number Between ( nvl(
                           p_row_number,
                           0
                       ) + 1 ) And ( nvl(
                           p_row_number,
                           0
                       ) + p_page_length );
        Return c;
    End fn_desk_book_4_hod_history_list;

    Function fn_desk_book_4_dms_history_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_area_id        Varchar2 Default Null,
        p_cost_code      Varchar2 Default Null,
        p_start_date     Date Default Null,
        p_end_date       Date Default Null,
        p_is_present     Number Default Null,
        p_is_desk_booked Number Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor Is
        c                Sys_Refcursor;
        v_count          Number;
        v_empno          Varchar2(5);
        e_employee_not_found Exception;
        V_ATTENDANCE_DATE date;
        Pragma exception_init ( e_employee_not_found, -20001 );
        v_next_work_date Date;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
    
        --v_next_work_date := selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1);
  If p_start_date Is Null Then
            v_attendance_date := trunc(sysdate);
        Else
            v_attendance_date := trunc(p_start_date);
        End If;
        
        Open c For Select
                                  *
                                From
                                  (
                                       Select
                            key_id,
                            area_desc,
                            area_id,
                            empno,
                            emp_name,
                            dept_code,
                            dept_name,
                            booking_date,
                            booked_desk,
                            desk_office,
                            shiftcode,
                            is_desk_book_val,
                            is_desk_book_text    As is_desk_book,
                            is_present_val,
                            is_present_text      As is_present,
                            punch_in_office,
                            is_cross_attend_val,
                            is_cross_attend_text As is_cross_attend,
                            Row_Number()
                            Over(
                                 Order By
                                    booked_desk,
                                    empno,
                                    booking_date
                            )                    As row_number,
                            Count(*)
                            Over()               As total_row
                          From
                            (                                            
                                    With
                                    params As (
                                        Select
                                            trunc(v_attendance_date) p_date
                                        From
                                            dual
                                    ),
                                    desk_booking As (
                                        Select
                                            key_id,
                                            empno,
                                            attendance_date As booking_date,
                                            deskid          As booked_desk,
                                            office          As desk_office,
                                            shiftcode
                                        From
                                            db_desk_bookings db,
                                            params           p
                                        Where
                                            attendance_date = p.p_date
                                    ),
                                    emp_area As(
                                        Select
                                            a.empno,
                                            c.area_desc   As area_desc,
                                            c.area_key_id As area_id
                                
                                        From
                                            vu_emplmast                        a
                                            Join dms.dm_area_type_user_mapping b
                                            On a.empno = b.empno
                                            Join dms.dm_desk_areas             c
                                            On c.area_key_id = b.area_id
                                        Where
                                            a.status = 1
                                    ),
                                    emp_location As(
                                        Select
                                            empno,
                                            tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                                tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                    a.empno, trunc(sysdate)
                                                )
                                            ) As office_location_desc,
                                            tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                a.empno, trunc(sysdate)
                                            ) As office_location_code
                                        From
                                            vu_emplmast a
                                        Where
                                            a.status = 1
                                    )
                                Select
                                    booking_data.*,
                                    Case
                                        When booked_desk Is Null Then
                                            0
                                        When booked_desk Is Not Null Then
                                            1
                                        Else
                                            -1
                                    End As is_desk_book_val,
                                    Case
                                        When booked_desk Is Null Then
                                            'No'
                                        When booked_desk Is Not Null Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_desk_book_text,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            0
                                        Else
                                            1
                                    End As is_present_val,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            Null
                                        Else
                                            'Yes'
                                    End As is_present_text,
                                    replace(
                                        selfservice.self_attendance.get_emp_office(
                                            empno, (p_date)
                                        ),
                                        'ERR',
                                        ''
                                    )   As punch_in_office,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            1
                                        Else
                                            0
                                    End As is_cross_attend_val,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_cross_attend_text
                                From
                                    (
                                        Select
                                            e.empno,
                                            e.name                   emp_name,
                                            e.parent as dept_code,
                                            c.name                   dept_name,
                                            ea.area_desc,
                                            ea.area_id,
                                            el.office_location_desc,
                                            el.office_location_code,
                                            mel.office_location_code map_office_loc_code,
                                            db.key_id,
                                            db.booking_date,
                                            db.booked_desk,
                                            db.desk_office,
                                            db.shiftcode,
                                            p.p_date
                                        From
                                            vu_emplmast                             e
                                            Inner Join vu_costmast                  c
                                            On e.parent = c.costcode
                                            Left Join emp_area                      ea
                                            On e.empno = ea.empno
                                            Left Join emp_location                  el
                                            On e.empno = el.empno
                                            Left Join desk_book.db_map_emp_location mel
                                            On e.empno = mel.empno
                                            Left Join desk_booking                  db
                                            On e.empno = db.empno
                                            Cross Join params                       p
                                        Where
                                            e.status = 1
                                    ) booking_data
                                Where
                                    (office_location_code = '02' 
                                        Or office_location_code = '01'
                                        Or map_office_loc_code = '02')  
                            )
                         Where
                              nvl(area_id, ' ' ) = nvl( p_area_id,nvl( area_id, ' ' ))
                               And dept_code = nvl( Trim(p_cost_code), dept_code )                                         
                               And is_desk_book_val = nvl( p_is_desk_booked, is_desk_book_val )
                               And is_present_val = nvl( p_is_present, is_present_val )
                               And ( upper(empno) Like '%' || upper( Trim(p_generic_search) ) || '%'
                                    Or upper(emp_name) Like '%' || upper( Trim(p_generic_search) ) 
                                )
                                  )
                    Where
                       row_number Between ( nvl(
                           p_row_number,
                           0
                       ) + 1 ) And ( nvl(
                           p_row_number,
                           0
                       ) + p_page_length );
        Return c;
    End fn_desk_book_4_dms_history_list;

    Function fn_desk_book_4_hod_xl (
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_generic_search  Varchar2 Default Null,
        p_area_id         Varchar2 Default Null,
        p_cost_code       Varchar2 Default Null,
        p_attendance_date Date Default Null
    ) Return Sys_Refcursor Is
        c                 Sys_Refcursor;
        v_count           Number;
        v_empno           Varchar2(5);
        e_employee_not_found Exception;
        v_attendance_date Date;
        Pragma exception_init ( e_employee_not_found, -20001 );
        v_next_work_date  Date;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        --v_next_work_date := selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1);

        If p_attendance_date Is Null Then
            v_attendance_date := trunc(sysdate);
        Else
            v_attendance_date := trunc(p_attendance_date);
        End If;

        Open c For     
            Select
                            key_id,
                            area_desc,
                            area_id,
                            empno,
                            emp_name,
                            dept_code,
                            dept_name,
                            booking_date,
                            booked_desk,
                            desk_office,
                            shiftcode,
                            is_desk_book_val,
                            is_desk_book_text    As is_desk_book,
                            is_present_val,
                            is_present_text      As is_present,
                            punch_in_office,
                            is_cross_attend_val,
                            is_cross_attend_text As is_cross_attend,
                            Row_Number()
                            Over(
                                 Order By
                                    booked_desk,
                                    empno,
                                    booking_date
                            )                    As row_number,
                            Count(*)
                            Over()               As total_row
                          From
                            (                                            
                                    With
                                    params As (
                                        Select
                                            trunc(v_attendance_date) p_date
                                        From
                                            dual
                                    ),
                                    desk_booking As (
                                        Select
                                            key_id,
                                            empno,
                                            attendance_date As booking_date,
                                            deskid          As booked_desk,
                                            office          As desk_office,
                                            shiftcode
                                        From
                                            db_desk_bookings db,
                                            params           p
                                        Where
                                            attendance_date = p.p_date
                                    ),
                                    emp_area As(
                                        Select
                                            a.empno,
                                            c.area_desc   As area_desc,
                                            c.area_key_id As area_id
                                
                                        From
                                            vu_emplmast                        a
                                            Join dms.dm_area_type_user_mapping b
                                            On a.empno = b.empno
                                            Join dms.dm_desk_areas             c
                                            On c.area_key_id = b.area_id
                                        Where
                                            a.status = 1
                                    ),
                                    emp_location As(
                                        Select
                                            empno,
                                            tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                                tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                    a.empno, trunc(sysdate)
                                                )
                                            ) As office_location_desc,
                                            tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                a.empno, trunc(sysdate)
                                            ) As office_location_code
                                        From
                                            vu_emplmast a
                                        Where
                                            a.status = 1
                                    )
                                Select
                                    booking_data.*,
                                    Case
                                        When booked_desk Is Null Then
                                            0
                                        When booked_desk Is Not Null Then
                                            1
                                        Else
                                            -1
                                    End As is_desk_book_val,
                                    Case
                                        When booked_desk Is Null Then
                                            'No'
                                        When booked_desk Is Not Null Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_desk_book_text,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            0
                                        Else
                                            1
                                    End As is_present_val,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            Null
                                        Else
                                            'Yes'
                                    End As is_present_text,
                                    replace(
                                        selfservice.self_attendance.get_emp_office(
                                            empno, (p_date)
                                        ),
                                        'ERR',
                                        ''
                                    )   As punch_in_office,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            1
                                        Else
                                            0
                                    End As is_cross_attend_val,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_cross_attend_text
                                From
                                    (
                                        Select
                                            e.empno,
                                            e.name                   emp_name,
                                            e.parent as dept_code,
                                            c.name                   dept_name,
                                            ea.area_desc,
                                            ea.area_id,
                                            el.office_location_desc,
                                            el.office_location_code,
                                            mel.office_location_code map_office_loc_code,
                                            db.key_id,
                                            db.booking_date,
                                            db.booked_desk,
                                            db.desk_office,
                                            db.shiftcode,
                                            p.p_date
                                        From
                                            vu_emplmast                             e
                                            Inner Join vu_costmast                  c
                                            On e.parent = c.costcode
                                            Left Join emp_area                      ea
                                            On e.empno = ea.empno
                                            Left Join emp_location                  el
                                            On e.empno = el.empno
                                            Left Join desk_book.db_map_emp_location mel
                                            On e.empno = mel.empno
                                            Left Join desk_booking                  db
                                            On e.empno = db.empno
                                            Cross Join params                       p
                                        Where
                                            e.status = 1
                                    ) booking_data
                                Where
                                    (office_location_code = '02' 
                                        Or office_location_code = '01'
                                        Or map_office_loc_code = '02')
                            )
                         Where
                            dept_code In (
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
                               And nvl(area_id, ' ' ) = nvl( p_area_id,nvl( area_id, ' ' ))
                               And dept_code = nvl( Trim(p_cost_code), dept_code )                                         
                              -- And is_desk_book_val = nvl( p_is_desk_booked, is_desk_book_val )
                              -- And is_present_val = nvl( p_is_present, is_present_val )
                               And ( upper(empno) Like '%' || upper( Trim(p_generic_search) ) || '%'
                                    Or upper(emp_name) Like '%' || upper( Trim(p_generic_search) ) 
                                )
                   Order By
                      booked_desk,
                      empno,
                      booking_date,
                      area_desc;
        Return c;
    End fn_desk_book_4_hod_xl;

    Function fn_desk_book_4_hod_history_xl (
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_generic_search  Varchar2 Default Null,
        p_area_id         Varchar2 Default Null,
        p_cost_code       Varchar2 Default Null,
        p_attendance_date Date Default Null
    ) Return Sys_Refcursor Is
        c                 Sys_Refcursor;
        v_count           Number;
        v_empno           Varchar2(5);
        e_employee_not_found Exception;
        v_attendance_date Date;
        Pragma exception_init ( e_employee_not_found, -20001 );
        v_next_work_date  Date;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        --v_next_work_date := selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1);

        If p_attendance_date Is Null Then
            v_attendance_date := trunc(sysdate);
        Else
            v_attendance_date := trunc(p_attendance_date);
        End If;

         Open c For 
          Select
                            key_id,
                            area_desc,
                            area_id,
                            empno,
                            emp_name,
                            dept_code,
                            dept_name,
                            booking_date,
                            booked_desk,
                            desk_office,
                            shiftcode,
                            is_desk_book_val,
                            is_desk_book_text    As is_desk_book,
                            is_present_val,
                            is_present_text      As is_present,
                            punch_in_office,
                            is_cross_attend_val,
                            is_cross_attend_text As is_cross_attend,
                            Row_Number()
                            Over(
                                 Order By
                                    booked_desk,
                                    empno,
                                    booking_date
                            )                    As row_number,
                            Count(*)
                            Over()               As total_row
                          From
                            (                                            
                                  With
                                    params As (
                                        Select
                                            trunc(v_attendance_date) p_date
                                        From
                                            dual
                                    ),
                                    desk_booking As (
                                        Select
                                            key_id,
                                            empno,
                                            attendance_date As booking_date,
                                            deskid          As booked_desk,
                                            office          As desk_office,
                                            shiftcode
                                        From
                                            db_desk_bookings db,
                                            params           p
                                        Where
                                            attendance_date = p.p_date
                                    ),
                                    emp_area As(
                                        Select
                                            a.empno,
                                            c.area_desc   As area_desc,
                                            c.area_key_id As area_id
                                
                                        From
                                            vu_emplmast                        a
                                            Join dms.dm_area_type_user_mapping b
                                            On a.empno = b.empno
                                            Join dms.dm_desk_areas             c
                                            On c.area_key_id = b.area_id
                                        Where
                                            a.status = 1
                                    ),
                                    emp_location As(
                                        Select
                                            empno,
                                            tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                                tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                    a.empno, trunc(sysdate)
                                                )
                                            ) As office_location_desc,
                                            tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                a.empno, trunc(sysdate)
                                            ) As office_location_code
                                        From
                                            vu_emplmast a
                                        Where
                                            a.status = 1
                                    )
                                Select
                                    booking_data.*,
                                    Case
                                        When booked_desk Is Null Then
                                            0
                                        When booked_desk Is Not Null Then
                                            1
                                        Else
                                            -1
                                    End As is_desk_book_val,
                                    Case
                                        When booked_desk Is Null Then
                                            'No'
                                        When booked_desk Is Not Null Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_desk_book_text,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            0
                                        Else
                                            1
                                    End As is_present_val,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            Null
                                        Else
                                            'Yes'
                                    End As is_present_text,
                                    replace(
                                        selfservice.self_attendance.get_emp_office(
                                            empno, (p_date)
                                        ),
                                        'ERR',
                                        ''
                                    )   As punch_in_office,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            1
                                        Else
                                            0
                                    End As is_cross_attend_val,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_cross_attend_text
                                From
                                    (
                                        Select
                                            e.empno,
                                            e.name                   emp_name,
                                            e.parent as dept_code,
                                            c.name                   dept_name,
                                            ea.area_desc,
                                            ea.area_id,
                                            el.office_location_desc,
                                            el.office_location_code,
                                            mel.office_location_code map_office_loc_code,
                                            db.key_id,
                                            db.booking_date,
                                            db.booked_desk,
                                            db.desk_office,
                                            db.shiftcode,
                                            p.p_date
                                        From
                                            vu_emplmast                             e
                                            Inner Join vu_costmast                  c
                                            On e.parent = c.costcode
                                            Left Join emp_area                      ea
                                            On e.empno = ea.empno
                                            Left Join emp_location                  el
                                            On e.empno = el.empno
                                            Left Join desk_book.db_map_emp_location mel
                                            On e.empno = mel.empno
                                            Left Join desk_booking                  db
                                            On e.empno = db.empno
                                            Cross Join params                       p
                                        Where
                                            e.status = 1
                                    ) booking_data
                                Where
                                    (office_location_code = '02' 
                                        Or office_location_code = '01'
                                        Or map_office_loc_code = '02')
                            )
                         Where
                            dept_code In (
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
                               And nvl(area_id, ' ' ) = nvl( p_area_id,nvl( area_id, ' ' ))
                               And dept_code = nvl( Trim(p_cost_code), dept_code )                                         
                              -- And is_desk_book_val = nvl( p_is_desk_booked, is_desk_book_val )
                              -- And is_present_val = nvl( p_is_present, is_present_val )
                               And ( upper(empno) Like '%' || upper( Trim(p_generic_search) ) || '%'
                                    Or upper(emp_name) Like '%' || upper( Trim(p_generic_search) ) 
                                )
                   Order By
                      booked_desk,
                      empno,
                      booking_date,
                      area_desc;
        Return c;
    End fn_desk_book_4_hod_history_xl;

    Function fn_desk_book_4_dms_xl (
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_generic_search  Varchar2 Default Null,
        p_area_id         Varchar2 Default Null,
        p_cost_code       Varchar2 Default Null,
        p_attendance_date Date Default Null
    ) Return Sys_Refcursor Is
        c                 Sys_Refcursor;
        v_count           Number;
        v_empno           Varchar2(5);
        e_employee_not_found Exception;
        v_attendance_date Date;
        Pragma exception_init ( e_employee_not_found, -20001 );
        v_next_work_date  Date;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        --v_next_work_date := selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1);

        If p_attendance_date Is Null Then
            v_attendance_date := trunc(sysdate);
        Else
            v_attendance_date := trunc(p_attendance_date);
        End If;

         
        Open c For  
         Select
                            key_id,
                            area_desc,
                            area_id,
                            empno,
                            emp_name,
                            dept_code,
                            dept_name,
                            booking_date,
                            booked_desk,
                            desk_office,
                            shiftcode,
                            is_desk_book_val,
                            is_desk_book_text    As is_desk_book,
                            is_present_val,
                            is_present_text      As is_present,
                            punch_in_office,
                            is_cross_attend_val,
                            is_cross_attend_text As is_cross_attend,
                            Row_Number()
                            Over(
                                 Order By
                                    booked_desk,
                                    empno,
                                    booking_date
                            )                    As row_number,
                            Count(*)
                            Over()               As total_row
                          From
                            (                                            
                                    With
                                    params As (
                                        Select
                                            trunc(v_attendance_date) p_date
                                        From
                                            dual
                                    ),
                                    desk_booking As (
                                        Select
                                            key_id,
                                            empno,
                                            attendance_date As booking_date,
                                            deskid          As booked_desk,
                                            office          As desk_office,
                                            shiftcode
                                        From
                                            db_desk_bookings db,
                                            params           p
                                        Where
                                            attendance_date = p.p_date
                                    ),
                                    emp_area As(
                                        Select
                                            a.empno,
                                            c.area_desc   As area_desc,
                                            c.area_key_id As area_id
                                
                                        From
                                            vu_emplmast                        a
                                            Join dms.dm_area_type_user_mapping b
                                            On a.empno = b.empno
                                            Join dms.dm_desk_areas             c
                                            On c.area_key_id = b.area_id
                                        Where
                                            a.status = 1
                                    ),
                                    emp_location As(
                                        Select
                                            empno,
                                            tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                                tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                    a.empno, trunc(sysdate)
                                                )
                                            ) As office_location_desc,
                                            tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                a.empno, trunc(sysdate)
                                            ) As office_location_code
                                        From
                                            vu_emplmast a
                                        Where
                                            a.status = 1
                                    )
                                Select
                                    booking_data.*,
                                    Case
                                        When booked_desk Is Null Then
                                            0
                                        When booked_desk Is Not Null Then
                                            1
                                        Else
                                            -1
                                    End As is_desk_book_val,
                                    Case
                                        When booked_desk Is Null Then
                                            'No'
                                        When booked_desk Is Not Null Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_desk_book_text,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            0
                                        Else
                                            1
                                    End As is_present_val,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            Null
                                        Else
                                            'Yes'
                                    End As is_present_text,
                                    replace(
                                        selfservice.self_attendance.get_emp_office(
                                            empno, (p_date)
                                        ),
                                        'ERR',
                                        ''
                                    )   As punch_in_office,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            1
                                        Else
                                            0
                                    End As is_cross_attend_val,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_cross_attend_text
                                From
                                    (
                                        Select
                                            e.empno,
                                            e.name                   emp_name,
                                            e.parent as dept_code,
                                            c.name                   dept_name,
                                            ea.area_desc,
                                            ea.area_id,
                                            el.office_location_desc,
                                            el.office_location_code,
                                            mel.office_location_code map_office_loc_code,
                                            db.key_id,
                                            db.booking_date,
                                            db.booked_desk,
                                            db.desk_office,
                                            db.shiftcode,
                                            p.p_date
                                        From
                                            vu_emplmast                             e
                                            Inner Join vu_costmast                  c
                                            On e.parent = c.costcode
                                            Left Join emp_area                      ea
                                            On e.empno = ea.empno
                                            Left Join emp_location                  el
                                            On e.empno = el.empno
                                            Left Join desk_book.db_map_emp_location mel
                                            On e.empno = mel.empno
                                            Left Join desk_booking                  db
                                            On e.empno = db.empno
                                            Cross Join params                       p
                                        Where
                                            e.status = 1
                                    ) booking_data
                                Where
                                    (office_location_code = '02' 
                                        Or office_location_code = '01'
                                        Or map_office_loc_code = '02')
                            )
                         Where
                             nvl(area_id, ' ' ) = nvl( p_area_id,nvl( area_id, ' ' ))
                               And dept_code = nvl( Trim(p_cost_code), dept_code )                                         
                              -- And is_desk_book_val = nvl( p_is_desk_booked, is_desk_book_val )
                              -- And is_present_val = nvl( p_is_present, is_present_val )
                               And ( upper(empno) Like '%' || upper( Trim(p_generic_search) ) || '%'
                                    Or upper(emp_name) Like '%' || upper( Trim(p_generic_search) ) 
                                )
                   Order By
                      booked_desk,
                      empno,
                      booking_date,
                      area_desc;
        Return c;
    End fn_desk_book_4_dms_xl;

    Function fn_desk_book_4_dms_history_xl (
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_generic_search  Varchar2 Default Null,
        p_area_id         Varchar2 Default Null,
        p_cost_code       Varchar2 Default Null,
        p_attendance_date Date Default Null
    ) Return Sys_Refcursor Is
        c                 Sys_Refcursor;
        v_count           Number;
        v_empno           Varchar2(5);
        e_employee_not_found Exception;
        v_attendance_date Date;
        Pragma exception_init ( e_employee_not_found, -20001 );
        v_next_work_date  Date;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        --v_next_work_date := selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1);

        If p_attendance_date Is Null Then
            v_attendance_date := trunc(sysdate);
        Else
            v_attendance_date := trunc(p_attendance_date);
        End If;

       Open c For 
         Select
                            key_id,
                            area_desc,
                            area_id,
                            empno,
                            emp_name,
                            dept_code,
                            dept_name,
                            booking_date,
                            booked_desk,
                            desk_office,
                            shiftcode,
                            is_desk_book_val,
                            is_desk_book_text    As is_desk_book,
                            is_present_val,
                            is_present_text      As is_present,
                            punch_in_office,
                            is_cross_attend_val,
                            is_cross_attend_text As is_cross_attend,
                            Row_Number()
                            Over(
                                 Order By
                                    booked_desk,
                                    empno,
                                    booking_date
                            )                    As row_number,
                            Count(*)
                            Over()               As total_row
                          From
                            (                                            
                                   With
                                    params As (
                                        Select
                                            trunc(v_attendance_date) p_date
                                        From
                                            dual
                                    ),
                                    desk_booking As (
                                        Select
                                            key_id,
                                            empno,
                                            attendance_date As booking_date,
                                            deskid          As booked_desk,
                                            office          As desk_office,
                                            shiftcode
                                        From
                                            db_desk_bookings db,
                                            params           p
                                        Where
                                            attendance_date = p.p_date
                                    ),
                                    emp_area As(
                                        Select
                                            a.empno,
                                            c.area_desc   As area_desc,
                                            c.area_key_id As area_id
                                
                                        From
                                            vu_emplmast                        a
                                            Join dms.dm_area_type_user_mapping b
                                            On a.empno = b.empno
                                            Join dms.dm_desk_areas             c
                                            On c.area_key_id = b.area_id
                                        Where
                                            a.status = 1
                                    ),
                                    emp_location As(
                                        Select
                                            empno,
                                            tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                                tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                    a.empno, trunc(sysdate)
                                                )
                                            ) As office_location_desc,
                                            tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                a.empno, trunc(sysdate)
                                            ) As office_location_code
                                        From
                                            vu_emplmast a
                                        Where
                                            a.status = 1
                                    )
                                Select
                                    booking_data.*,
                                    Case
                                        When booked_desk Is Null Then
                                            0
                                        When booked_desk Is Not Null Then
                                            1
                                        Else
                                            -1
                                    End As is_desk_book_val,
                                    Case
                                        When booked_desk Is Null Then
                                            'No'
                                        When booked_desk Is Not Null Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_desk_book_text,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            0
                                        Else
                                            1
                                    End As is_present_val,
                                    Case
                                        When replace(
                                                selfservice.self_attendance.get_emp_office(
                                                    empno, (p_date)
                                                ),
                                                'ERR',
                                                'NA'
                                            ) = 'NA'
                                        Then
                                            Null
                                        Else
                                            'Yes'
                                    End As is_present_text,
                                    replace(
                                        selfservice.self_attendance.get_emp_office(
                                            empno, (p_date)
                                        ),
                                        'ERR',
                                        ''
                                    )   As punch_in_office,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            1
                                        Else
                                            0
                                    End As is_cross_attend_val,
                                    Case
                                        When nvl(desk_office, 'NULL') !=
                                            Trim(selfservice.self_attendance.get_emp_office(empno, p_date))
                                        Then
                                            'Yes'
                                        Else
                                            ''
                                    End As is_cross_attend_text
                                From
                                    (
                                        Select
                                            e.empno,
                                            e.name                   emp_name,
                                            e.parent as dept_code,
                                            c.name                   dept_name,
                                            ea.area_desc,
                                            ea.area_id,
                                            el.office_location_desc,
                                            el.office_location_code,
                                            mel.office_location_code map_office_loc_code,
                                            db.key_id,
                                            db.booking_date,
                                            db.booked_desk,
                                            db.desk_office,
                                            db.shiftcode,
                                            p.p_date
                                        From
                                            vu_emplmast                             e
                                            Inner Join vu_costmast                  c
                                            On e.parent = c.costcode
                                            Left Join emp_area                      ea
                                            On e.empno = ea.empno
                                            Left Join emp_location                  el
                                            On e.empno = el.empno
                                            Left Join desk_book.db_map_emp_location mel
                                            On e.empno = mel.empno
                                            Left Join desk_booking                  db
                                            On e.empno = db.empno
                                            Cross Join params                       p
                                        Where
                                            e.status = 1
                                    ) booking_data
                                Where
                                    (office_location_code = '02' 
                                        Or office_location_code = '01'
                                        Or map_office_loc_code = '02')  
                            )
                         Where 
                         nvl(area_id, ' ' ) = nvl( p_area_id,nvl( area_id, ' ' ))
                               And dept_code = nvl( Trim(p_cost_code), dept_code )                                         
                              -- And is_desk_book_val = nvl( p_is_desk_booked, is_desk_book_val )
                              -- And is_present_val = nvl( p_is_present, is_present_val )
                               And ( upper(empno) Like '%' || upper( Trim(p_generic_search) ) || '%'
                                    Or upper(emp_name) Like '%' || upper( Trim(p_generic_search) ) 
                                )
                   Order By
                      booked_desk,
                      empno,
                      booking_date,
                      area_desc;
        Return c;
    End fn_desk_book_4_dms_history_xl;

    Function fn_is_present_get (
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_empno           Varchar2,
        p_attendance_date Date
    ) Return Varchar2 Is
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        If p_empno Is Null Or p_attendance_date Is Null Then
            Return Null;
        End If;
        If replace(
                  selfservice.self_attendance.get_emp_office(
                                                            p_empno,
                                                            trunc(p_attendance_date)
                  ),
                  'ERR',
                  'NA'
           ) = 'NA' Then
            Return Null;
        Else
            Return 'Yes';
        End If;
    Exception
        When Others Then
            Return Null;
    End;

End pkg_deskbooking_qry;
/