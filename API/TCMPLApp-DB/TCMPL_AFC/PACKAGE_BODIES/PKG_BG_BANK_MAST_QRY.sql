--------------------------------------------------------
--  DDL for Package Body PKG_BG_BANK_MAST_QRY
--------------------------------------------------------

Create Or Replace Package Body tcmpl_afc."PKG_BG_BANK_MAST_QRY" As

    Function fn_bank_mast(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_bank_name   Varchar2 Default Null,
        p_is_visible  Number   Default Null,
        p_is_deleted  Number   Default Null,
        p_generic_search Varchar2 Default Null,
        
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
                        bank.bankid                                               As application_id,
                        bank.bankname                                             As bank_name,
                        company.domain || ' - ' || company.compdesc               As comp,
                        bank.isvisible                                            As is_visible,
                        bank.isdeleted                                            As is_deleted,
                        bank.modifiedby || ' : ' || get_emp_name(bank.modifiedby) As modified_by,
                        pkg_bg_common.fn_bg_get_bank_occur_count(bank.bankid)     As bank_count,
                        to_char(bank.modifiedon, 'DD-MON-yyyy')                   As modified_on,
                        Row_Number() Over (Order By bank.bankid Desc)             row_number,
                        Count(*) Over ()                                          total_row
                    From
                        bg_bank_mast bank, bg_company_mast company
                    Where
                        bank.comp     = company.compid
                        And bank.bankname  = nvl(p_bank_name, bank.bankname)
                        And bank.isvisible = nvl(p_is_visible, bank.isvisible)
                        And bank.isdeleted = nvl(p_is_deleted, bank.isdeleted)
                        And (upper(bank.bankid) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                             upper(bank.bankname) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                             upper(company.domain) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                             upper(company.compdesc) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                             upper(bank.modifiedby) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                             upper(get_emp_name(bank.modifiedby)) Like '%' || upper(Trim(p_generic_search)) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_bank_mast;

    Procedure sp_bank_mast_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_bank_id          Varchar2,

        p_bank_name    Out Varchar2,
        p_comp         Out Varchar2,
        p_is_visible   Out Number,
        p_is_deleted   Out Number,
        p_modified_by  Out Varchar2,
        p_modified_on  Out Varchar2,

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
            bankname                                        As bank_name,
            comp                                            As comp,
            isvisible                                       As is_visible,
            isdeleted                                       As is_deleted,
            modifiedby || ' : ' || get_emp_name(modifiedby) As modified_by,
            to_char(modifiedon, 'DD-MON-yyyy')              As modified_on

        Into
            p_bank_name,
            p_comp,
            p_is_visible,
            p_is_deleted,
            p_modified_by,
            p_modified_on
        From
            bg_bank_mast
        Where
            bankid = p_bank_id;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_bank_mast_details;

End pkg_bg_bank_mast_qry;
/
Grant Execute On "TCMPL_AFC"."PKG_BG_BANK_MAST_QRY" To "TCMPL_APP_CONFIG";