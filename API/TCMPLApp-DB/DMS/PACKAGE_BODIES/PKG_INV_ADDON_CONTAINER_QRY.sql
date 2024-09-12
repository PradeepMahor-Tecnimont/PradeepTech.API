------------------------------------------------------
--  DDL for Package Body PKG_INV_ITEM_ADDON_TRANS_QRY
------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_ADDON_CONTAINER_QRY" As

    Function fn_addon_container_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c                Sys_Refcursor;
        v_generic_search Varchar2(100);
    Begin
        If p_generic_search Is Null Then
            v_generic_search := '%';
        Else
            v_generic_search := '%' || p_generic_search || '%';
        End If;
        Open c For

            Select
                *

            From
                (

                    Select
                        ac.key_id,
                        ac.addon_id                              addon_item_id,
                        ita.item_type_desc                       addon_item_desc,
                        ac.container_id                          container_item_id,
                        itc.item_type_desc                       container_item_desc,

                        Row_Number() Over (Order By ac.addon_id) row_number,
                        Count(*) Over ()                         total_row

                    From
                        inv_item_addon_container_mast ac,
                        inv_item_types                ita,
                        inv_item_types                itc
                    Where
                        ac.addon_id         = ita.item_type_key_id
                        And ac.container_id = itc.item_type_key_id
                        And (
                            ita.item_type_desc Like v_generic_search
                            Or itc.item_type_desc Like v_generic_search
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_addon_container_list;

    Function fn_addon_container_excel(
        p_person_id Varchar2,
        p_meta_id   Varchar2

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                ac.addon_id        addon_id,
                ita.item_type_desc addon_desc,
                ac.container_id    container_id,
                itc.item_type_desc container_desc
            From
                inv_item_addon_container_mast ac,
                inv_item_types                ita,
                inv_item_types                itc
            Where
                ac.addon_id         = ita.item_type_key_id
                And ac.container_id = itc.item_type_key_id;

        Return c;
    End;

End pkg_inv_addon_container_qry;
/