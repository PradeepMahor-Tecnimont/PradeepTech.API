--------------------------------------------------------
--  DDL for Package Body PKG_DMS_ASSET_ASGMT_QRY
--------------------------------------------------------

Create Or Replace Package Body dms.pkg_dms_asset_asgmt_qry As

    Procedure sp_asset_asgmt_master_details(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_generic_search     Varchar2,

        p_asset_id       Out Varchar2,
        p_asset_type     Out Varchar2,
        p_model          Out Varchar2,
        p_serial_num     Out Varchar2,
        p_warranty_end   Out Varchar2,
        p_sap_asset_code Out Varchar2,
        p_sub_asset_type Out Varchar2,
        p_employee       Out Varchar2,
        P_Empno          Out Varchar2,
        p_deskid         Out Varchar2,
        p_status         Out Varchar2,
        p_remarks        Out Varchar2,
        p_scrap          Out Varchar2,
        p_scrap_date     Out Varchar2,

        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_count        Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select Count(*)
          Into v_count
          From dm_assetcode
         Where barcode = upper(Trim(p_generic_search));

        If v_count = 1 Then
            Select a.barcode,
                   a.assettype || ' : ' || b.item_type_desc,
                   a.model,
                   a.serialnum,
                   a.warranty_end,
                   a.sap_assetcode,
                   a.sub_asset_type,
                   Case
                       When scrap = 1 Then
                           'Yes'
                       When scrap = 0 Then
                           'No'
                   End,
                   a.scrap_date
              Into p_asset_id,
                   p_asset_type,
                   p_model,
                   p_serial_num,
                   p_warranty_end,
                   p_sap_asset_code,
                   p_sub_asset_type,
                   p_scrap,
                   p_scrap_date
              From dm_assetcode a, inv_item_types b
             Where barcode = upper(Trim(p_generic_search))
               And a.assettype = b.item_type_code;

        End If;

        Select Count(*)
          Into v_count
          From inv_emp_item_mapping
         Where item_id = upper(Trim(p_generic_search));

        If v_count > 0 Then

            Select empno , get_emp_name(empno)
              Into P_Empno , p_employee
              From inv_emp_item_mapping
             Where item_id = upper(Trim(p_generic_search));

        End If;

        Select Count(*)
          Into v_count
          From dm_deskallocation
         Where assetid = upper(Trim(p_generic_search));

        If v_count > 0 Then

            Select deskid
              Into p_deskid
              From dm_deskallocation
             Where assetid = upper(Trim(p_generic_search));

        End If;

        Select Count(*)
          Into v_count
          From dm_action_item_exclude
         Where assetid = upper(Trim(p_generic_search));

        If v_count > 0 Then

            Select b.description,
                   a.remarks
              Into p_status,
                   p_remarks
              From dm_action_item_exclude a,
                   dm_action_type b
             Where assetid = upper(Trim(p_generic_search))
               And a.action_type = b.typeid;

        End If;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_asset_asgmt_master_details;

End pkg_dms_asset_asgmt_qry;
/
Grant Execute On dms.pkg_dms_asset_asgmt_qry To tcmpl_app_config;