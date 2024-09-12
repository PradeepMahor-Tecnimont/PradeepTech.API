Create Or Replace Package Body tcmpl_app_config.pkg_site_map As

    Procedure prc_get_key_value(
        p_link_id          Varchar2,
        p_json             Varchar2,
        p_parameter        Varchar2,
        p_is_required      Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2,
        p_value        Out Varchar2
    ) As
        jo             json_object_t := json_object_t(p_json);
        jo_keys        json_key_list := jo.get_keys();
        v_value        Varchar2(30);
        v_message_type Varchar2(2);
        v_message_text Varchar2(1000);
    Begin
        For i In 1..jo_keys.count
        Loop
            p_value := Null;
            If lower(jo_keys(i)) = lower(p_parameter) Then
                If jo.get_string(jo_keys(i)) Is Not Null Then
                    p_value := jo.get_string(jo_keys(i));
                End If;
                p_message_type := ok;
                p_message_text := ok;
                Return;
            End If;
        End Loop;

        If p_is_required = not_ok Then
            p_message_type := ok;
            p_message_text := ok;
            p_value        := Null;
        End If;

        p_message_type := not_ok;
        p_message_text := not_ok;
        p_value        := Null;
    End prc_get_key_value;

    Function fn_get_site_map(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,

        p_module_id  Varchar2,
        p_sitemap_id Varchar2
    ) Return Sys_Refcursor Is
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For

            With

                action_params As(
                    Select
                        action_fkey_id  action_id,
                        Listagg (index_formfield_name, ',') Within
                            Group (Order By
                                key_id) index_form_fields,
                        Listagg (controller_method_param_name, ',') Within
                            Group (Order By
                                key_id) controller_method_param_names
                    From
                        app_sitemap_action_formfields
                    Where
                        sitemap_fkey_id = p_sitemap_id
                    Group By
                        action_fkey_id
                )
            Select
                --sitemap_fkey_id,
                action_type_fkey_id                As action_type,
                a.key_id                           As action_id,
                parent_action_fkey_id              As parent_action,
                action_name                        As action_name,
                action_desc                        As action_description,
                action_controller_area             As controller_area,
                action_controller_name             As controller_name,
                action_controller_method           As controller_method,
                action_request_method_type         As request_method_type,
                level                              As action_level,
                Connect_By_Isleaf                  As is_leaf,
                sys_connect_by_path(a.key_id, '/') As site_map_path,
                ap.index_form_fields               As index_form_fields,
                ap.controller_method_param_names,
                Null                               As action_url,
                Null                               As filter_popup_url
            From
                app_sitemap_actions           a
                Inner Join app_sitemaps       b
                On a.sitemap_fkey_id = b.key_id
                And b.key_id         = p_sitemap_id
                Left Outer Join action_params ap
                On a.key_id = ap.action_id
            Where
                a.key_id In (
                    Select
                        key_id
                    From
                        app_sitemap_actions aa
                    Start
                    With
                        module_action_id In(
                            Select
                                action_id
                            From
                                vu_module_user_role_actions
                            Where
                                module_id = p_module_id
                                And empno = v_empno
                        )
                    Connect By
                        aa.key_id = Prior parent_action_fkey_id
                )
            Start
            With
                a.key_id In (
                    Select
                        key_id
                    From
                        app_sitemap_actions
                    Where
                        parent_action_fkey_id Is Null
                )
            Connect By
                Prior a.key_id = parent_action_fkey_id;
        Return c;
    End;

    Procedure sp_get_action_details(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_module_id               Varchar2,
        p_sitemap_id              Varchar2,
        p_action_id               Varchar2,

        p_action_name         Out Varchar2,
        p_action_description  Out Varchar2,
        p_controller_area     Out Varchar2,
        p_controller_name     Out Varchar2,
        p_controller_method   Out Varchar2,
        p_request_method_type Out Varchar2,

        p_filter_form_fields  Out Sys_Refcursor,

        p_message_type        Out Varchar2,
        p_message_text        Out Varchar2

    ) As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin

        v_empno        := selfservice.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;

        --Action details
        Select
            action_name,
            action_desc,
            action_controller_area,
            action_controller_name,
            action_controller_method,
            action_request_method_type
        Into
            p_action_name,
            p_action_description,
            p_controller_area,
            p_controller_name,
            p_controller_method,
            p_request_method_type

        From
            app_sitemap_actions
        Where
            module_id           = p_module_id
            And sitemap_fkey_id = p_sitemap_id
            And key_id          = p_action_id;

        --Filter form fields list
        Open p_filter_form_fields For
            Select
                filter_formfield_fkey_id field_id,
                is_required,
                controller_method_param_name,
                functional_desc          functional_description
            From
                app_sitemap_action_formfields

            Where
                sitemap_fkey_id    = p_sitemap_id
                And action_fkey_id = p_action_id;

        p_message_type := ok;
        p_message_text := 'Procedure executed succefully';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

End pkg_site_map;