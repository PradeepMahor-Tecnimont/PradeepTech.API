--------------------------------------------------------
--  DDL for Package Body PKG_DMS_ASSET_ON_HOLD_QRY
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_DMS_ASSET_ON_HOLD_QRY" As

    Function fn_dm_assetadd(
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
                    Distinct
                        b.unqid                                  As unqid,
                        b.deskid                                 As deskid,
                        b.assetid                                As assetid,
                        d.model                                  As asset_desc,
                        b.empno                                  As empno,
                        (
                            Select
                            Distinct c.name
                            From
                                ss_emplmast c
                            Where
                                c.empno = b.empno
                        )                                        As emp_name,
                        b.action_type                            As action_type_val,
                        a.description                            As action_type_text,
                        Null                                     As outofservice_val,
                        Null                                     As outofservice_text,
                        (
                            Select
                            Distinct d.costcode || ' - ' || d.name
                            From
                                ss_costmast d
                            Where
                                d.costcode = b.assign
                        )                                        As assign,
                        b.remarks                                As remarks,
                        Row_Number() Over (Order By b.action_date desc) row_number,
                        Count(*) Over ()                         total_row
                    From
                        dm_action_type                  a,
                        dm_assetadd                     b, dm_vu_asset_list d
                    Where
                        b.action_type = a.typeid(+)
                        And b.assetid = d.barcode(+)
                        And
                        (
                            upper(b.deskid) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(b.empno) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(b.deskid) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(b.assetid) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_dm_assetadd;

    Function fn_xl_dm_assetadd(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_action_type    Varchar2 Default Null,
        p_asset_category Varchar2 Default Null,

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
                    Distinct
                        b.unqid                                  As unqid,
                        b.deskid                                 As deskid,
                        b.assetid                                As assetid,
                        d.model                                  As asset_desc,
                        b.empno                                  As empno,
                        (
                            Select
                            Distinct c.name
                            From
                                ss_emplmast c
                            Where
                                c.empno = b.empno
                        )                                        As emp_name,
                        b.action_type                            As action_type_val,
                        a.description                            As action_type_text,
                        (
                            Select
                            Distinct d.costcode || ' - ' || d.name
                            From
                                ss_costmast d
                            Where
                                d.costcode = b.assign
                        )                                        As assign,
                        b.remarks                                As remarks,
                        Null                                     As outofservice_val,
                        Null                                     As outofservice_text,
                        Row_Number() Over (Order By Rownum Desc) row_number,
                        Count(*) Over ()                         total_row
                    From
                        dm_action_type   a,
                        dm_assetadd      b,
                        dm_vu_asset_list d
                    Where
                        b.action_type              = a.typeid(+)
                        And b.assetid              = d.barcode(+)
                        And nvl(b.action_type, -1) = nvl(p_action_type, nvl(b.action_type, -1))
                        And d.assettype In
                        nvl(
                            (
                                Select
                                Distinct item_type_code
                                From
                                    inv_item_types
                                Where
                                    item_type_key_id = p_asset_category
                            ), nvl(d.assettype, -1))
                );
        Return c;
    End fn_xl_dm_assetadd;

    Procedure sp_dm_assetadd_details(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_unqid                Varchar2,

        p_desk_id          Out Varchar2,
        p_asset_id         Out Varchar2,
        p_empno            Out Varchar2,
        p_empname          Out Varchar2,
        p_action_type_val  Out Number,
        p_action_type_text Out Varchar2,
        p_asset_desc       Out Varchar2,
        p_assign_desc      Out Varchar2,
        p_remarks          Out Varchar2,

        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
        Distinct
            b.deskid,
            b.assetid,
            b.empno,
            c.name,
            b.action_type,
            a.description,
            d.model,
            (
                            Select
                            Distinct d.costcode || ' - ' || d.name
                            From
                                ss_costmast d
                            Where
                                d.costcode = b.assign
                        )                                        As assign ,
            b.remarks
        Into
            p_desk_id,
            p_asset_id,
            p_empno,
            p_empname,
            p_action_type_val,
            p_action_type_text,
            p_asset_desc,
            p_assign_desc,
            p_remarks
        From
            dm_action_type             a,
            dm_assetadd                b, ss_emplmast c, dm_vu_asset_list d
        Where
            b.action_type = a.typeid(+)
            And b.empno   = c.empno(+)
            And b.assetid = d.barcode(+)
            And b.unqid   = p_unqid;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_dm_assetadd_details;

    Function fn_dm_action_trans(
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
                        b.actiontransid                                 As actiontrans_id,
                        b.assetid                                       As assetid,
                        b.sourcedesk                                    As source_desk,
                        b.targetasset                                   As target_asset,
                        b.remarks                                       As remarks,
                        b.action_date                                   As action_date,
                        b.action_by                                     As action_by_empno,
                        c.name                                          As action_by_empname,
                        b.source_emp                                    As source_emp,
                        b.assetid_old                                   As asset_id_old,
                        a.typeid                                        As action_type_val,
                        a.description                                   As action_type_text,
                        Row_Number() Over (Order By b.action_date Desc) row_number,
                        Count(*) Over ()                                total_row
                    From
                        dm_action_type                    a, dm_action_trans b, ss_emplmast c
                    Where
                        a.typeid        = b.action_type(+)
                        And b.action_by = c.empno(+)
                        And
                        (
                            upper(b.sourcedesk) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(c.empno) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(c.name) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(b.assetid) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_dm_action_trans;

    Procedure sp_dm_action_trans_details(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_actiontrans_id       Varchar2,

        p_asset_id         Out Varchar2,
        p_source_desk      Out Varchar2,
        p_target_asset     Out Varchar2,
        p_remarks          Out Varchar2,
        p_action_date      Out Varchar2,
        p_action_by        Out Varchar2,
        p_source_emp       Out Varchar2,
        p_assetid_old      Out Varchar2,
        p_action_type_val  Out Number,
        p_action_type_text Out Varchar2,

        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            b.assetid,
            b.sourcedesk,
            b.targetasset,
            b.remarks,
            b.action_date,
            b.action_by || ' : ' || c.name,
            b.source_emp,
            b.assetid_old,
            a.typeid,
            a.description
        Into
            p_asset_id,
            p_source_desk,
            p_target_asset,
            p_remarks,
            p_action_date,
            p_action_by,
            p_source_emp,
            p_assetid_old,
            p_action_type_val,
            p_action_type_text
        From
            dm_action_type                    a, dm_action_trans b, ss_emplmast c
        Where
            a.typeid            = b.action_type(+)
            And b.action_by     = c.empno (+)
            And b.actiontransid = p_actiontrans_id;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_dm_action_trans_details;

End pkg_dms_asset_on_hold_qry;
/
Grant Execute On "DMS"."PKG_DMS_ASSET_ON_HOLD_QRY" To "TCMPL_APP_CONFIG";