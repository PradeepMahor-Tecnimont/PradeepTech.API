Create Or Replace Package Body desk_book.pkg_db_area_wise_desk_booking_qry As

    Function fn_area_wise_desk_booking_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_area_catg_code Varchar2,
        p_area_id        Varchar2 Default Null,
        p_office         Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
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
                       With
                           params
                           As (
                               Select trunc(sysdate)                                                As bdate,
                                      selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1) As edate
                                 From dual
                           )
                       Select a.area_catg_code,
                              b.work_area                           As area_id,
                              a.area_desc                           As area_desc,
                              b.office,
                              b.floor,
                              b.wing,
                              b.deskid                              As desk_id,
                              c.empno                               As emp_no,
                              get_emp_name(c.empno)                 As emp_name,
                              c.attendance_date,
                              Case
                                  When c.empno Is Not Null Then
                                      'Booked'
                                  Else
                                      'NA'
                              End                                   As is_booked,
                              Row_Number() Over (Order By b.deskid) row_number,
                              Count(*) Over ()                      total_row
                         From dms.dm_deskmaster      b
                        Cross Join params            p
                        Inner Join dms.dm_desk_areas a
                           On b.work_area = a.area_key_id
                         Left Join db_desk_bookings  c
                           On c.deskid = b.deskid
                          And
                              c.attendance_date Between p.bdate And p.edate
                        Where a.area_catg_code = 'A005'
                          And nvl(b.work_area, ' ') = nvl(p_area_id, nvl(b.work_area, ' '))
                          And Trim(b.office) = nvl(p_office, Trim(b.office))
                          And (upper(b.work_area) Like '%' || upper(Trim(p_generic_search)) || '%'
                           Or upper(b.deskid) Like '%' || upper(Trim(p_generic_search)) || '%'
                           Or upper(c.empno) Like '%' || upper(Trim(p_generic_search)) || '%')
                   )
             Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_area_wise_desk_booking_list;

    Function fn_area_wise_desk_booking_xl_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null
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
                       With
                           params
                           As (
                               Select trunc(sysdate)                                                As bdate,
                                      selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1) As edate
                                 From dual
                           )
                       Select a.area_catg_code,
                              b.work_area                           As area_id,
                              a.area_desc                           As area_desc,
                              b.office,
                              b.floor,
                              b.wing,
                              b.deskid                              As desk_id,
                              c.empno                               As emp_no,
                              get_emp_name(c.empno)                 As emp_name,
                              c.attendance_date,
                              Case
                                  When c.empno Is Not Null Then
                                      'Booked'
                                  Else
                                      'NA'
                              End                                   As is_booked,
                              Row_Number() Over (Order By b.deskid) row_number,
                              Count(*) Over ()                      total_row
                         From dms.dm_deskmaster      b
                        Cross Join params            p
                        Inner Join dms.dm_desk_areas a
                           On b.work_area = a.area_key_id
                         Left Join db_desk_bookings  c
                           On c.deskid = b.deskid
                          And
                              c.attendance_date Between p.bdate And p.edate
                        Where a.area_catg_code = 'A005')
             Order By area_catg_code;
        Return c;
    End fn_area_wise_desk_booking_xl_list;

End pkg_db_area_wise_desk_booking_qry;
/
  Grant Execute On desk_book.pkg_db_area_wise_desk_booking_qry To tcmpl_app_config;