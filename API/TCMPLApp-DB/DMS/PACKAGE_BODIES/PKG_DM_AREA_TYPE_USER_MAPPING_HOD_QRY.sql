Create Or Replace Package Body dms.pkg_dm_area_type_user_mapping_hod_qry As

    Function fn_areas_4_desk_user (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                Sys_Refcursor;
        v_desk_area_type Varchar2(4) := 'AT04';
    Begin
        Open c For Select
                                  area_id,
                                  area_desc,
                                  area_catg_code,
                                  area_catg_desc,
                                  area_info,
                                  desk_area_type_val,
                                  desk_area_type_text,
                                  is_restricted As is_restricted_val,
                                  Case
                                      When is_restricted = 1 Then
                                          'Yes'
                                      Else
                                          'No'
                                  End           As is_restricted_text,
                                  pkg_dms_masters_qry.fn_check_work_area_exists(
                                      p_person_id,
                                      p_meta_id,
                                      area_id
                                  )             As area_id_count,
                                  row_number,
                                  total_row
                                From
                                  (
                                      Select
                                          a.area_key_id    As area_id,
                                          a.area_desc      As area_desc,
                                          a.area_catg_code As area_catg_code,
                                          c.description    As area_catg_desc,
                                          a.area_info      As area_info,
                                          a.desk_area_type As desk_area_type_val,
                                          b.description    As desk_area_type_text,
                                          a.is_restricted  As is_restricted,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.area_key_id Desc
                                          )                row_number,
                                          Count(*)
                                          Over()           total_row
                                        From
                                          dm_desk_areas           a,
                                          dm_desk_area_categories c,
                                          dm_area_type            b
                                       Where
                                              c.area_catg_code = a.area_catg_code
                                             And a.desk_area_type = b.key_id
                                             And a.desk_area_type = v_desk_area_type
                                             And ( upper(
                                              c.description
                                          ) Like '%' || upper(
                                              Trim(p_generic_search)
                                          ) || '%'
                                              Or upper(
                                              a.area_desc
                                          ) Like '%' || upper(
                                              Trim(p_generic_search)
                                          ) )
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
    End fn_areas_4_desk_user;

    Function fn_dm_area_type_user_mapping_list (
        p_person_id            Varchar2,
        p_meta_id              Varchar2,
        p_generic_search       Varchar2 Default Null,
        p_area_id              Varchar2 Default Null,
        p_cost_code            Varchar2 Default Null,
        p_office_location_code Varchar2 Default Null,
        p_row_number           Number,
        p_page_length          Number
    ) Return Sys_Refcursor As
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
        c       Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  empno,
                                  emp_name,
                                  dept_code,
                                  dept_name,
                                  key_id,
                                  area_id,
                                  area_desc,
                                  office,
                                  office_location,
                                  office_location_code,
                                  empno,
                                  from_date,
                                  row_number,
                                  total_row
                                From
                                  (
                                      Select
                                          empno                empno,
                                          emp_name             emp_name,
                                          dept_code            dept_code,
                                          dept_name            dept_name,
                                          key_id               key_id,
                                          area_id              area_id,
                                          area_desc            area_desc,
                                          office               office,
                                          office_location      office_location,
                                          office_location_code As office_location_code,
                                          from_date            from_date,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  1
                                          )                    row_number,
                                          Count(*)
                                          Over()               total_row
                                        From
                                          (
                                              Select
                                                  ss_emplmast.empno                     As empno,
                                                  ss_emplmast.name                      As emp_name,
                                                  ss_costmast.costcode                  As dept_code,
                                                  ss_costmast.name                      As dept_name,
                                                  dm_area_type_user_mapping.key_id      As key_id,
                                                  dm_area_type_user_mapping.area_id     As area_id,
                                                  dm_desk_areas.area_desc               As area_desc,
                                                  dm_area_type_user_mapping.office_code As office,
                                                  tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                                      tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                          ss_emplmast.empno,
                                                          sysdate
                                                      )
                                                  )                                     As office_location,
                                                  tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                                      ss_emplmast.empno,
                                                      sysdate
                                                  )                                     As office_location_code,
                                                  dm_area_type_user_mapping.from_date   As from_date
                                                From
                                                       ss_emplmast
                                                   Inner Join ss_costmast
                                                  On ss_emplmast.parent = ss_costmast.costcode
                                                    Left Outer Join dm_area_type_user_mapping
                                                  On dm_area_type_user_mapping.empno = ss_emplmast.empno
                                                    Left Outer Join dm_desk_areas
                                                  On dm_desk_areas.area_key_id = dm_area_type_user_mapping.area_id
                                               Where
                                                      ss_emplmast.status = 1
                                                     And ss_emplmast.parent In (
                                                      Select
                                                          costcode
                                                        From
                                                          ss_costmast
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
                                              nvl(
                                                  area_id,
                                                  'X!X!'
                                              ) = nvl(
                                                  Trim(p_area_id),
                                                  nvl(
                                                                          area_id,
                                                                          'X!X!'
                                                                      )
                                              )
                                             And nvl(
                                              office_location_code,
                                              'X!X!'
                                          ) = nvl(
                                              Trim(p_office_location_code),
                                              nvl(
                                                                      office_location_code,
                                                                      'X!X!'
                                                                  )
                                          )
                                             And dept_code                         = nvl(
                                              Trim(p_cost_code),
                                              dept_code
                                          )
                                             And ( upper(dept_code) Like '%' || upper(
                                              Trim(p_generic_search)
                                          ) || '%'
                                              Or upper(empno) Like '%' || upper(
                                              Trim(p_generic_search)
                                          ) || '%'
                                              Or upper(emp_name) Like '%' || upper(
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
    End fn_dm_area_type_user_mapping_list;

    Procedure sp_dm_area_type_user_mapping_details (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_key_id         Varchar2,
        p_area_catg_code Out Varchar2,
        p_area_catg_desc Out Varchar2,
        p_area_id        Out Varchar2,
        p_area_desc      Out Varchar2,
        p_emp_no         Out Varchar2,
        p_emp_name       Out Varchar2,
        p_from_date      Out Date,
        p_office_code    Out Varchar2,
        p_office_desc    Out Varchar2,
        p_modified_by    Out Varchar2,
        p_modified_on    Out Date,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            dm_area_type_user_mapping
         Where
            key_id = p_key_id;

        If v_exists = 1 Then
            Select
                b.area_catg_code As area_catg_code,
                e.description    As area_catg_desc,
                a.area_id        As area_id,
                b.area_desc      As area_desc,
                a.empno          As emp_no,
                c.name           As emp_name,
                a.from_date,
                a.office_code,
                a.modified_on    As modified_on,
                a.modified_by || ' : ' || get_emp_name(
                    a.modified_by
                )                As modified_by
              Into
                p_area_catg_code,
                p_area_catg_desc,
                p_area_id,
                p_area_desc,
                p_emp_no,
                p_emp_name,
                p_from_date,
                p_office_code,
                p_modified_on,
                p_modified_by
              From
                dm_area_type_user_mapping a,
                dm_desk_areas             b,
                dm_desk_area_categories   e,
                ss_emplmast               c
             Where
                    a.key_id = p_key_id
                   And a.empno          = c.empno
                   And a.area_id        = b.area_key_id
                   And b.area_catg_code = e.area_catg_code;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching user area type mapping exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_dm_area_type_user_mapping_details;

    Function fn_dm_area_type_user_mapping_xl_list (
        p_person_id            Varchar2,
        p_meta_id              Varchar2,
        p_generic_search       Varchar2 Default Null,
        p_area_id              Varchar2 Default Null,
        p_cost_code            Varchar2 Default Null,
        p_office_location_code Varchar2 Default Null
    ) Return Sys_Refcursor As
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
        c       Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                       empno,
                       emp_name,
                       dept_code,
                       dept_name,
                       key_id,
                       area_id,
                       area_desc,
                       tag_name,
                       office,
                       office_location,
                       office_location_code,
                       empno,                   
                       from_date,
                       modified_on,
                       modified_by ||' : '|| get_emp_name(modified_by)
                     From
                       (
                           With tags As (
                               Select
                                   (
                                       Select
                                           substr(
                                               sys_connect_by_path(
                                                   tag_name,
                                                   ','
                                               ),
                                               2
                                           ) csv
                                         From
                                           (
                                               Select
                                                   ta.tag_name,
                                                   Row_Number()
                                                   Over(
                                                        Order By
                                                           ta.tag_name
                                                   )      rn,
                                                   Count(*)
                                                   Over() cnt
                                                 From
                                                   dm_tag_master      ta,
                                                   dm_tag_obj_mapping tm
                                                Where
                                                       ta.key_id = tm.tag_id
                                                      And a.area_key_id  = tm.obj_id
                                                      And tm.obj_type_id = 3
                                           )
                                        Where
                                           rn = cnt
                                       Start With
                                           rn = 1
                                       Connect By
                                           rn = Prior rn + 1
                                   ) As tag_name,
                                   a.area_key_id
                                 From
                                   dm_desk_areas a
                           )
                           Select
                               empno                empno,
                               emp_name             emp_name,
                               dept_code            dept_code,
                               dept_name            dept_name,
                               key_id               key_id,
                               area_id              area_id,
                               area_desc            area_desc,
                               tg.tag_name          As tag_name,
                               office               office,
                               office_location      office_location,
                               office_location_code As office_location_code,
                               from_date            from_date,
                               modified_on,
                               modified_by,                             
                               Row_Number()
                               Over(
                                    Order By
                                       1
                               )                    row_number,
                               Count(*)
                               Over()               total_row
                             From
                               (
                                   Select
                                       ss_emplmast.empno                     As empno,
                                       ss_emplmast.name                      As emp_name,
                                       ss_costmast.costcode                  As dept_code,
                                       ss_costmast.name                      As dept_name,
                                       dm_area_type_user_mapping.key_id      As key_id,
                                       dm_area_type_user_mapping.area_id     As area_id,
                                       dm_desk_areas.area_desc               As area_desc,
                                       dm_area_type_user_mapping.office_code As office,
                                       tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                           tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                               ss_emplmast.empno,
                                               sysdate
                                           )
                                       )                                     As office_location,
                                       tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                           ss_emplmast.empno,
                                           sysdate
                                       )                                     As office_location_code,
                                       dm_area_type_user_mapping.from_date   As from_date,
                                       dm_area_type_user_mapping.modified_on As modified_on,
                                       dm_area_type_user_mapping.modified_by As modified_by
                                     From
                                            ss_emplmast
                                        Inner Join ss_costmast
                                       On ss_emplmast.parent = ss_costmast.costcode
                                         Left Outer Join dm_area_type_user_mapping
                                       On dm_area_type_user_mapping.empno = ss_emplmast.empno
                                         Left Outer Join dm_desk_areas
                                       On dm_desk_areas.area_key_id = dm_area_type_user_mapping.area_id
                                         
                                    Where
                                           ss_emplmast.status = 1
                                          And ss_emplmast.parent In (
                                           Select
                                               costcode
                                             From
                                               ss_costmast
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
                               ),
                               tags tg
                            Where
                                   area_id = tg.area_key_id (+)
                                  And nvl(
                                   area_id,
                                   'X!X!'
                               )              = nvl(
                                   Trim(p_area_id),
                                   nvl(
                                                           area_id,
                                                           'X!X!'
                                                       )
                               )
                                  And nvl(
                                   office_location_code,
                                   'X!X!'
                               ) = nvl(
                                   Trim(p_office_location_code),
                                   nvl(
                                                           office_location_code,
                                                           'X!X!'
                                                       )
                               )
                                  And dept_code                         = nvl(
                                   Trim(p_cost_code),
                                   dept_code
                               )
                                  And ( upper(dept_code) Like '%' || upper(
                                   Trim(p_generic_search)
                               ) || '%'
                                   Or upper(empno) Like '%' || upper(
                                   Trim(p_generic_search)
                               ) || '%'
                                   Or upper(emp_name) Like '%' || upper(
                                   Trim(p_generic_search)
                               ) || '%' )
                       );
        Return c;
    End fn_dm_area_type_user_mapping_xl_list;

End pkg_dm_area_type_user_mapping_hod_qry;