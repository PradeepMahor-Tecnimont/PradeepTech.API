create or replace Package Body dms.pkg_emp_desk_in_more_than_1places As

    Function fn_desk_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number   Default Null,
        p_page_length    Number Default Null
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
            distinct
                empno,
                emp_name,
                deskid,
                user_in,
                Count(*) Over () total_row
            From
                (
                    Select
                        t.empno,
                        get_emp_name(t.empno)                  emp_name,
                        t.deskid,
                        t.user_in,
                        Count(*) Over ( Partition By t.deskid,t.empno) As deskid_count
                    From
                        (
                            Select
                                empno, deskid, 'Desk Booking' user_in
                            From
                                desk_book.db_desk_bookings
                            Where
                                trunc(attendance_date) >= trunc(sysdate)
                            Union
                            Select
                                empno, deskid, 'DMS' user_in
                            From
                                dm_usermaster
                            Union
                            Select
                                empno, deskid, 'Cabin Bookings' user_in
                            From
                                desk_book.db_cabin_bookings
                            Where
                                trunc(attendance_date) >= trunc(sysdate)
                        ) t
                    Where
                        empno In (
                            Select
                                empno
                            From
                                ss_emplmast
                            Where
                                status = 1
                        )
                )
            Where
                deskid_count > 1                
            -- And row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                deskid;

        Return c;
    End fn_desk_list;

    Function fn_emp_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number   Default Null,
        p_page_length    Number Default Null
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                empno,
                emp_name,
                deskid,
                user_in,
                Count(*) Over () total_row
            From
                (
                    Select
                        t.empno,
                        get_emp_name(t.empno)                 emp_name,
                        t.deskid,
                        t.user_in,
                        Count(*) Over ( Partition By t.empno) As empno_count
                    From
                        (
                            Select
                                empno, deskid, 'Desk Booking' user_in
                            From
                                desk_book.db_desk_bookings
                            Where
                                trunc(attendance_date) >= trunc(sysdate)
                            Union
                            Select
                                empno, deskid, 'DMS' user_in
                            From
                                dm_usermaster
                            Union
                            Select
                                empno, deskid, 'Cabin Bookings' user_in
                            From
                                desk_book.db_cabin_bookings
                            Where
                                trunc(attendance_date) >= trunc(sysdate)
                        ) t
                    Where
                        empno In (
                            Select
                                empno
                            From
                                ss_emplmast
                            Where
                                status = 1
                        )
                )
            Where
                empno_count > 1
            --   And row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                empno;

        Return c;
    End;

End pkg_emp_desk_in_more_than_1places;