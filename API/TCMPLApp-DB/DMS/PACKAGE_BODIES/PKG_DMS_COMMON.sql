--------------------------------------------------------
--  DDL for Package  PKG_DMS_DESK_AREAS
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_DMS_COMMON" As

    Function fn_inv_addon_item_desc(
        p_item_id   Varchar2,
        p_item_type Varchar2
    ) Return Varchar2 Is
        rec_item_type inv_item_types%rowtype;
        v_item_desc   Varchar2(100);
    Begin
        Select
            *
        Into
            rec_item_type
        From
            inv_item_types
        Where
            item_type_key_id = p_item_type;
        If rec_item_type.category_code = 'C1' Then

            Select
                m.asset_model
            Into
                v_item_desc
            From
                ams.as_asset_mast m
            Where
                ams_asset_id = p_item_id;
        Else
            Select
                m.consumable_desc
            Into
                v_item_desc
            From
                inv_consumables_detail d,
                inv_consumables_master m
            Where
                d.consumable_id = m.consumable_id
                And d.item_id   = p_item_id;

        End If;
        Return v_item_desc;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_inv_get_pc_nb_ram(
        p_asset_id Varchar2
    ) Return number As
        v_retval Number;
    Begin
        Select
            Sum(ram_capacity_gb)
        Into
            v_retval
        From
            dm_vu_inv_ram_amsid_map
        Where
            ams_asset_id = p_asset_id;
        Return (v_retval);

    Exception
        When Others Then
            Null;
    End;

    Function fn_inv_get_pc_gcard(
        p_asset_id Varchar2
    ) Return Varchar2 As
        v_retval Varchar2(1000);
    Begin
        If p_asset_id Is Null Then
            Return Null;
        End If;

        Select
            Listagg(gcard_desc, ','
                On Overflow Truncate) Within
                Group (Order By
                    ams_asset_id)
        Into
            v_retval
        From
            dm_vu_inv_gcard_amsid_map
        Where
            ams_asset_id = p_asset_id;
        Return to_char(v_retval);

    End;

    Function fn_get_pc_name(
        p_asset_id Varchar2
    ) Return Varchar2 As
        v_retval Varchar2(1000);
    Begin
        If p_asset_id Is Null Then
            Return Null;
        End If;

        Select
            compname
        Into
            v_retval
        From
            dm_assetcode
        Where
            barcode = p_asset_id;
        Return to_char(v_retval);

    End;
    
    Function fn_get_asset_model_name(
        p_asset_id Varchar2
    ) Return Varchar2 as
        v_retval Varchar2(1000);
    Begin
        If p_asset_id Is Null Then
            Return Null;
        End If;

        Select
            model
        Into
            v_retval
        From
            dm_assetcode
        Where
            trim(barcode) = p_asset_id;
        Return to_char(v_retval);

    End;


End pkg_dms_common;