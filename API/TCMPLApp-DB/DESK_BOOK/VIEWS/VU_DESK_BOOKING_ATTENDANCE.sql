Create Or Replace Force Editionable View "DESK_BOOK"."VU_DESK_BOOKING_ATTENDANCE" ( "KEY_ID",
"AREA_DESC",
"AREA_ID",
"EMPNO",
"EMP_NAME",
"DEPT_CODE",
"DEPT_NAME",
"BOOKING_DATE",
"BOOKED_DESK",
"DESK_OFFICE",
"SHIFTCODE",
"IS_DESK_BOOK_VAL",
"IS_DESK_BOOK_TEXT",
"IS_PRESENT_VAL",
"IS_PRESENT_TEXT",
"PUNCH_IN_OFFICE",
"IS_CROSS_ATTEND_VAL",
"IS_CROSS_ATTEND_TEXT" ) As
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
        Case
            When booked_desk Is Null Then
                0
            When booked_desk Is Not Null Then
                1
            Else
                - 1
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
                    empno,
                    trunc(booking_date)
                ),
                'ERR',
                'NA'
            ) = 'NA' Then
                0
            Else
                1
        End As is_present_val,
        Case
            When booking_date Is Null Then
                ''
            When replace(
                selfservice.self_attendance.get_emp_office(
                    empno,
                    trunc(booking_date)
                ),
                'ERR',
                'NA'
            ) = 'NA' Then
                'No'
            Else
                'Yes'
        End As is_present_text,
        Case
            When booking_date Is Null Then
                ''
            Else
                replace(
                    selfservice.self_attendance.get_emp_office(
                        empno,
                        trunc(booking_date)
                    ),
                    'ERR',
                    ''
                )
        End As punch_in_office,
        Case
            When replace(
                desk_office,
                Null,
                Null
            ) != replace(
                selfservice.self_attendance.get_emp_office(
                    empno,
                    trunc(booking_date)
                ),
                'ERR',
                Null
            ) Then
                1
            Else
                0
        End As is_cross_attend_val,
        Case
            When replace(
                desk_office,
                Null,
                Null
            ) != replace(
                selfservice.self_attendance.get_emp_office(
                    empno,
                    trunc(booking_date)
                ),
                'ERR',
                Null
            ) Then
                'Yes'
            Else
                ''
        End As is_cross_attend_text
      From
        (
            With emp_area As (
                Select
                    a.empno,
                    c.area_desc                              As area,
                    c.area_key_id                            As area_id,
                    tcmpl_hr.pkg_common.fn_get_office_location_desc(
                        tcmpl_hr.pkg_common.fn_get_emp_office_location(
                            a.empno,
                            sysdate
                        )
                    )                                        As office_location,
                    Case
                        When db_map_emp_location.office_location_code Is Null Then
                            tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                a.empno,
                                sysdate
                            )
                        Else
                            db_map_emp_location.office_location_code
                    End                                      As office_location_code,
                    db_map_emp_location.office_location_code As emp_map_location_code
                  From
                    vu_emplmast                   a
                      Left Outer Join dms.dm_area_type_user_mapping b
                    On a.empno = b.empno
                      Left Outer Join dms.dm_desk_areas             c
                    On c.area_key_id = b.area_id
                      Left Outer Join desk_book.db_map_emp_location db_map_emp_location
                    On a.empno = db_map_emp_location.empno
                 Where
                    a.status = 1
            )
            Select
                desk_book.key_id          As key_id,
                Case
                    When emp_area.area_id Is Null Then
                        ''
                    Else
                        emp_area.area
                End                       As area_desc,
                emp_area.area_id          As area_id,
                vu_emplmast.empno         As empno,
                vu_emplmast.name          As emp_name,
                vu_costmast.costcode      As dept_code,
                vu_costmast.name          As dept_name,
                desk_book.attendance_date As booking_date,
                desk_book.deskid          As booked_desk,
                desk_book.office          As desk_office,
                desk_book.shiftcode       As shiftcode,
                Case
                    When desk_book.deskid Is Null Then
                        0
                    Else
                        1
                End                       As is_desk_book_val,
                Case
                    When desk_book.deskid Is Null Then
                        'No'
                    Else
                        'Yes'
                End                       As is_desk_book_text,
                Row_Number()
                Over(
                     Order By
                        desk_book.deskid,
                        vu_emplmast.empno,
                        desk_book.attendance_date
                )                         As row_number,
                Count(*)
                Over()                    As total_row
              From
                     vu_emplmast
                 Cross Join emp_area emp_area
                 Inner Join vu_costmast
                On vu_emplmast.parent = vu_costmast.costcode
                  Left Outer Join desk_book.db_desk_bookings desk_book
                On desk_book.empno = vu_emplmast.empno
                   And desk_book.attendance_date >= trunc(sysdate)
             Where
                    vu_emplmast.status = 1
                   And emp_area.empno = vu_emplmast.empno
                   And emp_area.office_location_code In (
                    Select
                        office_location_code
                      From
                        dms.dm_offices
                     Where
                        smart_desk_booking_enabled = ok
                )
        );