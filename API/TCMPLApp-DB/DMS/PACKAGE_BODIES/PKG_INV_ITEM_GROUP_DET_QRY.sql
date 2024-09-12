------------------------------------------------------
--  DDL for Package Body PKG_INV_CONSUMABLES_DET_QRY
------------------------------------------------------

Create Or Replace Package Body dms.pkg_inv_item_group_det_qry As

    Function fn_item_group_detail_list(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_inv_item_group_id Varchar2,

        p_generic_search    Varchar2 Default Null,

        p_row_number        Number   Default Null,
        p_page_length       Number Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        item_id,
                        sap_asset_code,
                        Row_Number() Over (Order By item_id Desc) row_number,
                        Count(*) Over ()                          total_row
                    From
                        inv_item_group_detail
                    Where
                        group_key_id = p_inv_item_group_id

                    Order By item_id Asc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_item_group_detail_list;

End pkg_inv_item_group_det_qry;
/
Grant Execute On pkg_inv_item_group_det_qry To tcmpl_app_config;