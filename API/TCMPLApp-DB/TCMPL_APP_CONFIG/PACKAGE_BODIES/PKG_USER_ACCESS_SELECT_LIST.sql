Create Or Replace Package Body "TCMPL_APP_CONFIG"."PKG_USER_ACCESS_SELECT_LIST" As

    Function fn_modual_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_delegation_is_active Varchar2 Default Null
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For 
                Select
                    module_id                                                      As data_value_field,
                    module_id || ' : ' || module_name || ' - ' || module_long_desc As data_text_field 
                  From
                    sec_modules
                 Where
                    module_is_active = ok
                    And nvl(delegation_is_active, 0)  = nvl(p_delegation_is_active,nvl(delegation_is_active, 0))
                 Order By
                    module_id;

        Return c;
    End;

    Function fn_role_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_module_id Varchar2 Default Null,
        p_flag_id Varchar2 Default Null
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For 
                Select Distinct
                    a.role_id                                                 As data_value_field,
                    a.role_id || ' : ' || a.role_name || ' - ' || a.role_desc As data_text_field
                  From
                    sec_roles        a,
                    sec_module_roles b
                 Where
                        a.role_is_active = 'OK'
                       And a.role_id           = b.role_id (+)
                       And nvl(b.module_id, 0) = nvl(p_module_id,nvl(b.module_id, 0))
                       And nvl(a.role_flag, 0) = nvl(p_flag_id,nvl(a.role_flag, 0))
                 Order By
                    a.role_id;

        Return c;
    End;

    Function fn_action_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_module_id Varchar2 Default Null,
        p_role_id   Varchar2 Default Null
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select Distinct
                                  a.action_id                                                     As data_value_field,
                                  a.action_id || ' : ' || a.action_name || ' - ' || a.action_desc As data_text_field
                                From
                                  sec_actions_master      a,
                                  sec_module_role_actions b
                    Where
                           a.action_id = b.action_id (+)
                          And nvl(b.module_id, 0) = nvl(p_module_id,
                                                        nvl(b.module_id, 0))
                          And nvl(b.role_id, 0)   = nvl(p_role_id,
                                                      nvl(b.role_id, 0));
                                   
          
        /*
        Select
            Distinct
                a.action_id                                                     As data_value_field,
                a.action_id || ' : ' || a.action_name || ' - ' || a.action_desc As data_text_field
            From
                sec_actions_master             a, 
                sec_module_role_actions b;
                
            Select
            Distinct
                a.action_id                                                     As data_value_field,
                a.action_id || ' : ' || am.action_name || ' - ' || am.action_desc As data_text_field
            From
                sec_actions             a, 
                sec_module_role_actions b,
                sec_actions_master      am 
            Where
                a.action_is_active      = 'OK'
                And a.action_id         = am.action_id
                And a.action_id         = b.action_id(+)
                --And a.module_id    = nvl(p_module_id, a.module_id)
                --And b.role_id      = nvl(p_role_id, b.role_id)
                And nvl(a.module_id, 0) = nvl(p_module_id, nvl(a.module_id, 0))
                And nvl(b.role_id, 0)   = nvl(p_role_id, nvl(b.role_id, 0))

            Order By
                a.action_id;
*/
        Return c;
    End;

    Function fn_employee_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_module_id Varchar2 Default Null,
        p_role_id   Varchar2 Default Null
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select Distinct
                                  a.empno                    As data_value_field,
                                  a.empno || ' : ' || b.name As data_text_field
                                From
                --vu_module_user_role_actions a,
                                  sec_module_user_roles   a,
                                  selfservice.ss_emplmast b
                    Where
                           b.status = 1
                          And a.empno             = b.empno (+)
                --And a.module_id = nvl(p_module_id, a.module_id)
                --And a.role_id   = nvl(p_role_id, a.role_id)
                          And nvl(a.module_id, 0) = nvl(p_module_id,
                                                        nvl(a.module_id, 0))
                          And nvl(a.role_id, 0)   = nvl(p_role_id,
                                                      nvl(a.role_id, 0))
                    Order By
                       a.empno;

        Return c;
    End;

    Function fn_flag_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_module_id Varchar2 Default Null,
        p_flag_id   Varchar2 Default Null
    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For 
                Select
                    to_char(key_id) As data_value_field,
                    flag   As data_text_field
                  From
                    sec_role_flag_master
                 Where
                    is_active = ok
                 Order by key_id;
        Return c;
    End;

End;