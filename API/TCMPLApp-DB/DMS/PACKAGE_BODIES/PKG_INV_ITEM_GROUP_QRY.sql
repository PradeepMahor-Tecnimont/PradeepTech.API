------------------------------------------------------
--  DDL for Package Body PKG_INV_consumables_QRY
------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_ITEM_GROUP_QRY" As

    Function fn_item_group_list(
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
                        group_key_id                                  As group_key_id,
                        group_desc                                    As group_desc,
                        modified_on                                   As modified_on,
                        modified_by || ' - ' || e.name                As modified_by,
                        Row_Number() Over (Order By modified_on Desc) As row_number,
                        Count(*) Over ()                              As total_row
                    From
                        inv_item_group_master a,
                        ss_emplmast           e
                    Where
                        a.modified_by = e.empno(+)
                    Order By modified_on Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_item_group_list;

End pkg_inv_item_group_qry;