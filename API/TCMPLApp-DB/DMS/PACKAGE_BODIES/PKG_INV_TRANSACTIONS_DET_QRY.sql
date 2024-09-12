------------------------------------------------------
--  DDL for Package Body PKG_INV_TRANSACTIONS_DET_QRY
------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_TRANSACTIONS_DET_QRY" As

    Function fn_transactions_detail_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_trans_id       Varchar2,

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
                    Select
                        iit.print_order,
                        itd.trans_det_id,
                        itd.trans_id,
                        iit.item_type_code || ' - ' || iit.item_type_desc  item_type_desc,
                        iit.item_type_desc                                 item_type_description,
                        itt.trans_type_desc,
                        itd.item_id,
                        Case iit.category_code
                            When 'C3' Then
                                fn_consumable_details_get(p_person_id => p_person_id,
                                                          p_meta_id   => p_meta_id,                                                
                                                          p_item_id   => itd.item_id)
                            Else
                                icd.mfg_id                                         
                        End                                                 item_details,                        
                        Case itd.item_usable
                            When 'Y' Then
                                'Yes'
                            When 'N' Then
                                'No'
                            When 'L' Then
                                'Lost'
                            Else
                                itd.item_usable
                        End                                                As item_usable,
                        Case itt.trans_type_desc
                            When 'RESERVE' Then
                                1
                            When 'INCOMPLETE RETURN' Then
                                1
                            Else
                                0
                        End                                                As delete_item,
                        Row_Number() Over (Order By itd.trans_det_id Desc) row_number,
                        Count(*) Over ()                                   total_row
                    From
                        inv_transaction_master itm,
                        inv_transaction_detail itd,
                        inv_transaction_types  itt,
                        inv_consumables_master icm,
                        inv_consumables_detail icd,
                        inv_item_types         iit,
                        inv_item_category      iic
                    Where
                        itm.trans_id             = itd.trans_id
                        And itm.trans_type_id    = itt.trans_type_id
                        And iit.item_type_key_id = icm.item_type_key_id
                        And icd.item_id          = itd.item_id
                        And icm.consumable_id    = icd.consumable_id
                        And iic.category_code    = iit.category_code
                        And (
                            upper(itd.item_id) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(iic.category_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(iic.description) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(iit.item_type_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(iit.item_type_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )
                        And itd.trans_id         = Trim(p_trans_id)

                    Union All

                    Select
                        iit.print_order,
                        itd.trans_det_id,
                        itd.trans_id,
                        iit.item_type_code || ' - ' || iit.item_type_desc        item_type_desc,
                        iit.item_type_desc                                       item_type_description,
                        itt.trans_type_desc,
                        itd.item_id,
                        Case iit.category_code
                            When 'C3' Then
                                fn_consumable_details_get(p_person_id => p_person_id,
                                                          p_meta_id   => p_meta_id,                                                
                                                          p_item_id   => itd.item_id)
                            Else
                                dac.model || ' - ' || dac.serialnum || ' - ' || compname 
                        End                                                      item_details,
                        Case itd.item_usable
                            When 'Y' Then
                                'Yes'
                            When 'N' Then
                                'No'
                            When 'L' Then
                                'Lost'
                            Else
                                itd.item_usable
                        End                                                      As item_usable,
                        Case itt.trans_type_desc
                            When 'RESERVE' Then
                                1
                            When 'INCOMPLETE RETURN' Then
                                1
                            Else
                                0
                        End                                                      As delete_item,
                        Row_Number() Over (Order By itd.trans_det_id Desc)       row_number,
                        Count(*) Over ()                                         total_row
                    From
                        inv_transaction_master     itm,
                        inv_transaction_detail     itd,
                        inv_transaction_types      itt,
                        dm_assetcode               dac,
                        inv_item_ams_asset_mapping iiaam,
                        inv_item_types             iit
                    Where
                        itm.trans_id             = itd.trans_id
                        And itm.trans_type_id    = itt.trans_type_id
                        And itd.item_id          = dac.barcode
                        And dac.sub_asset_type   = iiaam.sub_asset_type
                        And iit.item_type_key_id = iiaam.item_type_key_id
                        And (
                            upper(itd.item_id) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(dac.sub_asset_type) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(dac.sap_assetcode) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(dac.model) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(dac.serialnum) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )
                        And itd.trans_id         = Trim(p_trans_id)
                )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
                Order By 
                        print_order;                           

        Return c;
    End fn_transactions_detail_list;

    Function fn_employee_transactions_detail_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_empno          Varchar2,
        p_trans_type_id  Varchar2 Default Null,
        p_json_obj       Varchar2 Default Null,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number   Default Null,
        p_page_length    Number Default Null

    ) Return Sys_Refcursor As
        v_empno         Varchar2(5);
        c          Sys_Refcursor;
        v_json_obj Varchar2(32767);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
     v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
             Raise e_employee_not_found;
          Return Null;
        End If;
        If p_trans_type_id = 'T03' Then
            If p_json_obj Is Not Null Then

                Open c For
                    Select
                        trans_det_id,
                        trans_id,
                        trans_date_string,
                        trans_date,
                        barcode,
                        item_type_desc,
                        item_id,
                        item_details,
                        item_usable,
                        delete_item,
                        trans_type,
                        row_number,
                        total_row,
                        usable_type_desc
                    From
                        (
                            With
                                table_json As
                                (
                                    Select
                                        jt.itemid, jt.isusable, itut.usable_type_desc
                                    From
                                        Json_Table (p_json_obj Format Json, '$[*]'
                                            Columns (
                                                itemid   Varchar2 (20) Path '$.ItemId',
                                                isusable Varchar2 (1)  Path '$.IsUsable'
                                            )
                                        ) As "JT", inv_item_usable_types itut
                                    Where
                                        itut.usable_type_id = jt.isusable
                                )
                            Select
                                trans_det_id,
                                trans_id,
                                trans_date_string,
                                trans_date,
                                barcode,
                                item_type_desc,
                                item_id,
                                item_details,
                                item_usable,
                                delete_item,
                                trans_type,
                                row_number,
                                total_row,
                                table_json.itemid,
                                table_json.isusable,
                                table_json.usable_type_desc
                            From
                                (
                                    Select
                                        itd.trans_det_id,
                                        itd.trans_id,
                                        to_char(itm.trans_date, 'DD-Mon-YYYY')             As trans_date_string,
                                        itm.trans_date,
                                        Null                                               As barcode,
                                        iit.item_type_code || ' - ' || iit.item_type_desc  item_type_desc,
                                        itd.item_id,
                                        icd.mfg_id                                         item_details,
                                        Case itd.item_usable
                                            When 'Y' Then
                                                'Yes'
                                            When 'N' Then
                                                'No'
                                            When 'L' Then
                                                'Lost'
                                            Else
                                                itd.item_usable
                                        End                                                As item_usable,
                                        Case itt.trans_type_desc
                                            When 'RESERVE' Then
                                                1
                                            Else
                                                0
                                        End                                                As delete_item,
                                        itt.trans_type_desc                                As trans_type,
                                        Row_Number() Over (Order By itd.trans_det_id Desc) row_number,
                                        Count(*) Over ()                                   total_row
                                    From
                                        inv_transaction_master itm,
                                        inv_transaction_detail itd,
                                        inv_transaction_types  itt,
                                        inv_consumables_master icm,
                                        inv_consumables_detail icd,
                                        inv_item_types         iit,
                                        inv_item_category      iic,
                                        inv_emp_item_mapping   ieim
                                    Where
                                        itm.trans_id             = itd.trans_id
                                        And itm.trans_type_id    = itt.trans_type_id
                                        And iit.item_type_key_id = icm.item_type_key_id
                                        And icd.item_id          = itd.item_id
                                        And icm.consumable_id    = icd.consumable_id
                                        And iic.category_code    = iit.category_code
                                        and  iit.action_id in 
                                        (Select
                                            sec_module_role_actions.action_id
                                        From
                                            tcmpl_app_config.sec_module_user_roles
                                            Left Join tcmpl_app_config.sec_module_role_actions
                                            On sec_module_user_roles.role_id = sec_module_role_actions.role_id
                                        Where
                                            sec_module_user_roles.module_id = 'M16'
                                            And sec_module_user_roles.empno = v_empno)
                                        And (
                                            upper(itd.item_id) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(iic.category_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(iic.description) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(iit.item_type_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(iit.item_type_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                                        )
                                        And itt.trans_type_id    = Trim(p_trans_type_id)
                                        And itd.item_id = ieim.item_id
                                        And itm.trans_id = ieim.trans_id
                                        And itm.empno = ieim.empno
                                        And itm.empno            = Trim(p_empno)

                                    Union All

                                    Select
                                        itd.trans_det_id,
                                        itd.trans_id,
                                        to_char(itm.trans_date, 'DD-Mon-YYYY')                   As trans_date_string,
                                        itm.trans_date,
                                        dac.barcode,
                                        iit.item_type_code || ' - ' || iit.item_type_desc        item_type_desc,
                                        itd.item_id,
                                        dac.model || ' - ' || dac.serialnum || ' - ' || compname item_details,
                                        Case itd.item_usable
                                            When 'Y' Then
                                                'Yes'
                                            When 'N' Then
                                                'No'
                                            When 'L' Then
                                                'Lost'
                                            Else
                                                itd.item_usable
                                        End                                                      As item_usable,
                                        Case itt.trans_type_desc
                                            When 'RESERVE' Then
                                                1
                                            Else
                                                0
                                        End                                                      As delete_item,
                                        itt.trans_type_desc                                      As trans_type,
                                        Row_Number() Over (Order By itd.trans_det_id Desc)       row_number,
                                        Count(*) Over ()                                         total_row
                                    From
                                        inv_transaction_master     itm,
                                        inv_transaction_detail     itd,
                                        inv_transaction_types      itt,
                                        dm_assetcode               dac,
                                        inv_item_ams_asset_mapping iiaam,
                                        inv_item_types             iit,
                                        inv_emp_item_mapping       ieim
                                    Where
                                        itm.trans_id             = itd.trans_id
                                        And itm.trans_type_id    = itt.trans_type_id
                                        And itd.item_id          = dac.barcode
                                        And dac.sub_asset_type   = iiaam.sub_asset_type
                                        And iit.item_type_key_id = iiaam.item_type_key_id
                                        and  iit.action_id in 
                                        (Select
                                            sec_module_role_actions.action_id
                                        From
                                            tcmpl_app_config.sec_module_user_roles
                                            Left Join tcmpl_app_config.sec_module_role_actions
                                            On sec_module_user_roles.role_id = sec_module_role_actions.role_id
                                        Where
                                            sec_module_user_roles.module_id = 'M16'
                                            And sec_module_user_roles.empno = v_empno)
                                        And (
                                            upper(itd.item_id) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(dac.sub_asset_type) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(dac.sap_assetcode) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(dac.model) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(dac.serialnum) Like '%' || upper(Trim(p_generic_search)) || '%'
                                        )
                                        And itt.trans_type_id    = Trim(p_trans_type_id)
                                        And itd.item_id = ieim.item_id
                                        And itm.trans_id = ieim.trans_id
                                        And itm.empno = ieim.empno
                                        And itm.empno            = Trim(p_empno)

                                ) data, table_json
                            Where
                                data.item_id = table_json.itemid
                            Order By trans_date Desc, item_id
                        )
                    Where
                        row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
            Else
                Open c For
                    Select
                        *
                    From
                        (
                            Select
                                *
                            From
                                (
                                    Select
                                        itd.trans_det_id,
                                        itd.trans_id,
                                        to_char(itm.trans_date, 'DD-Mon-YYYY')             As trans_date_string,
                                        itm.trans_date,
                                        Null                                               As barcode,
                                        iit.item_type_code || ' - ' || iit.item_type_desc  item_type_desc,
                                        itd.item_id,
                                        icd.mfg_id                                         item_details,
                                        Case itd.item_usable
                                            When 'Y' Then
                                                'Yes'
                                            When 'N' Then
                                                'No'
                                            When 'L' Then
                                                'Lost'
                                            Else
                                                itd.item_usable
                                        End                                                As item_usable,
                                        Case itt.trans_type_desc
                                            When 'RESERVE' Then
                                                1
                                            Else
                                                0
                                        End                                                As delete_item,
                                        itt.trans_type_desc                                As trans_type,
                                        Row_Number() Over (Order By itd.trans_det_id Desc) row_number,
                                        Count(*) Over ()                                   total_row
                                    From
                                        inv_transaction_master itm,
                                        inv_transaction_detail itd,
                                        inv_transaction_types  itt,
                                        inv_consumables_master icm,
                                        inv_consumables_detail icd,
                                        inv_item_types         iit,
                                        inv_item_category      iic,
                                        inv_emp_item_mapping   ieim
                                    Where
                                        itm.trans_id             = itd.trans_id
                                        And itm.trans_type_id    = itt.trans_type_id
                                        And iit.item_type_key_id = icm.item_type_key_id
                                        And icd.item_id          = itd.item_id
                                        And icm.consumable_id    = icd.consumable_id
                                        And iic.category_code    = iit.category_code
                                        and  iit.action_id in 
                                        (Select
                                            sec_module_role_actions.action_id
                                        From
                                            tcmpl_app_config.sec_module_user_roles
                                            Left Join tcmpl_app_config.sec_module_role_actions
                                            On sec_module_user_roles.role_id = sec_module_role_actions.role_id
                                        Where
                                            sec_module_user_roles.module_id = 'M16'
                                            And sec_module_user_roles.empno = v_empno)
                                        And (
                                            upper(itd.item_id) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(iic.category_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(iic.description) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(iit.item_type_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(iit.item_type_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                                        )
                                        And itt.trans_type_id    = Trim(p_trans_type_id)
                                        And itd.item_id = ieim.item_id
                                        And itm.trans_id = ieim.trans_id
                                        And itm.empno = ieim.empno
                                        And itm.empno            = Trim(p_empno)

                                    Union All

                                    Select
                                        itd.trans_det_id,
                                        itd.trans_id,
                                        to_char(itm.trans_date, 'DD-Mon-YYYY')                   As trans_date_string,
                                        itm.trans_date,
                                        dac.barcode,
                                        iit.item_type_code || ' - ' || iit.item_type_desc        item_type_desc,
                                        itd.item_id,
                                        dac.model || ' - ' || dac.serialnum || ' - ' || compname item_details,
                                        Case itd.item_usable
                                            When 'Y' Then
                                                'Yes'
                                            When 'N' Then
                                                'No'
                                            When 'L' Then
                                                'Lost'
                                            Else
                                                itd.item_usable
                                        End                                                      As item_usable,
                                        Case itt.trans_type_desc
                                            When 'RESERVE' Then
                                                1
                                            Else
                                                0
                                        End                                                      As delete_item,
                                        itt.trans_type_desc                                      As trans_type,
                                        Row_Number() Over (Order By itd.trans_det_id Desc)       row_number,
                                        Count(*) Over ()                                         total_row
                                    From
                                        inv_transaction_master     itm,
                                        inv_transaction_detail     itd,
                                        inv_transaction_types      itt,
                                        dm_assetcode               dac,
                                        inv_item_ams_asset_mapping iiaam,
                                        inv_item_types             iit,
                                        inv_emp_item_mapping       ieim
                                    Where
                                        itm.trans_id             = itd.trans_id
                                        And itm.trans_type_id    = itt.trans_type_id
                                        And itd.item_id          = dac.barcode
                                        And dac.sub_asset_type   = iiaam.sub_asset_type
                                        And iit.item_type_key_id = iiaam.item_type_key_id
                                        and  iit.action_id in 
                                        (Select
                                            sec_module_role_actions.action_id
                                        From
                                            tcmpl_app_config.sec_module_user_roles
                                            Left Join tcmpl_app_config.sec_module_role_actions
                                            On sec_module_user_roles.role_id = sec_module_role_actions.role_id
                                        Where
                                            sec_module_user_roles.module_id = 'M16'
                                            And sec_module_user_roles.empno = v_empno)
                                        And (
                                            upper(itd.item_id) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(dac.sub_asset_type) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(dac.sap_assetcode) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(dac.model) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                            upper(dac.serialnum) Like '%' || upper(Trim(p_generic_search)) || '%'
                                        )
                                        And itt.trans_type_id    = Trim(p_trans_type_id)                                        
                                        And itd.item_id = ieim.item_id
                                        And itm.trans_id = ieim.trans_id
                                        And itm.empno = ieim.empno
                                        And itm.empno            = Trim(p_empno)

                                )
                            Order By trans_date Desc, item_id
                        )
                    Where
                        row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
            End If;
        Elsif p_trans_type_id = 'T01' Or p_trans_type_id = 'T02' Then
            Open c For
                Select
                    *
                From
                    (
                        Select
                            *
                        From
                            (
                                Select
                                    itd.trans_det_id,
                                    itd.trans_id,
                                    to_char(itm.trans_date, 'DD-Mon-YYYY')             As trans_date_string,
                                    itm.trans_date,
                                    Null                                               As barcode,
                                    iit.item_type_code || ' - ' || iit.item_type_desc  item_type_desc,
                                    itd.item_id,
                                    icd.mfg_id                                         item_details,
                                    Case itd.item_usable
                                        When 'Y' Then
                                            'Yes'
                                        When 'N' Then
                                            'No'
                                        When 'L' Then
                                            'Lost'
                                        Else
                                            itd.item_usable
                                    End                                                As item_usable,
                                    Case itt.trans_type_desc
                                        When 'RESERVE' Then
                                            1
                                        Else
                                            0
                                    End                                                As delete_item,
                                    itt.trans_type_desc                                As trans_type,
                                    Row_Number() Over (Order By itd.trans_det_id Desc) row_number,
                                    Count(*) Over ()                                   total_row
                                From
                                    inv_transaction_master itm,
                                    inv_transaction_detail itd,
                                    inv_transaction_types  itt,
                                    inv_consumables_master icm,
                                    inv_consumables_detail icd,
                                    inv_item_types         iit,
                                    inv_item_category      iic
                                Where
                                    itm.trans_id             = itd.trans_id
                                    And itm.trans_type_id    = itt.trans_type_id
                                    And iit.item_type_key_id = icm.item_type_key_id
                                    And icd.item_id          = itd.item_id
                                    And icm.consumable_id    = icd.consumable_id
                                    And iic.category_code    = iit.category_code
                                    and  iit.action_id in 
                                        (Select
                                            sec_module_role_actions.action_id
                                        From
                                            tcmpl_app_config.sec_module_user_roles
                                            Left Join tcmpl_app_config.sec_module_role_actions
                                            On sec_module_user_roles.role_id = sec_module_role_actions.role_id
                                        Where
                                            sec_module_user_roles.module_id = 'M16'
                                            And sec_module_user_roles.empno = v_empno)
                                    And (
                                        upper(itd.item_id) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(iic.category_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(iic.description) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(iit.item_type_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(iit.item_type_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                                    )
                                    And itt.trans_type_id In ('T01', 'T02')
                                    And itm.empno            = Trim(p_empno)

                                Union All

                                Select
                                    itd.trans_det_id,
                                    itd.trans_id,
                                    to_char(itm.trans_date, 'DD-Mon-YYYY')                   As trans_date_string,
                                    itm.trans_date,
                                    dac.barcode,
                                    iit.item_type_code || ' - ' || iit.item_type_desc        item_type_desc,
                                    itd.item_id,
                                    dac.model || ' - ' || dac.serialnum || ' - ' || compname item_details,
                                    Case itd.item_usable
                                        When 'Y' Then
                                            'Yes'
                                        When 'N' Then
                                            'No'
                                        When 'L' Then
                                            'Lost'
                                        Else
                                            itd.item_usable
                                    End                                                      As item_usable,
                                    Case itt.trans_type_desc
                                        When 'RESERVE' Then
                                            1
                                        Else
                                            0
                                    End                                                      As delete_item,
                                    itt.trans_type_desc                                      As trans_type,
                                    Row_Number() Over (Order By itd.trans_det_id Desc)       row_number,
                                    Count(*) Over ()                                         total_row
                                From
                                    inv_transaction_master     itm,
                                    inv_transaction_detail     itd,
                                    inv_transaction_types      itt,
                                    dm_assetcode               dac,
                                    inv_item_ams_asset_mapping iiaam,
                                    inv_item_types             iit
                                Where
                                    itm.trans_id             = itd.trans_id
                                    And itm.trans_type_id    = itt.trans_type_id
                                    And itd.item_id          = dac.barcode
                                    And dac.sub_asset_type   = iiaam.sub_asset_type
                                    And iit.item_type_key_id = iiaam.item_type_key_id
                                    and  iit.action_id in 
                                        (Select
                                            sec_module_role_actions.action_id
                                        From
                                            tcmpl_app_config.sec_module_user_roles
                                            Left Join tcmpl_app_config.sec_module_role_actions
                                            On sec_module_user_roles.role_id = sec_module_role_actions.role_id
                                        Where
                                            sec_module_user_roles.module_id = 'M16'
                                            And sec_module_user_roles.empno = v_empno)
                                    And (
                                        upper(itd.item_id) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(dac.sub_asset_type) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(dac.sap_assetcode) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(dac.model) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(dac.serialnum) Like '%' || upper(Trim(p_generic_search)) || '%'
                                    )
                                    And itt.trans_type_id In ('T01', 'T02')
                                    And itm.empno            = Trim(p_empno)

                            )
                        Order By trans_date Desc, item_id
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Else
            Open c For
                Select
                    *
                From
                    (
                        Select
                            *
                        From
                            (
                                Select
                                    itd.trans_det_id,
                                    itd.trans_id,
                                    to_char(itm.trans_date, 'DD-Mon-YYYY')            As trans_date_string,
                                    itm.modified_on,
                                    Null                                              As barcode,
                                    iit.item_type_code || ' - ' || iit.item_type_desc item_type_desc,
                                    itd.item_id,
                                    icd.mfg_id                                        item_details,
                                    Case itd.item_usable
                                        When 'Y' Then
                                            'Yes'
                                        When 'N' Then
                                            'No'
                                        When 'L' Then
                                            'Lost'
                                        Else
                                            itd.item_usable
                                    End                                               As item_usable,
                                    Case itt.trans_type_desc
                                        When 'RESERVE' Then
                                            1
                                        Else
                                            0
                                    End                                               As delete_item,
                                    itt.trans_type_desc                               As trans_type,
                                    Row_Number() Over (Order By itm.modified_on Desc) row_number,
                                    Count(*) Over ()                                  total_row
                                From
                                    inv_transaction_master itm,
                                    inv_transaction_detail itd,
                                    inv_transaction_types  itt,
                                    inv_consumables_master icm,
                                    inv_consumables_detail icd,
                                    inv_item_types         iit,
                                    inv_item_category      iic
                                Where
                                    itm.trans_id             = itd.trans_id
                                    And itm.trans_type_id    = itt.trans_type_id
                                    And iit.item_type_key_id = icm.item_type_key_id
                                    And icd.item_id          = itd.item_id
                                    And icm.consumable_id    = icd.consumable_id
                                    And iic.category_code    = iit.category_code
                                    and  iit.action_id in 
                                        (Select
                                            sec_module_role_actions.action_id
                                        From
                                            tcmpl_app_config.sec_module_user_roles
                                            Left Join tcmpl_app_config.sec_module_role_actions
                                            On sec_module_user_roles.role_id = sec_module_role_actions.role_id
                                        Where
                                            sec_module_user_roles.module_id = 'M16'
                                            And sec_module_user_roles.empno = v_empno)
                                    And (
                                        upper(itd.item_id) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(iic.category_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(iic.description) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(iit.item_type_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(iit.item_type_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                                    )
                                    And itm.empno            = Trim(p_empno)

                                Union All

                                Select
                                    itd.trans_det_id,
                                    itd.trans_id,
                                    to_char(itm.trans_date, 'DD-Mon-YYYY')                   As trans_date_string,
                                    itm.modified_on,
                                    dac.barcode,
                                    iit.item_type_code || ' - ' || iit.item_type_desc        item_type_desc,
                                    itd.item_id,
                                    dac.model || ' - ' || dac.serialnum || ' - ' || compname item_details,
                                    Case itd.item_usable
                                        When 'Y' Then
                                            'Yes'
                                        When 'N' Then
                                            'No'
                                        When 'L' Then
                                            'Lost'
                                        Else
                                            itd.item_usable
                                    End                                                      As item_usable,
                                    Case itt.trans_type_desc
                                        When 'RESERVE' Then
                                            1
                                        Else
                                            0
                                    End                                                      As delete_item,
                                    itt.trans_type_desc                                      As trans_type,
                                    Row_Number() Over (Order By itm.modified_on Desc)        row_number,
                                    Count(*) Over ()                                         total_row
                                From
                                    inv_transaction_master     itm,
                                    inv_transaction_detail     itd,
                                    inv_transaction_types      itt,
                                    dm_assetcode               dac,
                                    inv_item_ams_asset_mapping iiaam,
                                    inv_item_types             iit
                                Where
                                    itm.trans_id             = itd.trans_id
                                    And itm.trans_type_id    = itt.trans_type_id
                                    And itd.item_id          = dac.barcode
                                    And dac.sub_asset_type   = iiaam.sub_asset_type
                                    And iit.item_type_key_id = iiaam.item_type_key_id
                                    and  iit.action_id in 
                                        (Select
                                            sec_module_role_actions.action_id
                                        From
                                            tcmpl_app_config.sec_module_user_roles
                                            Left Join tcmpl_app_config.sec_module_role_actions
                                            On sec_module_user_roles.role_id = sec_module_role_actions.role_id
                                        Where
                                            sec_module_user_roles.module_id = 'M16'
                                            And sec_module_user_roles.empno = v_empno)
                                    And (
                                        upper(itd.item_id) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(dac.sub_asset_type) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(dac.sap_assetcode) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(dac.model) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                        upper(dac.serialnum) Like '%' || upper(Trim(p_generic_search)) || '%'
                                    )
                                    And itm.empno            = Trim(p_empno)

                            )
                        Order By modified_on Desc
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        End If;
        Return c;
    End fn_employee_transactions_detail_list;

    Function fn_consumable_details_get(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_item_id        Varchar2
    ) Return Varchar2 is
        v_item_details   Varchar2(125);
    Begin
        Select 
            icm.consumable_desc || ' - ' || icd.mfg_id 
        Into 
            v_item_details
        From inv_consumables_master icm, 
             inv_consumables_detail icd
        Where 
            icd.consumable_id = icm.consumable_id
                And icd.item_id = Trim(p_item_id);
        Return v_item_details;
    Exception
        When Others Then
            Return Null;
    End;

End pkg_inv_transactions_det_qry;
/
Grant Execute On "DMS"."PKG_INV_TRANSACTIONS_DET_QRY" To "TCMPL_APP_CONFIG";