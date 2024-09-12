------------------------------------------------------
--  DDL for Package Body PKG_INV_ITEM_ADDON_TRANS_QRY
------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_ITEM_ADDON_TRANS_QRY" As

    Function fn_item_addon_trans_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_trans_id       Varchar2 Default Null,
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
                d.*,
                pkg_dms_common.fn_inv_addon_item_desc(d.container_item_id, d.container_item_type) container_item_desc,
                pkg_dms_common.fn_inv_addon_item_desc(d.addon_item_id, d.addon_item_type)         addon_item_desc

            From
                (
                    Select
                        m.fk_trans_id                             As trans_id,
                        a.trans_type,
                        b.trans_type_desc,
                        m.container_item_id,
                        m.container_item_type,
                        m.addon_item_id,
                        cd.mfg_id,
                        m.addon_item_type,
                        a.modified_by,
                        a.trans_date,
                        a.remarks,
                        Row_Number() Over (Order By a.trans_date) row_number,
                        Count(*) Over ()                          total_row

                    From
                        inv_item_addon_map    m,
                        inv_consumables_detail cd,
                        inv_item_addon_trans  a,
                        inv_transaction_types b

                    Where
                        m.fk_trans_id     = a.trans_id
                        and m.addon_item_id = cd.item_id(+)
                        And a.trans_type  = b.trans_type_id
                        And m.fk_trans_id = nvl(p_trans_id, m.fk_trans_id)
                        And (
                            b.trans_type_desc Like v_generic_search
                            Or m.container_item_id Like v_generic_search
                            Or m.addon_item_id Like v_generic_search
                        )
                ) d
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_item_addon_trans_list;

    Function fn_item_addon_trans_list_excel(
        p_person_id Varchar2,
        p_meta_id   Varchar2

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                d.*,
                pkg_dms_common.fn_inv_addon_item_desc(d.container_item_id, d.container_item_type) container_item_desc,
                pkg_dms_common.fn_inv_addon_item_desc(d.addon_item_id, d.addon_item_type)         addon_item_desc

            From
                (
                    Select
                        m.fk_trans_id As trans_id,
                        a.trans_type,
                        b.trans_type_desc,
                        m.container_item_id,
                        m.container_item_type,
                        m.addon_item_id,
                        m.addon_item_type,
                        a.modified_by,
                        a.trans_date,
                        a.remarks

                    From
                        inv_item_addon_map    m,
                        inv_item_addon_trans  a,
                        inv_transaction_types b

                    Where
                        m.fk_trans_id    = a.trans_id
                        And a.trans_type = b.trans_type_id
                ) d;
        Return c;
    End fn_item_addon_trans_list_excel;

    Function fn_item_addon_trans_log_list(
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
                d.*,
                pkg_dms_common.fn_inv_addon_item_desc(d.container_item_id, d.container_item_type) container_item_desc,
                pkg_dms_common.fn_inv_addon_item_desc(d.addon_item_id, d.addon_item_type)         addon_item_desc

            From
                (
                    Select
                        a.trans_id                                As trans_id,
                        a.trans_type,
                        b.trans_type_desc,
                        a.container_item_id,
                        a.container_item_type,
                        a.addon_item_id,
                        a.addon_item_type,
                        a.modified_by,
                        a.trans_date,
                        a.remarks,
                        Row_Number() Over (Order By a.trans_date) row_number,
                        Count(*) Over ()                          total_row
                    From
                        inv_item_addon_trans  a,
                        inv_transaction_types b

                    Where
                        a.trans_type = b.trans_type_id
                        And (
                            b.trans_type_desc Like v_generic_search
                            Or a.container_item_id Like v_generic_search
                            Or a.addon_item_id Like v_generic_search
                        )
                ) d
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_item_addon_trans_log_list;

End pkg_inv_item_addon_trans_qry;
/
Grant Execute On "DMS"."PKG_INV_ITEM_ADDON_TRANS_QRY" To "TCMPL_APP_CONFIG";