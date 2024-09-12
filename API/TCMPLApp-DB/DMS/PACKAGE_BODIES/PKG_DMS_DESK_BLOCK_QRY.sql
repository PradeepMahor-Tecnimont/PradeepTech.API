Create Or Replace Package Body "DMS"."PKG_DMS_DESK_BLOCK_QRY" As

    Function fn_desk_block_list(
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
                        dl.deskid,
                        dl.unqid                               As remarks,
                        dlr.description,
                        Row_Number() Over (Order By dl.deskid) row_number,
                        Count(*) Over ()                       total_row
                    From
                        dm_desklock        dl,
                        dm_desklock_reason dlr
                    Where
                        dl.blockreason = dlr.reasoncode
                        And dl.empno   = 'Y'
                        And (
                            upper(dl.deskid) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(dl.unqid) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(dlr.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_desk_block_list;

    Function fn_xl_download_desk_block(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                dl.deskid,
                dl.unqid As remarks,
                dlr.description
            From
                dm_desklock        dl,
                dm_desklock_reason dlr
            Where
                dl.blockreason = dlr.reasoncode
                And dl.empno   = 'Y'
                And (
                    upper(dl.deskid) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(dl.unqid) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(dlr.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                )
            Order By
                dl.deskid;

        Return c;
    End fn_xl_download_desk_block;

    Procedure sp_desk_block_detail(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_deskid           Varchar2,
        p_remarks      Out Varchar2,
        p_reasoncode   Out Number,
        p_description  Out Varchar2,
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
            dl.unqid        As remarks,
            dl.blockreason  As reasoncode,
            dlr.description As description
        Into
            p_remarks,
            p_reasoncode,
            p_description
        From
            dm_desklock        dl,
            dm_desklock_reason dlr
        Where
            dl.blockreason      = dlr.reasoncode
            And Trim(dl.deskid) = Trim(p_deskid);

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_desk_block_detail;

End pkg_dms_desk_block_qry;
/

Grant Execute On "DMS"."PKG_DMS_DESK_BLOCK_QRY" To "TCMPL_APP_CONFIG";