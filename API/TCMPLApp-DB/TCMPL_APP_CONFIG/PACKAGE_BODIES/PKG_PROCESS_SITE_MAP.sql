Create Or Replace Package Body pkg_process_site_map As

    Function fnc_get_parameters(p_person_id   Varchar2,
                                p_meta_id     Varchar2,

                                p_link_id     Varchar2,
                                p_link_type   Varchar2,
                                p_is_required Varchar2,
                                p_is_default  Varchar2,
                                p_is_visible  Varchar2,
                                p_is_mapped   Varchar2) Return Varchar2
    As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_data_parameter     Varchar2(4000);
    Begin
        v_empno := selfservice.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Select
            Listagg(Case p_is_mapped
                        When ok Then
                            Case p_is_default
                                When not_ok Then
                                    link_mapping_route_parameters
                                Else
                                    link_mapping_route_parameters || '=' || default_value
                            End
                        Else
                            Case p_is_default
                                When not_ok Then
                                    link_route_parameters
                                Else
                                    link_route_parameters || '=' || default_value
                            End
                    End, ',') Within
                Group (Order By
                    order_by)
        Into
            v_data_parameter
        From
            app_site_map_links_parameters
        Where
            link_type       = Trim(p_link_type)
            And link_id     = Trim(p_link_id)
            And is_required = Trim(p_is_required)
            And is_default  = Trim(p_is_default)
            And is_visible  = Trim(p_is_visible);

        Return v_data_parameter;
    Exception
        When no_data_found Then
            Return Null;
        When Others Then
            Return 'ERROR';
    End fnc_get_parameters;

    Function fn_get_site_map(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_module_id      Varchar2,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor Is
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := selfservice.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (

                    Select
                        smm.site_map_master_id,
                        smm.menu_name,
                        smm.is_leaf,
                        'level' || smm.order_by                             levels,
                        smm.order_by                                        datadepth,
                        Null                                                report_format,
                        Null                                                report_icon,
                        Null                                                process_id,
                        Null                                                filter_mvc_action_name,
                        Null                                                target_controller_name,
                        Null                                                target_action_name,
                        Null                                                target_area_name,
                        Null                                                filter_popup_controller_name,
                        Null                                                filter_popup_action_name,
                        Null                                                filter_popup_area_name,
                        Null                                                data_req_ok_def_ko_vis_ok_map_ok_parameter,
                        Null                                                data_req_ok_def_ko_vis_ok_map_ko_parameter,
                        Null                                                data_req_ko_def_ko_vis_ok_map_ok_parameter,
                        Null                                                data_req_ko_def_ko_vis_ok_map_ko_parameter,
                        Null                                                data_req_ok_def_ok_vis_ko_map_ok_parameter,
                        Null                                                data_req_ok_def_ok_vis_ko_map_ko_parameter,
                        Row_Number() Over (Order By smm.site_map_master_id) row_number,
                        Count(*) Over ()                                    total_row
                    From
                        app_site_map_master smm
                    Where
                        smm.is_report     = not_ok
                        And smm.module_id = Trim(p_module_id)

                    Union All

                    Select
                        smm.site_map_master_id,
                        smm.menu_name,
                        smm.is_leaf,
                        'level' || smm.order_by                             levels,
                        smm.order_by                                        datadepth,
                        Case smm.is_report
                            When ok Then
                                smr.report_format
                            Else
                                Null
                        End                                                 report_format,
                        Case smm.is_report
                            When ok Then
                                smr.report_icon
                            Else
                                Null
                        End                                                 report_icon,
                        sml.process_id,
                        sml.filter_mvc_action_name,
                        sml.link_controller_name                            As target_controller_name,
                        sml.link_action_name                                As target_action_name,
                        sml.link_area_name                                  As tsrget_area_name,
                        'Home'                                              As filter_popup_controller_name,
                        'ReportSiteMapParameter'                            As filter_popup_action_name,
                        'SelfService'                                       As filter_popup_area_name,
                        fnc_get_parameters(p_person_id   => p_person_id,
                                           p_meta_id     => p_meta_id,
                                           p_link_id     => smm.link_id,
                                           p_link_type   => 'LINK',
                                           p_is_required => ok,
                                           p_is_default  => not_ok,
                                           p_is_visible  => ok,
                                           p_is_mapped   => ok)             data_req_ok_def_ko_vis_ok_map_ok_parameter,
                        fnc_get_parameters(p_person_id   => p_person_id,
                                           p_meta_id     => p_meta_id,
                                           p_link_id     => smm.link_id,
                                           p_link_type   => 'LINK',
                                           p_is_required => ok,
                                           p_is_default  => not_ok,
                                           p_is_visible  => ok,
                                           p_is_mapped   => not_ok)         data_req_ok_def_ko_vis_ok_map_ko_parameter,
                        fnc_get_parameters(p_person_id   => p_person_id,
                                           p_meta_id     => p_meta_id,
                                           p_link_id     => smm.link_id,
                                           p_link_type   => 'LINK',
                                           p_is_required => not_ok,
                                           p_is_default  => not_ok,
                                           p_is_visible  => ok,
                                           p_is_mapped   => ok)             data_req_ko_def_ko_vis_ok_map_ok_parameter,
                        fnc_get_parameters(p_person_id   => p_person_id,
                                           p_meta_id     => p_meta_id,
                                           p_link_id     => smm.link_id,
                                           p_link_type   => 'LINK',
                                           p_is_required => not_ok,
                                           p_is_default  => not_ok,
                                           p_is_visible  => ok,
                                           p_is_mapped   => not_ok)         data_req_ko_def_ko_vis_ok_map_ko_parameter,               
                        /*fnc_get_parameters(p_person_id   => p_person_id,
                                           p_meta_id     => p_meta_id,
                                           p_link_id     => smm.link_id,
                                           p_link_type   => 'LINK',
                                           p_is_required => ok,
                                           p_is_default  => ok,
                                           p_is_visible  => not_ok,
                                           p_is_mapped   => ok)   */
                        Null                                                As data_req_ok_def_ok_vis_ko_map_ok_parameter,                               
                        /*   fnc_get_parameters(p_person_id   => p_person_id,
                                              p_meta_id     => p_meta_id,
                                              p_link_id     => smm.link_id,
                                              p_link_type   => 'LINK',
                                              p_is_required => ok,
                                              p_is_default  => ok,
                                              p_is_visible  => not_ok,
                                              p_is_mapped   => not_ok) */
                        Null                                                As data_req_ok_def_ok_vis_ko_map_ko_parameter,
                        Row_Number() Over (Order By smm.site_map_master_id) row_number,
                        Count(*) Over ()                                    total_row
                    From
                        app_site_map_master smm,
                        app_site_map_links  sml,
                        app_site_map_report smr
                    Where
                        smm.site_map_master_id     = sml.site_map_master_id
                        And smm.site_map_master_id = smr.site_map_master_id(+)
                        And smm.module_id          = Trim(p_module_id)
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)

            Order By
                1;

        Return c;

    End fn_get_site_map;

    Function fn_get_report(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_site_map_master_id Varchar2
    ) Return Sys_Refcursor Is
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := selfservice.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                sml.site_map_master_id,
                smlp.link_id,
                sml.link_controller_name,
                sml.link_action_name,
                sml.link_area_name,
                smlp.link_route_parameters,
                smlp.link_mapping_route_parameters,
                smlp.functional_name,
                smlp.functional_datatype,
                smlp.functional_date_parameter,
                Case smlp.is_required
                    When ok Then
                        'required'
                    Else
                        Null
                End is_required,
                smlp.is_default,
                Case smlp.is_default
                    When ok Then
                        smlp.default_value
                    Else
                        Null
                End default_value,
                smlp.is_visible,
                smlp.order_by,
                'Url.Action(' || sml.link_action_name || ',' || sml.link_controller_name || ', new { Area = '|| sml.link_area_name || '})' target_action_url
            From
                app_site_map_links            sml,
                app_site_map_links_parameters smlp
            Where
                sml.link_id                = smlp.link_id
                And sml.site_map_master_id = Trim(p_site_map_master_id)
            Order By
                order_by;

        Return c;

    End fn_get_report;

End pkg_process_site_map;