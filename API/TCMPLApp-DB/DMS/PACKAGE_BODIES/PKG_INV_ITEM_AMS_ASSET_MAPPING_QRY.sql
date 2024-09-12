--------------------------------------------------------
--  DDL for Package Body PKG_INV_AMS_ASSET_MAPPING_QRY
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_AMS_ASSET_MAPPING_QRY" As

    Function fn_ams_asset_mapping(
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
                      a.key_id                                        As key_id,
                        a.item_type_key_id                                   As item_type_key_id,
                        b.item_type_code                                     As item_type_code,
                        b.category_code                                      As category_code,
                        b.item_assignment_type || ': ' || e.asgmt_desc       As item_assignment_type,
                        b.item_type_desc                                     As item_type_desc,
                        a.sub_asset_type                                     As sub_asset_type,
                        c.description                                        As sub_asset_type_desc,
                        a.is_active                                          As is_active_val,
                        Case a.is_active
                            When 1 Then
                                'Active'
                            When 0 Then
                                'De-Active'
                            Else
                                'Error'
                        End                                                  As is_active_text,
                        to_char(a.modified_on, 'dd-Mon-yyyy')                As modified_on,
                        a.modified_by || ' : ' || d.name                     As modified_by,
                        Row_Number() Over (Order By a.item_type_key_id Desc) row_number,
                        Count(*) Over ()                                     total_row
                    From
                        inv_item_ams_asset_mapping a,
                        inv_item_types             b,
                        ams.as_sub_asset_type      c,
                        ss_emplmast                d,
                        inv_item_asgmt_types       e
                    Where
                        a.sub_asset_type       = c.sub_asset_type
                        And a.modified_by      = d.empno
                        And a.item_type_key_id = b.item_type_key_id
                        And e.asgmt_code       = b.item_assignment_type
                        And (
                            upper(b.item_type_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.is_active) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_ams_asset_mapping;

    Function fn_xl_ams_asset_mapping(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
              a.key_id                             As key_id,
                a.item_type_key_id                        As item_type_key_id,
                b.item_type_code                          As item_type_code,
                b.category_code                           As category_code,
                b.item_assignment_type                    As item_assignment_type,
                b.item_type_desc                          As item_type_desc,
                a.sub_asset_type                          As sub_asset_type,
                c.sub_asset_type || ': ' || c.description As sub_asset_type_desc,
                a.is_active                               As is_active_val,
                Case a.is_active
                    When 1 Then
                        'Active'
                    When 0 Then
                        'De-Active'
                    Else
                        'Error'
                End                                       As is_active_text,
                to_char(a.modified_on, 'dd-Mon-yyyy')     As modified_on,
                a.modified_by || ' : ' || d.name          As modified_by
            From
                inv_item_ams_asset_mapping a,
                inv_item_types             b,
                ams.as_sub_asset_type      c,
                ss_emplmast                d
            Where
                a.sub_asset_type       = c.sub_asset_type
                And a.modified_by      = d.empno
                And a.item_type_key_id = b.item_type_key_id
                And (
                    upper(b.item_type_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.is_active) Like '%' || upper(Trim(p_generic_search)) || '%'
                )
            Order By
                a.item_type_key_id;
        Return c;
    End fn_xl_ams_asset_mapping;

    Procedure sp_ams_asset_mapping_details(
        p_person_id                Varchar2,
        p_meta_id                  Varchar2,

        p_key_id                   Varchar2,
        p_item_type_key_id     Out Varchar2,
        p_item_type_code       Out Varchar2,
        p_category_code        Out Varchar2,
        p_item_assignment_type Out Varchar2,
        p_item_type_desc       Out Varchar2,
        p_sub_asset_type       Out Varchar2,
        p_sub_asset_type_desc  Out Varchar2,
        p_is_active_val        Out Varchar2,
        p_is_active_text       Out Varchar2,
        p_modified_on          Out Varchar2,
        p_modified_by          Out Varchar2,

        p_message_type         Out Varchar2,
        p_message_text         Out Varchar2
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
         
            a.item_type_key_id                        As item_type_key_id,
            b.item_type_code                          As item_type_code,
            b.category_code                           As category_code,
            b.item_assignment_type                    As item_assignment_type,
            b.item_type_desc                          As item_type_desc,
            a.sub_asset_type                          As sub_asset_type,
            c.sub_asset_type || ': ' || c.description As sub_asset_type_desc,
            a.is_active                               As is_active_val,
            Case a.is_active
                When 1 Then
                    'Active'
                When 0 Then
                    'De-Active'
                Else
                    'Error'
            End                                       As is_active_text,
            to_char(a.modified_on, 'dd-Mon-yyyy')     As modified_on,
            a.modified_by || ' : ' || d.name          As modified_by

        Into
            p_item_type_key_id,
            p_item_type_code,
            p_category_code,
            p_item_assignment_type,
            p_item_type_desc,
            p_sub_asset_type,
            p_sub_asset_type_desc,
            p_is_active_val,
            p_is_active_text,
            p_modified_on,
            p_modified_by
        From
            inv_item_ams_asset_mapping a,
            inv_item_types             b,
            ams.as_sub_asset_type      c,
            ss_emplmast                d
        Where
            a.key_id               = p_key_id
            And a.sub_asset_type   = c.sub_asset_type
            And a.modified_by      = d.empno
            And a.item_type_key_id = b.item_type_key_id;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_ams_asset_mapping_details;

End pkg_inv_ams_asset_mapping_qry;
/
Grant Execute On "DMS"."PKG_INV_AMS_ASSET_MAPPING_QRY" To "TCMPL_APP_CONFIG";
--Grant select On "AMS"."AS_SUB_ASSET_TYPE" To "TCMPL_APP_CONFIG";