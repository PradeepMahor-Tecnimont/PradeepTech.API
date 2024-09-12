------------------------------------------------------
--  DDL for Package Body PKG_INV_consumables_QRY
------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_CONSUMABLES_QRY" As

    Function fn_consumables_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        consumable_id,
                        consumable_date,
                        consumable_desc,
                        item_type_key_id,
                        quantity,
                        total_issued,
                        total_reserved,
                        total_non_usable,
                        po Po_Number,
                        vendor,
                        warranty_end_date,
                        Row_Number() Over (Order By consumable_date Desc) row_number,
                        Count(*) Over ()                                  total_row
                    From
                        inv_consumables_master
                    Order By consumable_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_consumables_list;

End pkg_inv_consumables_qry;