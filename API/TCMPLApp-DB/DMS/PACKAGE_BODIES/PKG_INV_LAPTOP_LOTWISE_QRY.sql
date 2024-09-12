------------------------------------------------------
--  DDL for Package Body PKG_INV_consumables_QRY
------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_LAPTOP_LOTWISE_QRY" As

    Function fn_lotwise_all(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_lot            Varchar2 Default Null,
        p_status         Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c           Sys_Refcursor;
        v_max_count Number;
        v_min_count Number;
        v_generic_search Varchar2(100);
    Begin
        If p_status Is Null Then
            v_max_count := 6;
            v_min_count := 0;
        Elsif p_status = 1 Then
            v_max_count := 6;
            v_min_count := 3;
        Elsif p_status = -1 Then
            v_max_count := 2;
            v_min_count := 0;
        End If;
        
        if p_generic_search  is null then 
            v_generic_search := '%';
            else
            v_generic_search := '%' || p_generic_search ||'%';
        end if;
        
        
        
        Open c For
            Select
                *
            From
                (
                    Select
                        lot_id,
                        lot_desc,
                        ams_asset_id,
                        sap_asset_code,
                        nb_name,
                        nb_serialnum,
                        ds_id,
                        ds_serialnum,
                        empno,
                        name,
                        parent,
                        assign,
                        grade,
                        emptype,
                        email,
                        Row_Number() Over (Order By lot_id, ams_asset_id) As row_number,
                        Count(*) Over ()                                  As total_row
                    From
                        inv_vu_laptop_lotwise
                    Where
                        length(nvl(empno, ' ')) Between v_min_count And v_max_count
                        And lot_id = nvl(p_lot, lot_id)
                        And (
                            ams_asset_id Like v_generic_search 
                            Or nb_name Like v_generic_search
                            Or upper(lot_desc) Like p_generic_search
                            )                        
                    Order By lot_id, ams_asset_id
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_lotwise_all;

    Function fn_lotwise_pending(
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
                        lot_id,
                        lot_desc,
                        ams_asset_id,
                        sap_asset_code,
                        nb_name,
                        nb_serialnum,
                        ds_id,
                        ds_serialnum,
                        empno,
                        name,
                        parent,
                        assign,
                        grade,
                        emptype,
                        email,
                        Row_Number() Over (Order By lot_id, ams_asset_id) As row_number,
                        Count(*) Over ()                                  As total_row
                    From
                        inv_vu_laptop_lotwise
                    Where
                        empno Is Null
                    Order By lot_id, ams_asset_id
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_lotwise_pending;

    Function fn_lotwise_issued(
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
                        lot_id,
                        lot_desc,
                        ams_asset_id,
                        sap_asset_code,
                        nb_name,
                        nb_serialnum,
                        ds_id,
                        ds_serialnum,
                        empno,
                        name,
                        parent,
                        assign,
                        grade,
                        emptype,
                        email,
                        Row_Number() Over (Order By lot_id, ams_asset_id) As row_number,
                        Count(*) Over ()                                  As total_row
                    From
                        inv_vu_laptop_lotwise
                    Where
                        empno Is Null
                    Order By lot_id, ams_asset_id
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_lotwise_issued;

End pkg_inv_laptop_lotwise_qry;