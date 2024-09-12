--------------------------------------------------------
--  DDL for Package Body PKG_DMS_AREA_CATEGORIES_QRY
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_DMS_AREA_CATEGORIES_QRY" As

    Function fn_area_categories(
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
                        dac.area_catg_code                                                                                As
                        area_catg_code,
                        dac.description                                                                                   As
                        area_description,
                        pkg_dms_desk_areas_qry.fn_check_area_catg_code_exists(p_person_id, p_meta_id, dac.area_catg_code)
                        As area_catg_code_count,
                        Row_Number() Over (Order By dac.area_catg_code Desc)                                              row_number,
                        Count(*) Over ()                                                                                  total_row
                    From
                        dm_desk_area_categories dac
                    Where
                        (
                            upper(dac.area_catg_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(dac.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_area_categories;

    Function fn_xl_download_area_categories(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                a.area_catg_code As area_catg_code,
                a.description    As area_description
            From
                dm_desk_area_categories a
            Where
                (
                    upper(a.area_catg_code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                )
            Order By a.area_catg_code;
        Return c;
    End fn_xl_download_area_categories;

    Procedure sp_area_categories_details(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_area_catg_code       Varchar2,
        p_area_description Out Varchar2,

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
         
            a.description As area_description
        Into
            p_area_description
        From
            dm_desk_area_categories a
        Where
            a.area_catg_code = p_area_catg_code;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_area_categories_details;

End pkg_dms_area_categories_qry;
/
Grant Execute On "DMS"."PKG_DMS_AREA_CATEGORIES_QRY" To "TCMPL_APP_CONFIG";