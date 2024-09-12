--------------------------------------------------------
--  DDL for Package Body PKG_INV_ITEM_CATEGORY_QRY
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_ITEM_CATEGORY_QRY" As

    Function fn_item_category(
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
                        a.category_code                                   As category_code,
                        a.description                                     As category_desc,
                        a.is_active                                       As is_active_val,
                        Case a.is_active
                            When 1 Then
                                'Active'
                            When 0 Then
                                'De-Active'
                            Else
                                'Error'
                        End                                               As is_active_text,
                        to_char(a.modified_on, 'dd-Mon-yyyy')             As modified_on,
                        a.modified_by || ' : ' || b.name                  As modified_by,
                        Row_Number() Over (Order By a.category_code Desc) row_number,
                        Count(*) Over ()                                  total_row
                    From
                        inv_item_category                a, ss_emplmast b
                    Where
                        a.modified_by = b.empno
                        And (
                            upper(a.category_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_item_category;

    Function fn_xl_item_category(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                a.category_code                       As category_code,
                a.description                         As category_desc,
                a.is_active                           As is_active_val,
                Case a.is_active
                    When 1 Then
                        'Active'
                    When 0 Then
                        'De-Active'
                    Else
                        'Error'
                End                                   As is_active_text,
                to_char(a.modified_on, 'dd-Mon-yyyy') As modified_on,
                a.modified_by || ' : ' || b.name      As modified_by
            From
                inv_item_category                a, ss_emplmast b
            Where
                a.modified_by = b.empno
                And (
                    upper(a.category_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                )
            Order By
                a.category_code;
        Return c;
    End fn_xl_item_category;

    Procedure sp_item_category_details(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_key_id                 Varchar2,
        p_item_category_desc Out Varchar2,
        p_is_active_val      Out Number,
        p_is_active_text     Out Varchar2,
        p_modified_on        Out Varchar2,
        p_modified_by        Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
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
         
            a.description                         As category_desc,
            a.is_active                           As is_active_val,
            Case a.is_active
                When 1 Then
                    'Active'
                When 0 Then
                    'De-Active'
                Else
                    'Error'
            End                                   As is_active_text,
            to_char(a.modified_on, 'dd-Mon-yyyy') As modified_on,

            a.modified_by || ' : ' || d.name      As modified_by

        Into
            p_item_category_desc,
            p_is_active_val,
            p_is_active_text,
            p_modified_on,
            p_modified_by
        From
            inv_item_category                a, ss_emplmast d
        Where
            a.category_code = p_key_id
            And d.empno     = a.modified_by;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_item_category_details;

End pkg_inv_item_category_qry;
/
Grant Execute On "DMS"."PKG_INV_ITEM_CATEGORY_QRY" To "TCMPL_APP_CONFIG";