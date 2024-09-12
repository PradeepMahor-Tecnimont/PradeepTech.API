------------------------------------------------------
--  DDL for Package Body PKG_INV_TRANSACTIONS_QRY
------------------------------------------------------

Create Or Replace Package Body dms.pkg_inv_transactions_qry As

    Function fn_transactions_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_generic_search     Varchar2(100);
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_generic_search Is Not Null Then
            v_generic_search := '%' || upper(p_generic_search) || '%';
        Else
            v_generic_search := '%';
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        itm.trans_id,
                        itm.trans_date,
                        itm.empno,
                        e.name                                           As emp_name,
                        e.parent,
                        c1.name                                          As parent_name,
                        e.assign,
                        c.name                                           As assign_name,
                        itt.trans_type_desc,
                        Row_Number() Over (Order By itm.trans_date Desc) row_number,
                        Count(*) Over ()                                 total_row
                    From
                        inv_transaction_master itm,
                        inv_transaction_types  itt,
                        ss_emplmast            e,
                        ss_costmast            c,
                        ss_costmast            c1
                    Where
                        itm.empno = e.empno
                        And itm.trans_type_id = itt.trans_type_id
                        And e.assign = c.costcode
                        And e.parent = c1.costcode
                        And
                        (
                            itm.empno Like v_generic_search
                            Or e.name Like v_generic_search
                            Or e.parent Like v_generic_search
                            Or c1.name Like v_generic_search
                            Or e.assign Like v_generic_search
                            Or c.name Like v_generic_search
                            Or upper(itt.trans_type_desc) Like v_generic_search)
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_transactions_list;

    Procedure sp_transaction_details(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_trans_id             Varchar2,
        p_trans_date       Out Date,
        p_empno            Out Varchar2,
        p_emp_name         Out Varchar2,
        p_parent           Out Varchar2,
        p_parent_name      Out Varchar2,
        p_assign           Out Varchar2,
        p_assign_name      Out Varchar2,
        p_trans_type_id    Out Varchar2,
        p_trans_type_desc  Out Varchar2,
        p_remarks          Out Varchar2,
        p_gate_pass_ref_no Out Varchar2,

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
            itm.trans_date,
            itm.empno,
            e.name  As emp_name,
            e.parent,
            c1.name As parent_name,
            e.assign,
            c.name  As assign_name,
            itm.trans_type_id,
            itt.trans_type_desc,
            itm.remarks,
            itm.gate_pass
        Into
            p_trans_date,
            p_empno,
            p_emp_name,
            p_parent,
            p_parent_name,
            p_assign,
            p_assign_name,
            p_trans_type_id,
            p_trans_type_desc,
            p_remarks,
            p_gate_pass_ref_no
        From
            inv_transaction_master itm,
            inv_transaction_types  itt,
            ss_emplmast            e,
            ss_costmast            c,
            ss_costmast            c1
        Where
            itm.empno = e.empno
            And itm.trans_type_id = itt.trans_type_id
            And e.assign = c.costcode
            And e.parent = c1.costcode
            And itm.trans_id = Trim(p_trans_id);

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_transaction_details;

    Function fn_transactions_list_excel(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                Sys_Refcursor;
        v_generic_search Varchar2(100);
    Begin
        If p_generic_search Is Not Null Then
            v_generic_search := '%' || upper(p_generic_search) || '%';
        Else
            v_generic_search := '%';
        End If;

        Open c For

            Select
                to_char(itm.trans_date, 'DD-Mon-YYYY')            trans_date,
                itm.empno,
                e.name                                            As emp_name,
                e.parent,
                c1.name                                           As parent_name,
                e.assign,
                c.name                                            As assign_name,
                itt.trans_type_desc,
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
                End                                               As item_usable
            From
                inv_transaction_master itm,
                inv_transaction_types  itt,
                inv_transaction_detail itd,
                inv_consumables_master icm,
                inv_consumables_detail icd,
                inv_item_types         iit,
                ss_emplmast            e,
                ss_costmast            c,
                ss_costmast            c1
            Where
                itm.empno = e.empno
                And itm.trans_type_id = itt.trans_type_id
                And itm.trans_id = itd.trans_id
                And e.assign = c.costcode
                And e.parent = c1.costcode
                And icd.item_id = itd.item_id
                And icm.consumable_id = icd.consumable_id
                And iit.item_type_key_id = icm.item_type_key_id
                And
                (
                    itm.empno Like v_generic_search
                    Or e.name Like v_generic_search
                    Or e.parent Like v_generic_search
                    Or c1.name Like v_generic_search
                    Or e.assign Like v_generic_search
                    Or c.name Like v_generic_search
                    Or upper(itt.trans_type_desc) Like v_generic_search
                )

            Union All

            Select
                to_char(itm.trans_date, 'DD-Mon-YYYY')                   trans_date,
                itm.empno,
                e.name                                                   As emp_name,
                e.parent,
                c1.name                                                  As parent_name,
                e.assign,
                c.name                                                   As assign_name,
                itt.trans_type_desc,
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
                End                                                      As item_usable
            From
                inv_transaction_master     itm,
                inv_transaction_types      itt,
                inv_transaction_detail     itd,
                dm_assetcode               dac,
                inv_item_ams_asset_mapping iiaam,
                inv_item_types             iit,
                ss_emplmast                e,
                ss_costmast                c,
                ss_costmast                c1
            Where
                itm.empno = e.empno
                And itm.trans_type_id = itt.trans_type_id
                And itm.trans_id = itd.trans_id
                And e.assign = c.costcode
                And e.parent = c1.costcode
                And itd.item_id = dac.barcode
                And dac.sub_asset_type = iiaam.sub_asset_type
                And iit.item_type_key_id = iiaam.item_type_key_id
                And
                (
                    itm.empno Like v_generic_search
                    Or e.name Like v_generic_search
                    Or e.parent Like v_generic_search
                    Or c1.name Like v_generic_search
                    Or e.assign Like v_generic_search
                    Or c.name Like v_generic_search
                    Or upper(itt.trans_type_desc) Like v_generic_search
                )

            Order By
                1 Desc,
                2;

        Return c;
    End fn_transactions_list_excel;

    Function fn_employee_transactions_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c                Sys_Refcursor;
        v_generic_search Varchar2(100);
    Begin
        If p_generic_search Is Not Null Then
            v_generic_search := '%' || upper(p_generic_search) || '%';
        Else
            v_generic_search := '%';
        End If;
        Open c For
            Select
                *
            From
                (
                    Select
                        e.empno,
                        e.name                               As emp_name,
                        e.parent,
                        c1.name                              As parent_name,
                        e.assign,
                        c.name                               As assign_name,
                        Case e.status
                            When 1 Then
                                'Yes'
                            Else
                                'No'
                        End                                  As active,
                        Row_Number() Over (Order By e.empno) row_number,
                        Count(*) Over ()                     total_row
                    From
                        ss_emplmast e,
                        ss_costmast c,
                        ss_costmast c1
                    Where
                        e.assign = c.costcode
                        And e.parent = c1.costcode
                        And e.empno In (
                            Select
                                empno
                            From
                                inv_transaction_master
                        )
                        And
                        (
                            e.empno Like v_generic_search
                            Or e.name Like v_generic_search
                            Or e.parent Like v_generic_search
                            Or c1.name Like v_generic_search
                            Or e.assign Like v_generic_search
                            Or c.name Like v_generic_search
                        )
                    Order By e.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_employee_transactions_list;

    Procedure sp_employee_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_emp_name     Out Varchar2,
        p_parent       Out Varchar2,
        p_parent_name  Out Varchar2,
        p_assign       Out Varchar2,
        p_assign_name  Out Varchar2,
        p_active       Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
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
            e.name  As emp_name,
            e.parent,
            c1.name As parent_name,
            e.assign,
            c.name  As assign_name,
            Case e.status
                When 1 Then
                    'Yes'
                Else
                    'No'
            End     As active
        Into
            p_emp_name,
            p_parent,
            p_parent_name,
            p_assign,
            p_assign_name,
            p_active
        From
            ss_emplmast e,
            ss_costmast c,
            ss_costmast c1
        Where
            e.assign = c.costcode
            And e.parent = c1.costcode
            And e.empno = Trim(p_empno);

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_employee_details;

    Function fn_reserve_items_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_generic_search     Varchar2(100);
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_generic_search Is Not Null Then
            v_generic_search := '%' || upper(p_generic_search) || '%';
        Else
            v_generic_search := '%';
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        itm.trans_id,
                        itm.trans_date,
                        itm.empno,
                        e.name                                           As emp_name,
                        e.parent,
                        c1.name                                          As parent_name,
                        e.assign,
                        c.name                                           As assign_name,
                        itt.trans_type_desc,
                        Row_Number() Over (Order By itm.trans_date Desc) row_number,
                        Count(*) Over ()                                 total_row
                    From
                        inv_transaction_master itm,
                        inv_transaction_types  itt,
                        ss_emplmast            e,
                        ss_costmast            c,
                        ss_costmast            c1
                    Where
                        itm.empno = e.empno
                        And itm.trans_type_id = itt.trans_type_id
                        And e.assign = c.costcode
                        And e.parent = c1.costcode
                        And itm.trans_type_id = c_reserve_trans_type_id
                        And
                        (
                            itm.empno Like v_generic_search
                            Or e.name Like v_generic_search
                            Or e.parent Like v_generic_search
                            Or c1.name Like v_generic_search
                            Or e.assign Like v_generic_search
                            Or c.name Like v_generic_search
                            Or upper(itt.trans_type_desc) Like v_generic_search
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_reserve_items_list;

End pkg_inv_transactions_qry;
/
Grant Execute On dms.pkg_inv_transactions_qry To tcmpl_app_config;