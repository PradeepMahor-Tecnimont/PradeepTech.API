Create Or Replace Package Body "TCMPL_APP_CONFIG"."PKG_USER_ACCESS_QRY" As

    Function fn_module_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          a.module_id                                                          As module_id,
                                          a.module_name                                                        As module_name,
                                          a.module_long_desc                                                   As module_long_desc,
                                          a.module_is_active                                                   As module_is_active,
                                          a.module_schema_name                                                 As module_schema_name,
                                          a.func_to_check_user_access                                          As func_to_check_user_access
                                          ,
                                          a.module_short_desc                                                  As module_short_desc,
                                          pkg_user_access_qry.func_is_delete_allowed('MODULE_ID', a.module_id) As delete_allowed,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  module_id Desc
                                          )                                                                    row_number,
                                          Count(*)
                                          Over()                                                               total_row
                                        From
                                          sec_modules a
                                       Where
                                          ( upper(a.module_id) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(a.module_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(a.module_is_active) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(a.module_schema_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(a.module_short_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(a.module_long_desc) Like '%' || upper(Trim(p_generic_search)) || '%' )
                                  )
                    Where
                       row_number Between ( nvl(p_row_number, 0) + 1 ) And ( nvl(p_row_number, 0) + p_page_length );

        Return c;
    End;

    Function fn_role_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_module_id      Varchar2 Default Null,
        p_role_id        Varchar2 Default Null,
        p_action_id      Varchar2 Default Null,
        p_empno          Varchar2 Default Null,
        p_flag_id   Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          a.role_id                                                        As role_id,
                                          a.role_name                                                      As role_name,
                                          a.role_desc                                                      As role_desc,
                                          a.role_is_active                                                 As role_is_active,
                                          b.flag                                                           As role_flag,
                                          pkg_user_access_qry.func_is_delete_allowed('ROLE_ID', a.role_id) As delete_allowed,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.role_id Desc
                                          )                                                                row_number,
                                          Count(*)
                                          Over()                                                           total_row
                                        From
                                          sec_roles a ,
                                          sec_role_flag_master b
                                       Where

                                              a.ROLE_FLAG = b.Key_id
                                              and a.role_id = nvl(p_role_id, a.role_id)
                                             And ( upper(a.role_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(a.role_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(a.role_is_active) Like '%' || upper(Trim(p_generic_search)) || '%' )
                                  )
                    Where
                       row_number Between ( nvl(p_row_number, 0) + 1 ) And ( nvl(p_row_number, 0) + p_page_length );

        Return c;
    End fn_role_list;

    Function fn_action_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_action_id      Varchar2 Default Null,
        p_empno          Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          am.action_id                                                          As action_id,
                                          am.action_name                                                        As action_name,
                                          am.action_desc                                                        As action_desc,
                                          pkg_user_access_qry.func_is_delete_allowed('ACTION_ID', am.action_id) As delete_allowed,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  am.action_id Desc
                                          )                                                                     row_number,
                                          Count(*)
                                          Over()                                                                total_row
                                        From
                                          sec_actions_master am
                                       Where
                                              am.action_id = nvl(p_action_id, am.action_id)
                                             And ( upper(am.action_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(am.action_id) Like '%' || upper(Trim(p_generic_search)) )
                                  )
                    Where
                       row_number Between ( nvl(p_row_number, 0) + 1 ) And ( nvl(p_row_number, 0) + p_page_length );

        Return c;
    End;

    Function fn_module_action_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_module_id      Varchar2 Default Null,
        p_action_id      Varchar2 Default Null,
        p_empno          Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          a.module_id                           As module_id,
                                          a.action_id                           As action_id,
                                          am.action_name                        As action_name,
                                          am.action_desc                        As action_desc,
                                          a.module_id || ' : ' || b.module_name As module_name,
                                          b.module_long_desc                    As module_long_desc,
                                          a.action_is_active                    As action_is_active,
                                          a.module_action_key_id                As module_action_key_id,
                                          (
                                              Select
                                                  Case Count(*)
                                                      When 0 Then
                                                          0
                                                      Else
                                                          1
                                                  End As count
                                                From
                                                  sec_module_role_actions
                                               Where
                                                      action_id = a.action_id
                                                     And module_id = a.module_id
                                          )                                     As delete_allowed,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.module_id
                                          )                                     row_number,
                                          Count(*)
                                          Over()                                total_row
                                        From
                                          sec_actions        a,
                                          sec_actions_master am,
                                          sec_modules        b
                                       Where
                                              a.module_id = b.module_id
                                             And a.action_id = am.action_id
                                             And a.action_id = nvl(p_action_id, a.action_id)
                                             And a.module_id = nvl(p_module_id, a.module_id)
                                             And ( upper(am.action_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(b.module_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(am.action_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(a.action_is_active) Like '%' || upper(Trim(p_generic_search)) || '%' )
                                  )
                    Where
                       row_number Between ( nvl(p_row_number, 0) + 1 ) And ( nvl(p_row_number, 0) + p_page_length );

        Return c;
    End;

    Function fn_module_role_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_module_id      Varchar2 Default Null,
        p_role_id        Varchar2 Default Null,
        p_action_id      Varchar2 Default Null,
        p_empno          Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          a.module_id          As module_id,
                                          b.module_name        As module_name,
                                          b.module_long_desc   As module_long_desc,
                                          a.role_id            As role_id,
                                          c.role_name          As role_name,
                                          c.role_desc          As role_desc,
                                          a.module_role_key_id As module_role_key_id,
                                          (
                                              Select
                                                  Case Count(*)
                                                      When 0 Then
                                                          0
                                                      Else
                                                          1
                                                  End As count
                                                From
                                                  sec_module_role_actions
                                               Where
                                                  module_role_key_id = a.module_role_key_id
                                          )                    As delete_allowed,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.module_id
                                          )                    row_number,
                                          Count(*)
                                          Over()               total_row
                                        From
                                          sec_module_roles a,
                                          sec_modules      b,
                                          sec_roles        c
                                       Where
                                              a.module_id = b.module_id
                                             And a.role_id   = c.role_id
                                             And a.role_id   = nvl(p_role_id, a.role_id)
                                             And a.module_id = nvl(p_module_id, a.module_id)
                                             And ( upper(b.module_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(c.role_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(c.role_id) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(a.module_role_key_id) Like '%' || upper(Trim(p_generic_search)) || '%' )
                                  )
                    Where
                       row_number Between ( nvl(p_row_number, 0) + 1 ) And ( nvl(p_row_number, 0) + p_page_length );

        Return c;
    End;

    Function fn_module_role_action_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_module_id      Varchar2 Default Null,
        p_role_id        Varchar2 Default Null,
        p_action_id      Varchar2 Default Null,
        p_empno          Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          a.module_id || ' : ' || b.module_name || ' - ' || b.module_long_desc As module,
                                          a.role_id || ' : ' || c.role_name || ' - ' || c.role_desc            As role,
                                          a.action_id || ' : ' || am.action_name || ' - ' || am.action_desc    As action,
                                          a.module_role_action_key_id                                          As module_role_action_key_id
                                          ,
                                          a.module_role_key_id                                                 As module_role_key_id,
                                          (
                                              Select
                                                  Case Count(*)
                                                      When 0 Then
                                                          0
                                                      Else
                                                          1
                                                  End As count
                                                From
                                                  sec_module_user_roles
                                               Where
                                                      module_id = a.module_id
                                                     And role_id = a.role_id
                                          )                                                                    As delete_allowed,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.module_id, a.role_id, a.action_id
                                          )                                                                    row_number,
                                          Count(*)
                                          Over()                                                               total_row
                                        From
                                          sec_module_role_actions a,
                                          sec_modules             b,
                                          sec_roles               c,
                                          sec_actions             d,
                                          sec_actions_master      am
                                       Where
                                              a.module_id = b.module_id
                                             And a.role_id   = c.role_id
                                             And d.action_id = am.action_id
                                             And ( a.action_id = d.action_id
                                             And a.module_id = d.module_id )
                                             And a.action_id = nvl(p_action_id, d.action_id)
                                             And a.role_id   = nvl(p_role_id, c.role_id)
                                             And a.module_id = nvl(p_module_id, b.module_id)
                                             And ( upper(b.module_long_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(a.module_role_action_key_id) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(c.role_id) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(am.action_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(c.role_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(am.action_id) Like '%' || upper(Trim(p_generic_search)) || '%' )
                                  )
                    Where
                       row_number Between ( nvl(p_row_number, 0) + 1 ) And ( nvl(p_row_number, 0) + p_page_length );

        Return c;
    End;

    Function fn_module_user_role_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_module_id      Varchar2 Default Null,
        p_role_id        Varchar2 Default Null,
        p_action_id      Varchar2 Default Null,
        p_empno          Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          a.module_id || ' : ' || b.module_name || ' - ' || b.module_long_desc As module,
                                          a.role_id || ' : ' || c.role_name || ' - ' || c.role_desc            As role,
                                          a.empno || ' : ' || d.name                                           As employee,
                                          a.empno                                                              As empno,
                                          a.module_id                                                          As module_id,
                                          a.role_id                                                            As role_id,
                                          a.person_id                                                          As person_id,
                                          a.module_role_key_id                                                 As module_role_key_id,
                                          0                                                                    As delete_allowed,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.module_id, a.role_id, a.empno
                                          )                                                                    row_number,
                                          Count(*)
                                          Over()                                                               total_row
                                        From
                                          sec_module_user_roles a,
                                          sec_modules           b,
                                          sec_roles             c,
                                          vu_emplmast           d
                                       Where
                                              a.module_id = b.module_id
                                             And a.role_id   = c.role_id
                                             And a.empno     = d.empno
                                             And a.module_id = nvl(p_module_id, a.module_id)
                                             And a.role_id   = nvl(p_role_id, a.role_id)
                                             And a.empno     = nvl(p_empno, a.empno)
                                             And ( upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(d.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(b.module_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(b.module_long_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(c.role_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(c.role_id) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(c.role_desc) Like '%' || upper(Trim(p_generic_search)) || '%' )
                                  )
                    Where
                       row_number Between ( nvl(p_row_number, 0) + 1 ) And ( nvl(p_row_number, 0) + p_page_length );

        Return c;
    End;

    Function fn_module_user_role_actions (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_module_id      Varchar2 Default Null,
        p_role_id        Varchar2 Default Null,
        p_action_id      Varchar2 Default Null,
        p_empno          Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          a.empno || ' : ' || d.name                                           As employee,
                                          a.module_id || ' : ' || b.module_name || ' - ' || b.module_long_desc As module,
                                          a.role_id || ' : ' || c.role_name || ' - ' || c.role_desc            As role,
                                          a.action_id || ' : ' || am.action_name || ' - ' || am.action_desc    As action,
                                          1                                                                    As delete_allowed,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.module_id, a.role_id, a.action_id, a.empno
                                          )                                                                    row_number,
                                          Count(*)
                                          Over()                                                               total_row
                                        From
                                          sec_module_users_roles_actions a,
                                          sec_modules                    b,
                                          sec_roles                      c,
                                          vu_emplmast                    d,
                                          sec_actions                    e,
                                          sec_actions_master             am
                                       Where
                                              a.module_id = b.module_id
                                             And a.role_id   = c.role_id
                                             And a.empno     = d.empno
                                             And a.action_id = e.action_id
                                             And e.action_id = am.action_id
                                             And a.action_id = nvl(p_action_id, a.action_id)
                                             And a.role_id   = nvl(p_role_id, a.role_id)
                                             And a.module_id = nvl(p_module_id, a.module_id)
                                             And a.empno     = nvl(p_empno, a.empno)
                                             And ( upper(b.module_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(c.role_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(d.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(d.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(am.action_name) Like '%' || upper(Trim(p_generic_search)) || '%' )
                                  )
                    Where
                       row_number Between ( nvl(p_row_number, 0) + 1 ) And ( nvl(p_row_number, 0) + p_page_length );

        Return c;
    End;

    Function fn_vu_module_user_role_actions (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_module_id      Varchar2 Default Null,
        p_role_id        Varchar2 Default Null,
        p_action_id      Varchar2 Default Null,
        p_empno          Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          a.empno || ' : ' || d.name             As employee,
                                          a.module_id || ' : ' || b.module_name  As module,
                                          a.role_id || ' : ' || c.role_name      As role,
                                          a.action_id || ' : ' || am.action_name As action,
                                          b.module_long_desc                     As module_desc,
                                          am.action_desc                         As action_desc,
                                          c.role_desc                            As role_desc,
                                          a.person_id,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.module_id, a.role_id, a.action_id, a.empno
                                          )                                      row_number,
                                          Count(*)
                                          Over()                                 total_row
                                        From
                                          vu_module_user_role_actions a,
                                          sec_modules                 b,
                                          sec_roles                   c,
                                          vu_emplmast                 d,
                                          sec_actions                 e,
                                          sec_actions_master          am
                                       Where
                                              a.module_id = b.module_id
                                             And a.role_id   = c.role_id
                                             And a.empno     = d.empno
                                             And a.action_id = e.action_id
                                             And e.action_id = am.action_id
                                             And a.module_id = nvl(p_module_id, a.module_id)
                                             And a.role_id   = nvl(p_role_id, a.role_id)
                                             And a.action_id = nvl(p_action_id, a.action_id)
                                             And a.empno     = nvl(p_empno, a.empno)
                                             And ( upper(a.module_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(a.role_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%' )
                                  )
                    Where
                       row_number Between ( nvl(p_row_number, 0) + 1 ) And ( nvl(p_row_number, 0) + p_page_length );

        Return c;
    End;

    Function func_is_delete_allowed (
        p_col_name  In Varchar2,
        p_col_val   In Varchar2,
        p_module_id In Varchar2 Default Null
    ) Return Number Is

        v_count  Number := 0;
        v_return Number := 0;
        v_empno  Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        If ( p_col_name = 'MODULE_ID' ) Then
            Select
                Count(*)
              Into v_count
              From
                sec_module_roles a
             Where
                a.module_id = p_col_val;

            If ( v_count > 0 ) Then
                v_return := 1;
                Return v_return;
            End If;
            Select
                Count(*)
              Into v_count
              From
                vu_module_user_role_actions a
             Where
                a.module_id = p_col_val;

            If ( v_count > 0 ) Then
                v_return := 1;
            End If;
        End If;

        If ( p_col_name = 'ROLE_ID' ) Then
            Select
                Count(*)
              Into v_count
              From
                sec_module_roles a
             Where
                a.role_id = p_col_val;

            If ( v_count > 0 ) Then
                v_return := 1;
                Return v_return;
            End If;
            Select
                Count(*)
              Into v_count
              From
                vu_module_user_role_actions a
             Where
                a.role_id = p_col_val;

            If ( v_count > 0 ) Then
                v_return := 1;
                Return v_return;
            End If;
        End If;

        If ( p_col_name = 'ACTION_ID' ) Then
            Select
                Count(*)
              Into v_count
              From
                sec_actions a
             Where
                a.action_id = p_col_val;

            If ( v_count > 0 ) Then
                v_return := 1;
                Return v_return;
            End If;

           /*
               Select
                Count(*)
              Into v_count
              From
                sec_module_role_actions a
             Where
                    a.action_id = p_col_val
                   And module_id = p_module_id;

            If ( v_count > 0 ) Then
                v_return := 1;
                Return v_return;
            End If;

           */

            Select
                Count(*)
              Into v_count
              From
                vu_module_user_role_actions a
             Where
                a.action_id = p_col_val;

            If ( v_count > 0 ) Then
                v_return := 1;
                Return v_return;
            End If;
        End If;

        Return v_return;
    End func_is_delete_allowed;

    Function fn_module_user_role_log_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_module_id      Varchar2 Default Null,
        p_role_id        Varchar2 Default Null,
        p_action_id      Varchar2 Default Null,
        p_empno          Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          a.module_id || ' : ' || b.module_name || ' - ' || b.module_long_desc As module,
                                          a.role_id || ' : ' || c.role_name || ' - ' || c.role_desc            As role,
                                          a.empno || ' : ' || d.name                                           As employee,
                                          a.empno                                                              As empno,
                                          a.module_id                                                          As module_id,
                                          a.role_id                                                            As role_id,
                                          a.module_role_key_id                                                 As module_role_key_id,
                                          'INSERT'                                                             As status,
                                          a.modified_by || ' : ' || e.name                                     As modified_by,
                                          a.modified_on                                                        As modified_on,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.modified_on Desc
                                          )                                                                    row_number,
                                          Count(*)
                                          Over()                                                               total_row
                                        From
                                          sec_module_user_roles_log a,
                                          sec_modules               b,
                                          sec_roles                 c,
                                          vu_emplmast               d,
                                          vu_emplmast               e
                                       Where
                                              a.module_id = b.module_id
                                             And a.role_id     = c.role_id
                                             And a.empno       = d.empno
                                             And a.modified_by = e.empno
                                             And a.module_id   = nvl(p_module_id, a.module_id)
                                             And a.role_id     = nvl(p_role_id, a.role_id)
                                             And a.empno       = nvl(p_empno, a.empno)
                                             And ( upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(d.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(b.module_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(b.module_long_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(c.role_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(c.role_desc) Like '%' || upper(Trim(p_generic_search)) || '%' )
                                      Union
                                      Select
                                          a.module_id || ' : ' || b.module_name || ' - ' || b.module_long_desc As module,
                                          a.role_id || ' : ' || c.role_name || ' - ' || c.role_desc            As role,
                                          a.empno || ' : ' || d.name                                           As employee,
                                          a.empno                                                              As empno,
                                          a.module_id                                                          As module_id,
                                          a.role_id                                                            As role_id,
                                          a.module_role_key_id                                                 As module_role_key_id,
                                          'DELETE'                                                             As status,
                                          a.modified_by || ' : ' || e.name                                     As modified_by,
                                          a.modified_on                                                        As modified_on,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.modified_on Desc
                                          )                                                                    row_number,
                                          Count(*)
                                          Over()                                                               total_row
                                        From
                                          sec_module_user_roles_delete a,
                                          sec_modules                  b,
                                          sec_roles                    c,
                                          vu_emplmast                  d,
                                          vu_emplmast                  e
                                       Where
                                              a.module_id = b.module_id
                                             And a.role_id     = c.role_id
                                             And a.empno       = d.empno
                                             And a.modified_by = e.empno
                                             And a.module_id   = nvl(p_module_id, a.module_id)
                                             And a.role_id     = nvl(p_role_id, a.role_id)
                                             And a.empno       = nvl(p_empno, a.empno)
                                             And ( upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(d.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(b.module_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(b.module_long_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(c.role_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(c.role_desc) Like '%' || upper(Trim(p_generic_search)) || '%' )
                                  )
                    Where
                       row_number Between ( nvl(p_row_number, 0) + 1 ) And ( nvl(p_row_number, 0) + p_page_length )
                    Order By
                       modified_on Desc;

        Return c;
    End;

    Function fn_module_delegate_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_module_id      Varchar2 Default Null,
        p_empno          Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          a.module_id || ' : ' || b.module_name || ' - ' || b.module_long_desc As module,
                                          a.principal_empno || ' : ' || d.name                                 As principal_emp,
                                          a.on_behalf_empno || ' : ' || (
                                              Select
                                                  vem.name
                                                From
                                                  vu_emplmast vem
                                               Where
                                                  vem.empno = a.on_behalf_empno
                                          )                                                                    As on_behalf_emp,
                                          a.principal_empno                                                    As principal_empno,
                                          a.on_behalf_empno                                                    As on_behalf_empno,
                                          a.module_id                                                          As module_id,
                                          a.modified_by || ' : ' || (
                                              Select
                                                  vem.name
                                                From
                                                  vu_emplmast vem
                                               Where
                                                  vem.empno = a.modified_by
                                          )                                                                    As modified_by,
                                          a.modified_on                                                        As modified_on,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.modified_on Desc
                                          )                                                                    row_number,
                                          Count(*)
                                          Over()                                                               total_row
                                        From
                                          sec_module_delegate a,
                                          sec_modules         b,
                                          vu_emplmast         d
                                       Where
                                              a.module_id = b.module_id
                                             And a.principal_empno = d.empno
                                             And a.module_id       = nvl(p_module_id, a.module_id)
                                             And a.principal_empno = nvl(p_empno, a.principal_empno)
                                             And ( upper(a.principal_empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(d.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(b.module_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(b.module_long_desc) Like '%' || upper(Trim(p_generic_search)) || '%' )
                                  )
                    Where
                       row_number Between ( nvl(p_row_number, 0) + 1 ) And ( nvl(p_row_number, 0) + p_page_length )
                    Order By
                       modified_on Desc;

        Return c;
    End;

    Function fn_module_delegate_log_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_module_id      Varchar2 Default Null,
        p_empno          Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          a.key_id                                                             As key_id,
                                          a.log_status                                                         As log_status,
                                          a.module_id || ' : ' || b.module_name || ' - ' || b.module_long_desc As module,
                                          a.principal_empno || ' : ' || d.name                                 As principal_emp,
                                          a.on_behalf_empno || ' : ' || (
                                              Select
                                                  vem.name
                                                From
                                                  vu_emplmast vem
                                               Where
                                                  vem.empno = a.on_behalf_empno
                                          )                                                                    As on_behalf_emp,
                                          a.principal_empno                                                    As on_behalf_empno,
                                          a.on_behalf_empno                                                    As principal_empno,
                                          a.module_id                                                          As module_id,
                                          a.modified_by || ' : ' || (
                                              Select
                                                  vem.name
                                                From
                                                  vu_emplmast vem
                                               Where
                                                  vem.empno = a.modified_by
                                          )                                                                    As modified_by,
                                          a.modified_on                                                        As modified_on,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.modified_on Desc
                                          )                                                                    row_number,
                                          Count(*)
                                          Over()                                                               total_row
                                        From
                                          sec_module_delegate_log a,
                                          sec_modules             b,
                                          vu_emplmast             d
                                       Where
                                              a.module_id = b.module_id
                                             And a.principal_empno = d.empno
                                             And a.module_id       = nvl(p_module_id, a.module_id)
                                             And a.principal_empno = nvl(p_empno, a.principal_empno)
                                             And ( upper(a.principal_empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(d.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(b.module_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(b.module_long_desc) Like '%' || upper(Trim(p_generic_search)) || '%' )
                                  )
                    Where
                       row_number Between ( nvl(p_row_number, 0) + 1 ) And ( nvl(p_row_number, 0) + p_page_length )
                    Order By
                       modified_on Desc;

        Return c;
    End;

    Function fn_module_user_role_costcode (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_module_id      Varchar2 Default Null,
        p_parent         Varchar2 Default Null,
        p_empno          Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          a.empno                                                              As emp_no,
                                          a.empno || ' : ' || d.name                                           As employee,
                                          a.module_id                                                          As module_val,
                                          a.module_id || ' : ' || b.module_name || ' - ' || b.module_long_desc As module_text,
                                          a.role_id                                                            As role_val,
                                          a.role_id || ' : ' || c.role_name || ' - ' || c.role_desc            As role_text,
                                          a.costcode                                                           As parent_val,
                                          a.costcode || ' : ' || e.name                                        As parent_text,
                                          1                                                                    As delete_allowed,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.module_id, e.costcode, a.empno
                                          )                                                                    row_number,
                                          Count(*)
                                          Over()                                                               total_row
                                        From
                                          sec_module_user_roles_costcode a,
                                          sec_modules                    b,
                                          sec_roles                      c,
                                          vu_emplmast                    d,
                                          vu_costmast                    e
                                       Where
                                              a.module_id = b.module_id
                                             And a.role_id   = c.role_id
                                             And a.costcode  = e.costcode
                                             And a.empno     = d.empno
                                             And a.costcode  = nvl(p_parent, a.costcode)
                                             And a.module_id = nvl(p_module_id, a.module_id)
                                             And a.empno     = nvl(p_empno, a.empno)
                                             And ( upper(b.module_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(e.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(d.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                                              Or upper(d.name) Like '%' || upper(Trim(p_generic_search)) || '%' )
                                  )
                    Where
                       row_number Between ( nvl(p_row_number, 0) + 1 ) And ( nvl(p_row_number, 0) + p_page_length );

        Return c;
    End;
        Function fn_module_user_role_list_xl (
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        
        p_module_id Varchar2 Default Null,
        p_role_id   Varchar2 Default Null,
        p_empno     Varchar2 Default Null
    ) Return Sys_Refcursor As
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        e_invalid_date_range Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
        Pragma exception_init ( e_invalid_date_range, -20002 );
        c       Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                       *
                     From
                       ( Select
                               a.module_id || ' : ' || b.module_name || ' - ' || b.module_long_desc As module,
                               a.role_id || ' : ' || c.role_name || ' - ' || c.role_desc            As role,
                               a.empno || ' : ' || d.name                                           As employee,
                               a.empno                                                              As empno,
                               a.module_id                                                          As module_id,
                               a.role_id                                                            As role_id,
                               a.person_id                                                          As person_id,
                               a.module_role_key_id                                                 As module_role_key_id,
                               0                                                                    As delete_allowed
                             From
                               sec_module_user_roles a,
                               sec_modules           b,
                               sec_roles             c,
                               vu_emplmast           d
                          Where
                                 a.module_id = b.module_id
                                And a.role_id   = c.role_id
                                And a.empno     = d.empno
                                And a.module_id = nvl(p_module_id,a.module_id)
                                And a.role_id   = nvl(p_role_id,a.role_id)
                                And a.empno     = nvl(p_empno,a.empno)
                          Order By
                             a.module_id,
                             a.role_id,
                             a.empno
                       );

        Return c;
    End;
End;