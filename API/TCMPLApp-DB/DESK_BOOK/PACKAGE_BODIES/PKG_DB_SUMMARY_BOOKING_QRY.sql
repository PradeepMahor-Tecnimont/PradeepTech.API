Create Or Replace Package Body desk_book.pkg_db_summary_booking_qry As

    Function fn_summary_booking_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_office         Varchar2,
        p_date           Date,
        p_action_id      Varchar2,
        p_generic_search Varchar2 Default Null,
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
        If p_office Is Null Or p_date Is Null Or p_action_id Is Null Then
            Return Null;
        End If;
        If p_action_id = 'A223' Then
            Open c For Select *
                         From (
                           Select office,
                                  work_area,
                                  area_desc,
                                  fn_get_desk_count(
                                      p_person_id => p_person_id,
                                      p_meta_id   => p_meta_id,
                                      p_office    => p_office,
                                      p_area_id   => work_area
                                  )                                     desk_count,
                                  assign,
                                  dept_emp_count,
                                  fn_get_booked_desk_count(
                                      p_person_id => p_person_id,
                                      p_meta_id   => p_meta_id,
                                      p_office    => p_office,
                                      p_date      => p_date,
                                      p_area_id   => work_area,
                                      p_costcode  => assign
                                  )                                     booked_desks,
                                  Row_Number() Over(Order By work_area) row_number,
                                  Count(*) Over()                       total_row
                             From (
                                      With datum As (
                                              Select Count(e.empno) dept_emp_count,
                                                     e.assign,
                                                     datum1.area_id
                                                From dms.dm_area_type_user_mapping datum1,
                                                     vu_emplmast                   e
                                               Where e.empno = datum1.empno
                                                 And datum1.from_date <= p_date
                                               Group By e.assign,
                                                     datum1.area_id
                                          )
                                      Select Distinct
                                             ddm.office,
                                             ddm.work_area,
                                             dda.area_desc,
                                             datum.assign,
                                             datum.dept_emp_count
                                        From dms.dm_deskmaster ddm,
                                             dms.dm_desk_areas dda,
                                             datum
                                       Where dda.area_catg_code = 'A005'
                                         And dda.area_key_id = ddm.work_area
                                         And Trim(ddm.office) = Trim(p_office)
                                         And ddm.work_area Is Not Null
                                         And ddm.work_area = datum.area_id (+)
                                         And (upper(dda.area_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                                          Or upper(datum.assign) Like '%' || upper(Trim(p_generic_search)) || '%')
                                  )
                       )
                        Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
                                                          Trim(p_generic_search)
            Open c For Select *
                         From (
                           Select office,
                                  work_area,
                                  area_desc,
                                  fn_get_desk_count(
                                      p_person_id => p_person_id,
                                      p_meta_id   => p_meta_id,
                                      p_office    => p_office,
                                      p_area_id   => work_area
                                  )                                     desk_count,
                                  assign,
                                  dept_emp_count,
                                  fn_get_booked_desk_count(
                                      p_person_id => p_person_id,
                                      p_meta_id   => p_meta_id,
                                      p_office    => p_office,
                                      p_date      => p_date,
                                      p_area_id   => work_area,
                                      p_costcode  => assign
                                  )                                     booked_desks,
                                  Row_Number() Over(Order By work_area) row_number,
                                  Count(*) Over()                       total_row
                             From (
                                      With datum As (
                                              Select Count(e.empno) dept_emp_count,
                                                     e.assign,
                                                     datum1.area_id
                                                From dms.dm_area_type_user_mapping datum1,
                                                     vu_emplmast                   e
                                               Where e.empno = datum1.empno
                                                 And datum1.from_date <= p_date
                                               Group By e.assign,
                                                     datum1.area_id
                                          )
                                      Select Distinct
                                             ddm.office,
                                             ddm.work_area,
                                             dda.area_desc,
                                             datum.assign,
                                             datum.dept_emp_count
                                        From dms.dm_deskmaster ddm,
                                             dms.dm_desk_areas dda,
                                             datum
                                       Where dda.area_catg_code = 'A005'
                                         And dda.area_key_id = ddm.work_area
                                         And Trim(ddm.office) = Trim(p_office)
                                         And ddm.work_area Is Not Null
                                         And ddm.work_area = datum.area_id (+)
                                         And datum.assign In (
                                                 Select costcode
                                                   From vu_costmast
                                                  Where hod = Trim(v_empno)
                                                 Union All
                                                 Select costcode
                                                   From vu_module_user_role_actions
                                                  Where empno = Trim(v_empno)
                                             )
                                         And (upper(dda.area_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                                          Or upper(datum.assign) Like '%' || upper(Trim(p_generic_search)) || '%')
                                  )
                       )
                        Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
                                                          Select
                                                              costcode
                                                            From
                                                              vu_costmast
                                                           Where
                                                              hod = Trim(v_empno)
                                                          Union All
                                                          Select
                                                              costcode
                                                            From
                                                              vu_module_user_role_actions
                                                           Where
                                                              empno = Trim(v_empno)
                                                      )
                                                         And ( upper(
                                                          dda.area_desc
                                                      ) Like '%' || upper(
                                                          Trim(p_generic_search)
                                                      ) || '%'
                                                          Or upper(
                                                          datum.assign
                                                      ) Like '%' || upper(
                                                          Trim(p_generic_search)
                                                      ) || '%' )
                                              )
                                      )
                        Where
                           row_number Between ( nvl(
                               p_row_number,
                               0
                           ) + 1 ) And ( nvl(
                               p_row_number,
                               0
        Select area_desc,
               fn_get_desk_count(
                   p_person_id => p_person_id,
                   p_meta_id   => p_meta_id,
                   p_office    => p_office,
                   p_area_id   => work_area
               ),
               dept_emp_count,
               fn_get_booked_desk_count(
                   p_person_id => p_person_id,
                   p_meta_id   => p_meta_id,
                   p_office    => p_office,
                   p_date      => p_date,
                   p_area_id   => work_area,
                   p_costcode  => p_costcode
               )
          Into p_area_desc,
               p_desk_count,
               p_dept_empno_count,
               p_booked_desks
          From (
                   With datum As (
                           Select Count(e.empno) dept_emp_count,
                                  e.assign,
                                  datum1.area_id
                             From dms.dm_area_type_user_mapping datum1,
                                  vu_emplmast                   e
                            Where e.empno = datum1.empno
                              And e.assign = Trim(p_costcode)
                              And datum1.from_date <= p_date
                            Group By e.assign,
                                  datum1.area_id
                       )
                   Select Distinct
                          dda.area_desc,
                          ddm.work_area,
                          dept_emp_count
                     From dms.dm_deskmaster ddm,
                          dms.dm_desk_areas dda,
                          datum
                    Where dda.area_catg_code = 'A005'
                      And dda.area_key_id = ddm.work_area
                      And Trim(ddm.office) = Trim(p_office)
                      And ddm.work_area = Trim(p_area_id)
                      And ddm.work_area = datum.area_id (+)
               );
            p_booked_desks
          From
            (
                With datum As (
                    Select
                        Count(e.empno) dept_emp_count,
                        e.assign,
                        datum1.area_id
                      From
                        dms.dm_area_type_user_mapping datum1,
                        vu_emplmast                   e
                     Where
                            e.empno = datum1.empno
                           And e.assign = Trim(p_costcode)
                           And datum1.from_date <= p_date
                     Group By
                        e.assign,
                        datum1.area_id
                )
                Select Distinct
                    dda.area_desc,
                    ddm.work_area,
                    dept_emp_count
                  From
                    dms.dm_deskmaster ddm,
                    dms.dm_desk_areas dda,
                    datum
                 Where
                        dda.area_catg_code = 'A005'
                       And dda.area_key_id  = ddm.work_area
                       And Trim(ddm.office) = Trim(p_office)
        Select Count(*)
          Into v_count
          From db_desk_bookings  ddb,
               dms.dm_deskmaster ddm,
               dms.dm_desk_areas dda,
               vu_emplmast       e
         Where dda.area_catg_code = 'A005'
           And dda.area_key_id = ddm.work_area
           And ddm.deskid = ddb.deskid
           And e.empno = ddb.empno
           And Trim(ddm.office) = ddb.office
           And e.assign = Trim(p_costcode)
           And ddm.work_area = Trim(p_area_id)
           And Trim(ddm.office) = Trim(p_office)
           And ddb.attendance_date = p_date;
                       And ddm.work_area    = datum.area_id (+)
            );

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Function fn_get_booked_desk_count(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_office    Varchar2,
        p_date      Date,
        Select
            Count(*)
          Into v_count
          From
            db_desk_bookings  ddb,
            dms.dm_deskmaster ddm,
        Select Count(*)
          Into v_count
          From dms.dm_deskmaster ddm,
               dms.dm_desk_areas dda
         Where dda.area_catg_code = 'A005'
           And dda.area_key_id = ddm.work_area
           And ddm.work_area = Trim(p_area_id)
           And Trim(ddm.office) = Trim(p_office);
               And ddb.attendance_date = p_date;
            Count(*)
          Into v_count
          From
            db_desk_bookings  ddb,
            dms.dm_deskmaster ddm,
            dms.dm_desk_areas dda,
            vu_emplmast       e
         Where
                dda.area_catg_code = 'A005'
               And dda.area_key_id     = ddm.work_area
               And ddm.deskid          = ddb.deskid
               And e.empno             = ddb.empno
               And Trim(ddm.office)    = ddb.office
               And e.assign            = Trim(p_costcode)
               And ddm.work_area       = Trim(p_area_id)
               And Trim(ddm.office)    = Trim(p_office)
               And ddb.attendance_date = p_date;
        Return v_count;
    End;

    Function fn_get_desk_count(
        p_person_id Varchar2,
        Select
            Count(*)
          Into v_count
        Open c For Select *
                     From (
                       Select ddm.floor,
                              ddm.wing,
                              ddm.work_area,
                              ddm.deskid,
                              Row_Number() Over(Order By ddm.deskid) row_number,
                              Count(*) Over()                        total_row
                         From dms.dm_deskmaster ddm,
                              dms.dm_desk_areas dda
                        Where dda.area_catg_code = 'A005'
                          And dda.area_key_id = ddm.work_area
                          And ddm.work_area = Trim(p_area_id)
                          And Trim(ddm.office) = Trim(p_office)
                          And (upper(ddm.floor) Like '%' || upper(Trim(p_generic_search)) || '%'
                           Or upper(ddm.wing) Like '%' || upper(Trim(p_generic_search)) || '%'
                           Or upper(ddm.deskid) Like '%' || upper(Trim(p_generic_search)) || '%')
                   )
                    Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return v_count;
    End;

    Function fn_get_desk_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_office         Varchar2,
        p_area_id        Varchar2,
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          ddm.floor,
                                          ddm.wing,
                                          ddm.work_area,
                                          ddm.deskid,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  ddm.deskid
                                          )      row_number,
                                          Count(*)
                                          Over() total_row
                                        From
                                          dms.dm_deskmaster ddm,
                                          dms.dm_desk_areas dda
                                       Where
        Open c For Select *
                     From (
                       Select e.empno,
                              e.name                              As name,
                              Row_Number() Over(Order By e.empno) row_number,
                              Count(*) Over()                     total_row
                         From dms.dm_area_type_user_mapping datum,
                              vu_emplmast                   e
                        Where e.empno = datum.empno
                          And e.assign = Trim(p_costcode)
                          And datum.area_id = Trim(p_area_id)
                          And datum.office_code = Trim(p_office)
                          And datum.from_date <= p_date
                          And (upper(e.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                           Or upper(e.name) Like '%' || upper(Trim(p_generic_search)) || '%')
                   )
                    Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
                       ) + 1 ) And ( nvl(
                           p_row_number,
                           0
                       ) + p_page_length );
                                          ) Like '%' || upper(
                                              Trim(p_generic_search)
                                          ) || '%'
                                              Or upper(
                                              ddm.deskid
                                          ) Like '%' || upper(
                                              Trim(p_generic_search)
                                          ) || '%' )
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
    End fn_get_desk_list;

    Function fn_get_dept_emp_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_office         Varchar2,
        Open c For Select *
                     From (
                       Select empno,
                              name,
                              deskid,
                              office,
                              start_time,
                              end_time,
                              Row_Number() Over(Order By empno) row_number,
                              Count(*) Over()                   total_row
                         From (
                                  Select e.empno,
                                         e.name As name,
                                         ddb.deskid,
                                         ddb.office,
                                         ddb.start_time,
                                         ddb.end_time
                                    From db_desk_bookings  ddb,
                                         dms.dm_deskmaster ddm,
                                         vu_emplmast       e,
                                         dms.dm_desk_areas dda
                                   Where dda.area_catg_code = 'A005'
                                     And dda.area_key_id = ddm.work_area
                                     And ddm.deskid = ddb.deskid
                                     And e.empno = ddb.empno
                                     And Trim(ddm.office) = ddb.office
                                     And e.assign = Trim(p_costcode)
                                     And ddm.work_area = Trim(p_area_id)
                                     And Trim(ddm.office) = Trim(p_office)
                                     And ddb.attendance_date = p_date
                                     And (upper(e.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                                      Or upper(e.name) Like '%' || upper(Trim(p_generic_search)) || '%')
                                  Union All
                                  Select e.empno,
                                         e.name As name,
                                         Null   As deskid,
                                         Null   As office,
                                         Null   As start_time,
                                         Null   As end_time
                                    From dms.dm_area_type_user_mapping datum,
                                         vu_emplmast                   e,
                                         dms.dm_desk_areas             dda
                                   Where dda.area_catg_code = 'A005'
                                     And dda.area_key_id = datum.area_id
                                     And e.empno = datum.empno
                                     And e.assign = Trim(p_costcode)
                                     And datum.area_id = Trim(p_area_id)
                                     And datum.office_code = Trim(p_office)
                                     And datum.from_date <= p_date
                                     And datum.empno Not In (
                                             Select ddb.empno
                                               From db_desk_bookings ddb
                                              Where ddb.office = Trim(p_office)
                                                And ddb.attendance_date = p_date
                                         )
                                     And (upper(e.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                                      Or upper(e.name) Like '%' || upper(Trim(p_generic_search)) || '%')
                              )
                   )
                    Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
                                *
                              From
                                (
                                    Select
                                        empno,
                                        name,
                                        deskid,
                                        office,
                                        start_time,
                                        end_time,
                                        Row_Number()
                                        Over(
                                             Order By
                                                empno
                                        )      row_number,
                                        Count(*)
                                        Over() total_row
                                      From
                                        (
                                            Select
                                                e.empno,
                                                e.name As name,
                                                ddb.deskid,
                                                ddb.office,
                                                ddb.start_time,
                                                ddb.end_time
                                              From
                                                db_desk_bookings  ddb,
                                                dms.dm_deskmaster ddm,
                                                vu_emplmast       e,
                                                dms.dm_desk_areas dda
            Open p_summary_list For Select office,
                       work_area As area,
                       area_desc,
                       fn_get_desk_count(
                           p_person_id => p_person_id,
                           p_meta_id   => p_meta_id,
                           p_office    => p_office,
                           p_area_id   => work_area
                       )         desk_count,
                       assign,
                       dept_emp_count,
                       fn_get_booked_desk_count(
                           p_person_id => p_person_id,
                           p_meta_id   => p_meta_id,
                           p_office    => p_office,
                           p_date      => p_date,
                           p_area_id   => work_area,
                           p_costcode  => assign
                       )         booked_desks
                                      From (
                           With datum As (
                                   Select Count(e.empno) dept_emp_count,
                                          e.assign,
                                          datum1.area_id
                                     From dms.dm_area_type_user_mapping datum1,
                                          vu_emplmast                   e
                                    Where e.empno = datum1.empno
                                      And datum1.from_date <= p_date
                                    Group By e.assign,
                                          datum1.area_id
                               )
                           Select Distinct
                                  ddm.office,
                                  ddm.work_area,
                                  dda.area_desc,
                                  datum.assign,
                                  datum.dept_emp_count
                             From dms.dm_deskmaster ddm,
                                  dms.dm_desk_areas dda,
                                  datum
                            Where dda.area_catg_code = 'A005'
                              And Trim(ddm.office) = Trim(p_office)
                              And dda.area_key_id = ddm.work_area
                              And ddm.work_area Is Not Null
                              And ddm.work_area = datum.area_id (+)
                       );
                                                    Or upper(
            Open p_desk_list For Select ddm.office,
                       ddm.floor,
                       ddm.wing,
                       ddm.work_area As area,
                       dda.area_desc,
                       ddm.deskid    As desk
                                   From dms.dm_deskmaster ddm,
                       dms.dm_desk_areas                  dda
                                  Where dda.area_catg_code = 'A005'
                                    And dda.area_key_id = ddm.work_area
                                    And Trim(ddm.office) = Trim(p_office);
                                                    Trim(p_generic_search)
                                                ) || '%'
                                                    Or upper(
                                                    e.name
                                                ) Like '%' || upper(
                                                    Trim(p_generic_search)
                                                ) || '%' )
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
            Open p_booked_emp_list For Select p_office As office,
                       e.assign                        As dept,
                       e.empno,
                       e.empno || ' - ' || e.name      name,
                       ddm.work_area                   As area,
                       dda.area_desc,
                       ddb.deskid                      As desk,
                       ddb.start_time,
                       ddb.end_time
                                         From db_desk_bookings ddb,
                       dms.dm_deskmaster                       ddm,
                       vu_emplmast                             e,
                       dms.dm_desk_areas                       dda
                                        Where dda.area_catg_code = 'A005'
                                          And dda.area_key_id = ddm.work_area
                                          And ddm.deskid = ddb.deskid
                                          And dda.area_key_id = ddm.work_area
                                          And e.empno = ddb.empno
                                          And Trim(ddm.office) = ddb.office
                                          And Trim(ddm.office) = Trim (p_office)
                                          And ddb.attendance_date = p_date
                Union All
                Select p_office                   As office,
                       e.assign                   As dept,
                       e.empno,
                       e.empno || ' - ' || e.name name,
                       datum.area_id,
                       dda.area_desc,
                       Null                       As deskid,
                       Null                       As start_time,
                       Null                       As end_time
                  From dms.dm_area_type_user_mapping datum,
                       vu_emplmast                   e,
                       dms.dm_desk_areas             dda
                                        Where dda.area_catg_code = 'A005'
                                          And dda.area_key_id = datum.area_id
                                          And e.empno = datum.empno
                                          And datum.office_code = Trim(p_office)
                                          And datum.from_date <= p_date
                                          And datum.empno Not In (
                           Select ddb.empno
                             From db_desk_bookings ddb
                            Where ddb.office = Trim(p_office)
                              And ddb.attendance_date = p_date
                       );
                                                datum.assign,
            Open p_summary_list For Select office,
                       work_area As area,
                       area_desc,
                       fn_get_desk_count(
                           p_person_id => p_person_id,
                           p_meta_id   => p_meta_id,
                           p_office    => p_office,
                           p_area_id   => work_area
                       )         desk_count,
                       assign,
                       dept_emp_count,
                       fn_get_booked_desk_count(
                           p_person_id => p_person_id,
                           p_meta_id   => p_meta_id,
                           p_office    => p_office,
                           p_date      => p_date,
                           p_area_id   => work_area,
                           p_costcode  => assign
                       )         booked_desks
                                      From (
                           With datum As (
                                   Select Count(e.empno) dept_emp_count,
                                          e.assign,
                                          datum1.area_id
                                     From dms.dm_area_type_user_mapping datum1,
                                          vu_emplmast                   e
                                    Where e.empno = datum1.empno
                                      And datum1.from_date <= p_date
                                    Group By e.assign,
                                          datum1.area_id
                               )
                           Select Distinct
                                  ddm.office,
                                  ddm.work_area,
                                  dda.area_desc,
                                  datum.assign,
                                  datum.dept_emp_count
                             From dms.dm_deskmaster ddm,
                                  dms.dm_desk_areas dda,
                                  datum
                            Where dda.area_catg_code = 'A005'
                              And Trim(ddm.office) = Trim(p_office)
                              And dda.area_key_id = ddm.work_area
                              And ddm.work_area Is Not Null
                              And datum.assign In (
                                      Select costcode
                                        From vu_costmast
                                       Where hod = Trim(v_empno)
                                      Union All
                                      Select costcode
                                        From vu_module_user_role_actions
                                       Where empno = Trim(v_empno)
                                  )
                              And ddm.work_area = datum.area_id (+)
                       );
                                                                                                                        ,
            Open p_desk_list For Select ddm.office,
                       ddm.floor,
                       ddm.wing,
                       ddm.work_area As area,
                       dda.area_desc,
                       ddm.deskid    As desk
                                   From dms.dm_deskmaster ddm,
                       dms.dm_desk_areas                  dda
                                  Where dda.area_catg_code = 'A005'
                                    And dda.area_key_id = ddm.work_area
                                    And Trim(ddm.office) = Trim(p_office);
                                                                Select
                                                                    p_office                   As office,
                                                                    e.assign                   As dept,
                                                                    e.empno,
                                                                    e.empno || ' - ' || e.name name,
                                                                    datum.area_id,
                                                                    dda.area_desc,
                                                                    Null                       As deskid,
                                                                    Null                       As start_time,
                                                                    Null                       As end_time
                                                                  From
                                                                    dms.dm_area_type_user_mapping datum,
                                                                    vu_emplmast                   e,
                                                                    dms.dm_desk_areas             dda
                                       Where
                                              dda.area_catg_code = 'A005'
                                             And dda.area_key_id   = datum.area_id
            Open p_booked_emp_list For Select p_office As office,
                       e.assign                        As dept,
                       e.empno,
                       e.empno || ' - ' || e.name      name,
                       ddm.work_area                   As area,
                       dda.area_desc,
                       ddb.deskid                      As desk,
                       ddb.start_time,
                       ddb.end_time
                                         From db_desk_bookings ddb,
                       dms.dm_deskmaster                       ddm,
                       vu_emplmast                             e,
                       dms.dm_desk_areas                       dda
                                        Where dda.area_catg_code = 'A005'
                                          And dda.area_key_id = ddm.work_area
                                          And ddm.deskid = ddb.deskid
                                          And dda.area_key_id = ddm.work_area
                                          And e.empno = ddb.empno
                                          And Trim(ddm.office) = ddb.office
                                          And Trim(ddm.office) = Trim (p_office)
                                          And e.assign In (
                           Select costcode
                             From vu_costmast
                            Where hod = Trim(v_empno)
                           Union All
                           Select costcode
                             From vu_module_user_role_actions
                            Where empno = Trim(v_empno)
                       )
                                          And ddb.attendance_date = p_date
                Union All
                Select p_office                   As office,
                       e.assign                   As dept,
                       e.empno,
                       e.empno || ' - ' || e.name name,
                       datum.area_id              As area,
                       dda.area_desc,
                       Null                       As desk,
                       Null                       As start_time,
                       Null                       As end_time
                  From dms.dm_area_type_user_mapping datum,
                       vu_emplmast                   e,
                       dms.dm_desk_areas             dda
                                        Where dda.area_catg_code = 'A005'
                                          And dda.area_key_id = datum.area_id
                                          And e.empno = datum.empno
                                          And datum.office_code = Trim(p_office)
                                          And e.assign In (
                           Select costcode
                             From vu_costmast
                            Where hod = Trim(v_empno)
                           Union All
                           Select costcode
                             From vu_module_user_role_actions
                            Where empno = Trim(v_empno)
                       )
                                          And datum.from_date <= p_date
                                          And datum.empno Not In (
                           Select ddb.empno
                             From db_desk_bookings ddb
                            Where ddb.office = Trim(p_office)
                              And ddb.attendance_date = p_date
                       );
                                                        ddm.floor,
                                                        ddm.wing,
                                                        ddm.work_area As area,
                                                        dda.area_desc,
                                                        ddm.deskid    As desk
                                                      From
                                                        dms.dm_deskmaster ddm,
                                                        dms.dm_desk_areas dda
                                 Where
                                        dda.area_catg_code = 'A005'
                                       And dda.area_key_id  = ddm.work_area
                                       And Trim(ddm.office) = Trim(p_office);
                                                   And ddm.work_area    = datum.area_id (+)
                                        );

            Open p_desk_list For Select
                                                        ddm.office,
                                                        ddm.floor,
                                                        ddm.wing,
                                                        ddm.work_area As area,
                                                        dda.area_desc,
                                                        ddm.deskid    As desk
                                                      From
                                                        dms.dm_deskmaster ddm,
                                                        dms.dm_desk_areas dda
                                 Where
                                        dda.area_catg_code = 'A005'
                                       And dda.area_key_id  = ddm.work_area
                                       And Trim(ddm.office) = Trim(p_office);
            Open p_booked_emp_list For Select
                                                                                                                        p_office                   As
                                                                                                                        office
                                                                                                                        ,
                                                                                                                        e.assign                   As
                                                                                                                        dept,
                                                                                                                        e.empno
                                                                                                                        ,
                                                                                                                        e.empno
                                                                                                                        || ' - '
                                                                                                                        || e.name name
            Open p_booked_emp_list For Select p_office As office,
                       p_costcode                      As dept,
                       e.empno,
                       e.empno || ' - ' || e.name      name,
                       ddm.work_area                   As area,
                       dda.area_desc,
                       ddb.deskid                      As desk,
                       ddb.start_time,
                       ddb.end_time
                                         From db_desk_bookings ddb,
                       dms.dm_deskmaster                       ddm,
                       vu_emplmast                             e,
                       dms.dm_desk_areas                       dda
                                        Where dda.area_catg_code = 'A005'
                                          And dda.area_key_id = ddm.work_area
                                          And ddm.deskid = ddb.deskid
                                          And dda.area_key_id = ddm.work_area
                                          And e.empno = ddb.empno
                                          And Trim(ddm.office) = ddb.office
                                          And Trim(ddm.office) = Trim (p_office)
                                          And e.assign = Trim (p_costcode)
                                          And dda.area_key_id = Trim (p_area_id)
                                          And ddb.attendance_date = p_date
                Union All
                Select p_office                   As office,
                       p_costcode                 As dept,
                       e.empno,
                       e.empno || ' - ' || e.name name,
                       datum.area_id              As area,
                       dda.area_desc,
                       Null                       As desk,
                       Null                       As start_time,
                       Null                       As end_time
                  From dms.dm_area_type_user_mapping datum,
                       vu_emplmast                   e,
                       dms.dm_desk_areas             dda
                                        Where dda.area_catg_code = 'A005'
                                          And dda.area_key_id = datum.area_id
                                          And e.empno = datum.empno
                                          And datum.office_code = Trim(p_office)
                                          And e.assign = Trim(p_costcode)
                                          And dda.area_key_id = Trim(p_area_id)
                                          And datum.from_date <= p_date
                                          And datum.empno Not In (
                           Select ddb.empno
                             From db_desk_bookings ddb
                            Where ddb.office = Trim(p_office)
                              And ddb.attendance_date = p_date
                       );
                                              dda.area_catg_code = 'A005'
                                             And dda.area_key_id   = datum.area_id
                                             And e.empno           = datum.empno
                                             And datum.office_code = Trim(p_office)
                                             And e.assign In (
                                              Select
                                                  costcode
                                                From
                                                  vu_costmast
                                               Where

    Function fn_booking_summary_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_office         Varchar2,
        p_date           Date,
        p_action_id      Varchar2,
        p_generic_search Varchar2 Default Null,
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
        If p_office Is Null Or p_date Is Null Or p_action_id Is Null Then
            Return Null;
        End If;
        If p_action_id = 'A223' Then
            Open c For Select *
                         From (
                           Select office,
                                  work_area,
                                  area_desc,
                                  fn_get_desk_count(
                                      p_person_id => p_person_id,
                                      p_meta_id   => p_meta_id,
                                      p_office    => p_office,
                                      p_area_id   => work_area
                                  )                                     desk_count,
                                  fn_get_booked_desk_count(
                                      p_person_id => p_person_id,
                                      p_meta_id   => p_meta_id,
                                      p_office    => p_office,
                                      p_date      => p_date,
                                      p_area_id   => work_area,
                                      p_costcode  => null
                                  )                                     booked_desks,
                                  Row_Number() Over(Order By area_desc) row_number,
                                  Count(*) Over()                       total_row
                             From (
                                      Select Distinct
                                             ddm.office,
                                             ddm.work_area,
                                             dda.area_desc
                                        From dms.dm_deskmaster ddm,
                                             dms.dm_desk_areas dda
                                       Where dda.area_catg_code = 'A005'
                                         And dda.area_key_id = ddm.work_area
                                         And Trim(ddm.office) = Trim(p_office)
                                         And ddm.work_area Is Not Null
                                        
                                         And (upper(dda.area_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                                          )
                                  )
                       )
                        Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        End If;
        Return c;
    End fn_booking_summary_list;
                                              Select
                                                  costcode
                                                From
                                                  vu_module_user_role_actions
                                               Where
                                                  empno = Trim(v_empno)
                                          )
                                             And datum.from_date <= p_date
                                             And datum.empno Not In (
                                              Select
                                                  ddb.empno
                                                From
                                                  db_desk_bookings ddb
                                               Where
                                                      ddb.office = Trim(p_office)
                                                     And ddb.attendance_date = p_date
                                          );
                                              Select
                                                  costcode
                                                From
                                                  vu_module_user_role_actions
                                               Where
                                                  empno = Trim(v_empno)
                                          )
                                             And datum.from_date <= p_date
                                             And datum.empno Not In (
                                              Select
                                                  ddb.empno
                                                From
                                                  db_desk_bookings ddb
                                               Where
                                                      ddb.office = Trim(p_office)
                                                     And ddb.attendance_date = p_date
                                          );
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_summary_booking_dept_xl(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_office              Varchar2,
        p_date                Date,
        p_costcode            Varchar2,
        p_area_id             Varchar2,
        p_action_id           Varchar2,
        p_booked_emp_list Out Sys_Refcursor,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) Is
        v_empno Varchar2(5);
            Open p_booked_emp_list For Select
                                                                                                                            p_office                   As
                                                                                                                            office
                                                                                                                            ,
                                                                                                                            p_costcode                 As
                                                                                                                            dept
                                                                                                                            ,
                                                                                                                            e.empno
                                                                                                                            ,
                                                                                                                            e.empno
                                                                                                                            |
                                                                                                                            |
                                                                                                                            ' - '
                                                                                                                            |
                                                                                                                            |
                                                                                                                            e.name name
                                                                                                                            ,
                                                                                                                            ddm.work_area              As
                                                                                                                            area
                                                                                                                            ,
                                                                                                                            dda.area_desc
                                                                                                                            ,
                                                                                                                            ddb.deskid                 As
                                                                                                                            desk
                                                                                                                            ,
                                                                                                                            ddb.start_time
                                                                                                                            ,
                                                                                                                            ddb.end_time
                                                                                                                          From
                                                                                                                            db_desk_bookings  ddb
                                                                                                                            ,
                                                                                                                            dms.dm_deskmaster ddm
                                                                                                                            ,
                                                                                                                            vu_emplmast       e
                                                                                                                            ,
                                                                                                                            dms.dm_desk_areas dda
                                                                                              Where
                                                                                                     dda.area_catg_code = 'A005'
                                                                                                    And dda.area_key_id     = ddm.work_area
                                                                                                    And ddm.deskid          = ddb.deskid
                                                                                                    And dda.area_key_id     = ddm.work_area
                                                                                                    And e.empno             = ddb.empno
                                                                                                    And Trim(ddm.office)    = ddb.office
                                                                                                    And Trim(ddm.office)    = Trim
                                                                                                    (p_office)
                                                                                                    And e.assign            = Trim
                                                                                                    (p_costcode)
                                                                                                    And dda.area_key_id     = Trim
                                                                                                    (p_area_id)
                                                                                                    And ddb.attendance_date = p_date
                                                                  Union All
                                                                  Select
                                                                      p_office                   As office,
                                                                      p_costcode                 As dept,
                                                                      e.empno,
                                                                      e.empno || ' - ' || e.name name,
                                                                      datum.area_id              As area,
                                                                      dda.area_desc,
                                                                      Null                       As desk,
                                                                      Null                       As start_time,
                                                                      Null                       As end_time
                                                                    From
                                                                      dms.dm_area_type_user_mapping datum,
                                                                      vu_emplmast                   e,
                                                                      dms.dm_desk_areas             dda
                                        Where
                                               dda.area_catg_code = 'A005'
                                              And dda.area_key_id   = datum.area_id
                                              And e.empno           = datum.empno
                                              And datum.office_code = Trim(p_office)
                                              And e.assign          = Trim(p_costcode)
                                              And dda.area_key_id   = Trim(p_area_id)
                                              And datum.from_date <= p_date
                                              And datum.empno Not In (
                                               Select
                                                   ddb.empno
                                                 From
                                                   db_desk_bookings ddb
                                                Where
                                                       ddb.office = Trim(p_office)
                                                      And ddb.attendance_date = p_date
                                           );
                                        Where
                                               dda.area_catg_code = 'A005'
                                              And dda.area_key_id   = datum.area_id
                                              And e.empno           = datum.empno
                                              And datum.office_code = Trim(p_office)
                                              And e.assign          = Trim(p_costcode)
                                              And dda.area_key_id   = Trim(p_area_id)
                                              And datum.from_date <= p_date
                                              And datum.empno Not In (
                                               Select
 

                                                   db_desk_bookings ddb
                                                Where
                                                       ddb.office = Trim(p_office)
                                                      And ddb.attendance_date = p_date
                                           );

        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;
 

End pkg_db_summary_booking_qry;
/