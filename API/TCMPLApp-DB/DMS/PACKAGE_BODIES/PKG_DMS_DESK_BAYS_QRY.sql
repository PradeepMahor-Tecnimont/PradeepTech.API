--------------------------------------------------------
--  DDL for Package Body PKG_DMS_DESK_BAYS_QRY
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_DMS_DESK_BAYS_QRY" As

    Function fn_desk_bays(
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
                        a.bay_key_id                                   As bay_id,
                        a.bay_desc                                     As bay_desc,
                        pkg_dms_masters_qry.fn_check_bay_exists(p_person_id, p_meta_id, a.bay_desc) as bay_count,
                        Row_Number() Over (Order By a.bay_key_id Desc) row_number,
                        Count(*) Over ()                               total_row
                    From
                        dm_desk_bays a
                    Where
                        (
                            upper(a.bay_key_id) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.bay_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_desk_bays;

    Function fn_xl_download_desk_bays(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select            
                a.bay_key_id As bay_id,
                a.bay_desc   As bay_desc
            From
                dm_desk_bays a
            Where
                (
                    upper(a.bay_key_id) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.bay_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                )
            Order By a.bay_key_id;
        Return c;
    End fn_xl_download_desk_bays;

    Procedure sp_desk_bays_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_bay_id           Varchar2,
        p_bay_desc     Out Varchar2,

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
          
            a.bay_desc As bay_desc
        Into
            p_bay_desc
        From
            dm_desk_bays a
        Where
            a.bay_key_id = p_bay_id;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_desk_bays_details;

End pkg_dms_desk_bays_qry;
/
Grant Execute On "DMS"."PKG_DMS_DESK_BAYS_QRY" To "TCMPL_APP_CONFIG";