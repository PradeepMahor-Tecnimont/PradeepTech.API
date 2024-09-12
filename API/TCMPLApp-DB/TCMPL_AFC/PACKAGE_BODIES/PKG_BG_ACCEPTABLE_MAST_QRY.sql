--------------------------------------------------------
--  DDL for Package Body PKG_BG_ACCEPTABLE_MAST_QRY
--------------------------------------------------------

Create Or Replace Package Body tcmpl_afc."PKG_BG_ACCEPTABLE_MAST_QRY" As

    Function fn_acceptable(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_is_visible  Number Default Null,
        p_is_deleted  Number Default Null,

        p_row_number  Number,
        p_page_length Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        acceptableid                                    As application_id,
                        accetablename                                   As acceptable_name,
                        isvisible                                       As is_visible,
                        isdeleted                                       As is_deleted,
                        modifiedby || ' : ' || get_emp_name(modifiedby) As modified_by,
                        to_char(modifiedon, 'DD-MON-yyyy')              As modified_on,
                        Row_Number() Over (Order By acceptableid Desc)  row_number,
                        Count(*) Over ()                                total_row
                    From
                        bg_acceptable_mast
                    Where
                        isvisible     = nvl(p_is_visible, isvisible)
                        And isdeleted = nvl(p_is_deleted, isdeleted)

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_acceptable;

    Procedure sp_acceptable_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_acceptable_id       Varchar2,

        p_acceptable_name Out Varchar2,
        p_is_visible      Out Number,
        p_is_deleted      Out Number,
        p_modified_by     Out Varchar2,
        p_modified_on     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
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
            accetablename,
            isvisible,
            isdeleted,
            modifiedby || ' : ' || get_emp_name(modifiedby),
            to_char(modifiedon, 'DD-MON-yyyy')
        Into
            p_acceptable_name,
            p_is_visible,
            p_is_deleted,
            p_modified_by,
            p_modified_on
        From
            bg_acceptable_mast
        Where
            acceptableid = p_acceptable_id;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_acceptable_details;

End pkg_bg_acceptable_mast_qry;
/
Grant Execute On "TCMPL_AFC"."PKG_BG_ACCEPTABLE_MAST_QRY" To "TCMPL_APP_CONFIG";