------------------------------------------------------
--  DDL for Package Body PKG_INV_CONSUMABLES_DET_QRY
------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_CONSUMABLES_DET_QRY" As

    Function fn_consumables_detail_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_consumable_id  Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number   Default Null,
        p_page_length    Number Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    With
                        query1 As (
                            Select
                                *
                            From
                                inv_item_types
                        )
                    Select
                        itd.consumable_det_id,
                        itd.consumable_id,
                        itd.item_id,
                        itd.mfg_id,
                        itd.is_new,
                        null is_issued,
                        itd.usable_type is_usable,
                        itm.consumable_date,
                        itm.consumable_desc,
                        itm.quantity,
                        query1.item_type_code,
                        query1.category_code,
                        query1.item_type_desc,
                        Row_Number() Over (Order By itd.consumable_det_id Desc) row_number,
                        Count(*) Over ()                                        total_row
                    From
                        inv_consumables_master itm,
                        inv_consumables_detail itd,
                        query1
                    Where
                        itm.consumable_id        = p_consumable_id
                        And itm.consumable_id    = itd.consumable_id
                        And itm.item_type_key_id = query1.item_type_key_id

                    Order By itd.mfg_id Asc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_consumables_detail_list;

End pkg_inv_consumables_det_qry;
/
Grant Execute On pkg_inv_consumables_det_qry To "TCMPL_APP_CONFIG";