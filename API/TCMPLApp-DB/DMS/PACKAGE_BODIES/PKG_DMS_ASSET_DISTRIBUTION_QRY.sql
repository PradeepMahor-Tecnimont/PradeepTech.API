------------------------------------------------------
--  DDL for Package Body PKG_DMS_ASSET_DISTRIBUTION_QRY
------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_DMS_ASSET_DISTRIBUTION_QRY" As

    Function fn_xl_asset_distribution(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number   Default Null,
        p_page_length    Number Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            With
                assigned_asset As
                (
                    Select
                        'D'     As asgmt_type,
                        deskid  As assigned_to,
                        assetid As ams_asset_id
                    From
                        dm_deskallocation
                    Union
                    Select
                        'E'     As asgmt_type,
                        empno   As assigned_to,
                        item_id As ams_asset_id
                    From
                        inv_emp_item_mapping
                ),
                emp_desk As(
                    Select
                        empno   As assigned_to,
                        name    As name_office,
                        parent  As parent_floor,
                        assign  As assign_wing,
                        grade   As grade_cabin,
                        emptype As emptype_workarea,
                        status  As status_isblocked
                    From
                        ss_emplmast
                    Where
                        status = 1
                        Or dol > sysdate - 730
                    Union
                    Select
                        deskid As assigned_to,
                        office,
                        floor,
                        wing,
                        cabin,
                        work_area,
                        isblocked
                    From
                        dm_deskmaster
                    Where
                        deskid Not Like 'H%'
                ),
                asset_lot As (
                    Select
                        barcode,
                        ponum,
                        podate,
                        grnum,
                        sap_assetcode,
                        serialnum,
                        make,
                        model,
                        compname,
                        scrap,
                        sub_asset_type,
                        ga.group_desc As lot_desc
                    From
                        dm_assetcode a,
                        (
                            Select
                                group_desc,
                                item_id
                            From
                                inv_item_group_master m,
                                inv_item_group_detail d
                            Where
                                m.group_key_id = d.group_key_id
                        )            ga
                    Where
                        a.barcode = ga.item_id(+)
                )
            Select
                al.barcode,
                al.ponum,
                al.podate,
                al.grnum,
                to_char(al.sap_assetcode)    As sap_assetcode,
                al.serialnum,
                al.make,
                al.model,
                al.compname,
                to_char(al.scrap)            As scrap,
                al.sub_asset_type,
                al.lot_desc,
                aa.asgmt_type,
                aa.assigned_to,
                ed.name_office,
                ed.parent_floor,
                ed.assign_wing,
                ed.grade_cabin,
                ed.emptype_workarea,
                to_char(ed.status_isblocked) empstatus_deskisblocked
            From
                asset_lot      al,
                assigned_asset aa,
                emp_desk       ed
            Where
                al.barcode         = aa.ams_asset_id(+)
                And ed.assigned_to = aa.assigned_to;

        Return c;
    End fn_xl_asset_distribution;

    Function fn_xl_employee_assets(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c              Sys_Refcursor;
        v_query        Varchar2(4000);
        v_pivot_clause Varchar2(1000);
    Begin

        Select
            Listagg(Distinct Chr(39) || item_type_code || Chr(39) || 'as ' || item_type_code, ',') Within
                Group (Order By
                    category_code) As pivot_clause
        Into
            v_pivot_clause

        From
            (

                Select
                    it.category_code,
                    it.item_type_key_id,
                    it.item_type_code,
                    it.item_type_desc,
                    iaa.sub_asset_type

                From
                    inv_item_types             it,
                    inv_item_ams_asset_mapping iaa

                Where
                    it.item_type_key_id  = iaa.item_type_key_id
                    And item_assignment_type In ('EE', 'ED')
                    And it.category_code = 'C1'
            );

        v_query := '
        With
            desk_emp_count_list As (
                Select
                    deskid, Count(empno) shared_count
                From
                    dm_usermaster
                Group By
                    deskid
            ),
            desk_emp As(
                Select
                    a.empno,
                    a.deskid,
                    b.shared_count
                From
                    dm_usermaster       a,
                    desk_emp_count_list b
            
                Where
                    a.deskid = b.deskid
            ),
        emp_assets as(
        Select
            *
        From
            (

                Select
                    ei.empno As empno1,
                    ei.empno,
                    it.item_type_code,
                    am.barcode,
                    am.model

                From
                    inv_item_types             it,
                    inv_item_ams_asset_mapping iaa,
                    dm_assetcode               am,
                    inv_emp_item_mapping       ei

                Where
                    it.item_type_key_id    = iaa.item_type_key_id
                    And iaa.sub_asset_type = am.sub_asset_type
                    And am.barcode         = ei.item_id
            )
            Pivot(

            Listagg(barcode , ";") Within
                Group (Order By empno, item_type_code) As id,

            Listagg(model , ";") Within
                Group (Order By empno, item_type_code) As model,

            Count(*) count
            For item_type_code In (' || v_pivot_clause || ')
            )
        )
        Select
            e.empno,
            e.name,
            e.parent,
            e.assign,
            e.grade,
            e.emptype,
            e.status,
            de.deskid,
            de.shared_count desk_emp_count,
            ea.*
        From
            ss_emplmast e,
            desk_emp    de,
            emp_assets ea
        Where
            (e.status   = 1
                Or e.empno In (
                    Select
                        eim.empno
                    From
                        inv_emp_item_mapping eim
                ))
            And e.empno = de.empno(+)
            and e.empno = ea.empno1(+)
    ';
        v_query := replace(v_query, '"', chr(39));

        Open c For v_query;
        Return c;
    End;

    Function fn_xl_lotwise_all(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c              Sys_Refcursor;
        v_query        Varchar2(4000);
        v_pivot_clause Varchar2(1000);
    Begin
        Open c For
            Select
                *
            From
                inv_vu_laptop_lotwise;

        Return c;
    End;

    Function fn_xl_lotwise_pending(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c              Sys_Refcursor;
        v_query        Varchar2(4000);
        v_pivot_clause Varchar2(1000);
    Begin
        Open c For
            Select
                *
            From
                inv_vu_laptop_lotwise
            Where
                empno Is Null;

        Return c;
    End;

    Function fn_xl_lotwise_issued(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c              Sys_Refcursor;
        v_query        Varchar2(4000);
        v_pivot_clause Varchar2(1000);
    Begin
        Open c For
            Select
                *
            From
                inv_vu_laptop_lotwise
            Where
                empno Is Not Null;

        Return c;
    End;

End pkg_dms_asset_distribution_qry;
/
Grant Execute On "DMS"."PKG_DMS_ASSET_DISTRIBUTION_QRY" To "TCMPL_APP_CONFIG";