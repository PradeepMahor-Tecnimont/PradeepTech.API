Create Or Replace Package Body dms.inv_select_list_qry As

    Function fn_item_type_list(
        p_person_id      Varchar2,
        p_item_type_code Varchar2 Default Null,
        p_meta_id        Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select item_type_key_id                          data_value_field,
                   item_type_code || ' - ' || item_type_desc data_text_field
              From inv_item_types
             Where category_code = 'C1'
               And item_type_code = nvl(p_item_type_code, item_type_code)
               And is_active = 1
             Order By item_type_desc;

        Return c;
    End;

    Function fn_item_type_full_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select item_type_key_id data_value_field,
                   item_type_code || ' - ' ||
                   category_code || ' - ' ||
                   item_assignment_type || ' - ' ||
                   item_type_desc   data_text_field
              From inv_item_types
             Where is_active = 1
             Order By item_type_desc;

        Return c;
    End;

    Function fn_item_category_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select category_code data_value_field,
                   description   data_text_field
              From inv_item_category
             Where is_active = 1
             Order By description;

        Return c;
    End;

    Function fn_item_asgmt_types_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select asgmt_code data_value_field,
                   asgmt_desc data_text_field
              From inv_item_asgmt_types
             Where asgmt_code In ('ED', 'DD')
               And is_active = 1
             Order By asgmt_desc;
        Return c;
    End;

    Function fn_item_asgmt_types_full_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select asgmt_code data_value_field,
                   asgmt_desc data_text_field
              From inv_item_asgmt_types
             Where is_active = 1
             Order By asgmt_desc;
        Return c;
    End;

    Function fn_ams_sub_asset_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select Distinct
                   a.sub_asset_type                           As data_value_field,
                   a.sub_asset_type || ' - ' || a.description As data_text_field
              From ams.as_sub_asset_type a
             Order By a.sub_asset_type;

        Return c;
    End;

    Function fn_item_ams_asset_mapping_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_item_type_key_id Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select b.barcode                     As data_value_field,
                   b.barcode || ' - ' || b.model As data_text_field
              From dm_ams_transcode a, dm_vu_asset_list b
             Where a.ams_asset_id = b.barcode
               And sub_asset_type In (
                       Select sub_asset_type
                         From inv_item_ams_asset_mapping
                        Where item_type_key_id = p_item_type_key_id
                          And is_active = 1
                   )
               And
                   a.ams_asset_id Not In (
                       Select assetid
                         From dm_deskallocation
                   )
               And a.ams_asset_id Not In (
                       Select item_id
                         From inv_emp_item_mapping
                   )
             Order By b.barcode;
        Return c;
    End;

    Function fn_item_ams_asset_mapping_full_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_item_type_key_id Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select b.barcode                     As data_value_field,
                   b.barcode || ' - ' || b.model As data_text_field
              From dm_ams_transcode a, dm_vu_asset_list b
             Where a.ams_asset_id = b.barcode
               And sub_asset_type In (
                       Select sub_asset_type
                         From inv_item_ams_asset_mapping
                        Where item_type_key_id = p_item_type_key_id
                          And is_active = 1
                   )
             Order By b.barcode;
        Return c;
    End;

    Function fn_item_consumable_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_item_type_key_id Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_category_code      inv_item_types.category_code%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Select category_code
          Into v_category_code
          From inv_item_types
         Where item_type_key_id = Trim(p_item_type_key_id);

        If v_category_code = 'C1' Then
            Open c For
                Select dac.barcode                                                                          As data_value_field,
                       dac.barcode || ' - ' || dac.model || ' - ' || dac.serialnum || ' - ' || dac.compname As data_text_field
                  From dm_assetcode dac,
                       inv_item_ams_asset_mapping iiaam
                 Where dac.sub_asset_type = iiaam.sub_asset_type
                   And nvl(dac.scrap, 0) = 0
                   And iiaam.is_active = 1
                   And Trim(dac.barcode) Not In (
                           Select Trim(assetid)
                             From dm_action_item_exclude
                       )
                   And Trim(dac.barcode) Not In (
                           Select Trim(item_id)
                             From inv_transaction_master itm,
                                  inv_transaction_detail itd
                            Where itm.trans_id = itd.trans_id
                              And trans_type_id In ('T01')
                       )
                   And Trim(dac.barcode) Not In (
                           Select Trim(item_id)
                             From inv_emp_item_mapping
                       )
                   And iiaam.item_type_key_id = Trim(p_item_type_key_id);
        Else
            Open c For
                Select icd.item_id                                As data_value_field,
                       icd.mfg_id || ' - ' || icm.consumable_desc As data_text_field
                  From inv_consumables_master icm,
                       inv_consumables_detail icd
                 Where icm.consumable_id = icd.consumable_id
                   And icd.usable_type = 'U'
                   And icm.item_type_key_id = Trim(p_item_type_key_id)
                   And icd.item_id Not In(
                           Select item_id
                             From inv_emp_item_mapping
                       )
                 Order By icd.item_id;

        End If;
        Return c;
    End;

    Function fn_inv_trans_type_create_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select trans_type_id   As data_value_field,
                   trans_type_desc As data_text_field
              From inv_transaction_types
             Where trans_type_id = 'T01'
             Order By trans_type_desc;
        Return c;
    End;

    Function fn_inv_trans_type_return_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select trans_type_id   As data_value_field,
                   trans_type_desc As data_text_field
              From inv_transaction_types
             Where trans_type_id = 'T02';
        Return c;
    End;

    Function fn_item_ret_consumable_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_empno     Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select icd.item_id                                As data_value_field,
                   icd.mfg_id || ' - ' || icm.consumable_desc As data_text_field
              From inv_consumables_master icm,
                   inv_consumables_detail icd,
                   inv_emp_item_mapping   ieim
             Where icm.consumable_id = icd.consumable_id
               And icd.item_id = ieim.item_id
               And icd.item_id Not In (
                       Select item_id
                         From inv_emp_item_mapping_reserve_return
                        Where empno = Trim(p_empno)
                   )
               And ieim.empno = Trim(p_empno)

            Union All

            Select dac.barcode                                                                          As data_value_field,
                   dac.barcode || ' - ' || dac.model || ' - ' || dac.serialnum || ' - ' || dac.compname As data_text_field
              From dm_assetcode dac,
                   inv_emp_item_mapping ieim
             Where dac.barcode = ieim.item_id
               And dac.barcode Not In (
                       Select item_id
                         From inv_emp_item_mapping_reserve_return
                        Where empno = Trim(p_empno)
                   )
               And ieim.empno = Trim(p_empno)
             Order By 2;

        Return c;
    End;

    Function fn_item_type_asset_full_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select item_type_key_id                          data_value_field,
                   item_type_code || ' - ' || item_type_desc data_text_field
              From inv_item_types
             Where is_active = 1
             Order By 2;

        Return c;
    End;

    Function fn_item_type_4_trans_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_action_id Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select item_type_key_id                          data_value_field,
                   item_type_code || ' - ' || item_type_desc data_text_field
              From inv_item_types
             Where item_assignment_type In ('EE', 'ED')
               And is_active = 1
               and action_id = p_action_id
             Order By 2;

        Return c;
    End;

    Function fn_consumable_item_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c_trackable_item     Constant Varchar2(2) := 'C2';
        c_other_item         Constant Varchar2(2) := 'C3';
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select item_type_key_id                          As data_value_field,
                   item_type_code || ' - ' || item_type_desc As data_text_field
              From inv_item_types
             Where category_code In (c_trackable_item, c_other_item)
             Order By item_type_code;

        Return c;
    End;

    Function fn_inv_ram_capacity_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c_trackable_item     Constant Varchar2(2) := 'C2';
        c_other_item         Constant Varchar2(2) := 'C3';
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select to_char(ram_capacity_gb) As data_value_field,
                   ram_capacity_desc        As data_text_field
              From inv_ram_capacity
             Order By ram_capacity_gb;

        Return c;
    End;

    Function fn_inv_item_addon_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c_trackable_item     Constant Varchar2(2) := 'C2';
        c_other_item         Constant Varchar2(2) := 'C3';
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            With
                item_types As (
                    Select item_type_key_id, item_type_code || ' - ' || item_type_desc item_type_desc
                      From inv_item_types
                ),
                add_ons As (
                    Select addon_id
                      From inv_item_addon_container_mast m
                )

            Select Distinct
                   addon_id       As data_value_field,
                   item_type_desc As data_text_field
              From add_ons a,
                   item_types t
             Where a.addon_id = t.item_type_key_id;

        Return c;
    End;

    Function fn_inv_item_addon_items_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_item_type_key_id Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c_trackable_item     Constant Varchar2(2) := 'C2';
        c_other_item         Constant Varchar2(2) := 'C3';
        c_asset_item         Constant Varchar2(2) := 'C1';
        rec_item_types       inv_item_types%rowtype;

    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Select *
          Into rec_item_types
          From inv_item_types
         Where item_type_key_id = p_item_type_key_id;

        If rec_item_types.category_code = c_asset_item Then

            c := fn_item_ams_asset_mapping_full_list(
                     p_person_id        => p_person_id,
                     p_meta_id          => p_meta_id,
                     p_item_type_key_id => p_item_type_key_id
                 );
        Else
            Open c For
                Select d.item_id                              As data_value_field,
                       d.mfg_id || ' - ' || m.consumable_desc As data_text_field
                  From inv_consumables_detail d,
                       inv_consumables_master m
                 Where d.consumable_id = m.consumable_id
                   And m.item_type_key_id = p_item_type_key_id
                   And d.usable_type = 'U'
                   And d.item_id Not In (
                           Select addon_item_id
                             From inv_item_addon_map
                       );

        End If;
        Return c;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_inv_item_container_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_item_type_key_id Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c_trackable_item     Constant Varchar2(2) := 'C2';
        c_other_item         Constant Varchar2(2) := 'C3';
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            With
                item_types As (
                    Select item_type_key_id, item_type_code || ' - ' || item_type_desc item_type_desc
                      From inv_item_types
                ),
                item_containers As (
                    Select Distinct container_id
                      From inv_item_addon_container_mast m
                     Where addon_id = p_item_type_key_id
                )

            Select container_id   As data_value_field,
                   item_type_desc As data_text_field
              From item_containers a,
                   item_types t
             Where a.container_id = t.item_type_key_id;
        Return c;
    End;

    Function fn_action_type_list(
        p_person_id   Varchar2,
        p_action_type Varchar2 Default Null,
        p_meta_id     Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select to_char(typeid) data_value_field, description data_text_field
              From dm_action_type
             Where outofservice_flag = 0
               And typeid = nvl(p_action_type, typeid)
             Order By typeid;

        Return c;
    End;

    Function fn_desk_4assetonhold_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select Distinct
                   a.deskid data_value_field,
                   a.deskid data_text_field
              From dm_deskmaster a
             Order By a.deskid;

        Return c;
    End;

    Function fn_asset_4assetonhold_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_item_type_key_id Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For

            Select Distinct
                   a.ams_asset_id                     As data_value_field,
                   a.ams_asset_id || ' - ' || b.model As data_text_field
              From dm_ams_transcode a, dm_vu_asset_list b
             Where a.ams_asset_id = b.barcode
               And a.ams_asset_id Not In (
                       Select b.assetid
                         From dm_assetadd b
                   )
               And sub_asset_type In (
                       Select Distinct
                              sub_asset_type
                         From inv_item_ams_asset_mapping
                        Where item_type_key_id = p_item_type_key_id
                          And is_active = 1
                   )
               And
                   a.ams_asset_id Not In (
                       Select Distinct assetid
                         From dm_deskallocation
                   )
             Order By a.ams_asset_id;

        Return c;
    End;

    Function fn_item_usable_types_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For

            Select Distinct
                   Trim(usable_type_id)   As data_value_field,
                   Trim(usable_type_desc) As data_text_field
              From inv_item_usable_types
             Order By Trim(usable_type_id);

        Return c;
    End;

    Function fn_laptop_lot_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For

            Select group_key_id As data_value_field,
                   group_desc   As data_text_field
              From inv_item_group_master
             Order By group_desc;

        Return c;
    End;

    Function fn_item_type_4desk_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select item_type_key_id                          data_value_field,
                   item_type_code || ' - ' || item_type_desc data_text_field
              From inv_item_types
             Where category_code = 'C1'
               And item_assignment_type In ('DD', 'ED')
               And is_active = 1
             Order By item_type_desc;
        Return c;
    End;

    Function fn_item_type_4employee_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select item_type_key_id                          data_value_field,
                   item_type_code || ' - ' || item_type_desc data_text_field
              From inv_item_types
             Where category_code = 'C1'
               And item_assignment_type In ('EE', 'ED')
               And is_active = 1
             Order By item_type_desc;
        Return c;
    End;
    Function fn_item_type_list_for_asset_mapping(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select item_type_code                            data_value_field,
                   item_type_code || ' - ' || item_type_desc data_text_field
              From inv_item_types
             Where is_active = 1
             Order By 1;

        Return c;
    End;
End;
/
  Grant Execute On dms.inv_select_list_qry To tcmpl_app_config;