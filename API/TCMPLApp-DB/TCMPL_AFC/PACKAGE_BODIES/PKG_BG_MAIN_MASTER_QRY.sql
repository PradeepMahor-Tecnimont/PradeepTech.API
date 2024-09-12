create or replace Package Body tcmpl_afc.pkg_bg_main_master_qry As

    Function fn_bg_master_list(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,
        p_generic_search     Varchar2,
        p_row_number         Number,
        p_page_length        Number,
        p_projno             Varchar2 Default Null,
        p_bgtype             Varchar2 Default Null,
        p_bg_from_date       Date     Default Null,
        p_bg_to_date         Date     Default Null,
        p_bg_val_from_date   Date     Default Null,
        p_bg_val_to_date     Date     Default Null,
        p_bg_claim_from_date Date     Default Null,
        p_bg_claim_to_date   Date Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        v_count              Number;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Select
            Count(projno)
        Into
            v_count
        From
            vu_projmast
        Where
            prjmngr = Trim(v_empno);

        If v_count = 0 Then
            Open c For
                Select
                    *
                From
                    (
                        Select
                            refnum,
                            bgnum,
                            bgdate,
                            projnum,
                            pkg_bg_common.fn_bg_get_project_name(projnum)                projname,
                            ponum,
                            pkg_bg_common.fn_bg_get_issued_by_name(issueby)              issuebyname,
                            pkg_bg_common.fn_bg_get_issued_to_name(issueto)              issuetoname,
                            bgvaldt,
                            bgclmdt,
                            bgtype,
                            pkg_bg_common.fn_bg_get_bank_name(bankid)                    bankname,
                            remarks,
                            compid,
                            pkg_bg_common.fn_bg_get_company_name(compid)                 companyname,
                            released,
                            reldt,
                            reldetails,
                            pkg_bg_main_status_qry.sp_bg_get_current_status_desc(refnum) status,
                            Row_Number() Over (Order By refnum Desc)                     row_number,
                            Count(*) Over ()                                             total_row
                        From
                            bg_main_master
                        Where
                            isdelete    = 0
                            And (upper(bgnum) Like upper('%' || Trim(p_generic_search) || '%') Or
                                upper(ponum) Like upper('%' || Trim(p_generic_search) || '%') Or
                                upper(pkg_bg_common.fn_bg_get_issued_by_name(issueby)) Like upper('%' || Trim(p_generic_search) ||
                                '%') Or
                                upper(pkg_bg_common.fn_bg_get_issued_to_name(issueto)) Like upper('%' || Trim(p_generic_search) ||
                                '%') Or
                                upper(bgtype) Like upper('%' || Trim(p_generic_search) || '%') Or
                                upper(pkg_bg_common.fn_bg_get_bank_name(bankid)) Like upper('%' || Trim(p_generic_search) ||
                                '%')
                                Or
                                upper(compid) Like upper('%' || Trim(p_generic_search) || '%') Or
                                upper(pkg_bg_common.fn_bg_get_company_name(compid)) Like upper('%' || Trim(p_generic_search) ||
                                '%') Or
                                upper(remarks) Like upper('%' || Trim(p_generic_search) || '%') Or
                                upper(reldetails) Like upper('%' || Trim(p_generic_search) || '%'))
                            And projnum = nvl(p_projno, projnum)
                            And bgtype  = nvl(p_bgtype, bgtype)
                            And (bgdate Between nvl(p_bg_from_date, bgdate) And nvl(p_bg_to_date, bgdate))
                            And (bgvaldt Between nvl(p_bg_val_from_date, bgvaldt) And nvl(p_bg_val_to_date, bgvaldt))
                            And (bgclmdt Between nvl(p_bg_claim_from_date, bgclmdt) And nvl(p_bg_claim_to_date, bgclmdt))

                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
                Order By
                    refnum Desc;
        Else
            Open c For
                Select
                    *
                From
                    (
                        Select
                            refnum,
                            bgnum,
                            bgdate,
                            projnum,
                            pkg_bg_common.fn_bg_get_project_name(projnum)                projname,
                            ponum,
                            pkg_bg_common.fn_bg_get_issued_by_name(issueby)              issuebyname,
                            pkg_bg_common.fn_bg_get_issued_to_name(issueto)              issuetoname,
                            bgvaldt,
                            bgclmdt,
                            bgtype,
                            pkg_bg_common.fn_bg_get_bank_name(bankid)                    bankname,
                            remarks,
                            compid,
                            pkg_bg_common.fn_bg_get_company_name(compid)                 companyname,
                            released,
                            reldt,
                            reldetails,
                            pkg_bg_main_status_qry.sp_bg_get_current_status_desc(refnum) status,
                            Row_Number() Over (Order By refnum Desc)                     row_number,
                            Count(*) Over ()                                             total_row
                        From
                            bg_main_master
                        Where
                            isdelete    = 0
                            And projnum In (
                                Select
                                    substr(projno, 1, 5)
                                From
                                    vu_projmast
                                Where
                                    prjmngr = Trim(v_empno)
                            )
                            And (upper(bgnum) Like upper('%' || Trim(p_generic_search) || '%') Or
                                upper(ponum) Like upper('%' || Trim(p_generic_search) || '%') Or
                                upper(pkg_bg_common.fn_bg_get_issued_by_name(issueby)) Like upper('%' || Trim(p_generic_search) ||
                                '%') Or
                                upper(pkg_bg_common.fn_bg_get_issued_to_name(issueto)) Like upper('%' || Trim(p_generic_search) ||
                                '%') Or
                                upper(bgtype) Like upper('%' || Trim(p_generic_search) || '%') Or
                                upper(pkg_bg_common.fn_bg_get_bank_name(bankid)) Like upper('%' || Trim(p_generic_search) ||
                                '%')
                                Or
                                upper(compid) Like upper('%' || Trim(p_generic_search) || '%') Or
                                upper(pkg_bg_common.fn_bg_get_company_name(compid)) Like upper('%' || Trim(p_generic_search) ||
                                '%') Or
                                upper(remarks) Like upper('%' || Trim(p_generic_search) || '%') Or
                                upper(reldetails) Like upper('%' || Trim(p_generic_search) || '%'))
                            And projnum = nvl(p_projno, projnum)
                            And bgtype  = nvl(p_bgtype, bgtype)
                            And (bgdate Between nvl(p_bg_from_date, bgdate) And nvl(p_bg_to_date, bgdate))
                            And (bgvaldt Between nvl(p_bg_val_from_date, bgvaldt) And nvl(p_bg_val_to_date, bgvaldt))
                            And (bgclmdt Between nvl(p_bg_claim_from_date, bgclmdt) And nvl(p_bg_claim_to_date, bgclmdt))

                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
                Order By
                    refnum Desc;
        End If;
        Return c;
    End fn_bg_master_list;

    Procedure sp_bg_master_detail(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        p_refnum            Varchar2,
        p_bgnum         Out Varchar2,
        p_bgdate        Out Varchar2,
        p_compid        Out Varchar2,
        p_compdesc      Out Varchar2,
        p_bgtype        Out Varchar2,
        p_ponum         Out Varchar2,
        p_projnum       Out Varchar2,
        p_projname      Out Varchar2,
        p_issuebyid     Out Varchar2,
        p_issuebyname   Out Varchar2,
        p_issuetoid     Out Varchar2,
        p_issuetoname   Out Varchar2,
        p_bgvaldt       Out Varchar2,
        p_bgclmdt       Out Varchar2,
        p_bankid        Out Varchar2,
        p_bankname      Out Varchar2,
        p_remarks       Out Varchar2,
        p_released      Out Varchar2,
        p_released_desc Out Varchar2,
        p_reldt         Out Varchar2,
        p_reldetails    Out Varchar2,
        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
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
            bgnum,
            bgdate,
            compid,
            pkg_bg_common.fn_bg_get_company_name(compid)    compdesc,
            bgtype,
            ponum,
            projnum,
            pkg_bg_common.fn_bg_get_project_name(projnum)   projname,
            issueby,
            pkg_bg_common.fn_bg_get_issued_by_name(issueby) issuebyname,
            issueto,
            pkg_bg_common.fn_bg_get_issued_to_name(issueto) issuetoname,
            bgvaldt,
            bgclmdt,
            bankid,
            pkg_bg_common.fn_bg_get_bank_name(bankid)       bankname,
            remarks,
            released,
            reldt,
            reldetails
        Into
            p_bgnum,
            p_bgdate,
            p_compid,
            p_compdesc,
            p_bgtype,
            p_ponum,
            p_projnum,
            p_projname,
            p_issuebyid,
            p_issuebyname,
            p_issuetoid,
            p_issuetoname,
            p_bgvaldt,
            p_bgclmdt,
            p_bankid,
            p_bankname,
            p_remarks,
            p_released,
            p_reldt,
            p_reldetails
        From
            bg_main_master
        Where
            refnum = p_refnum;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_bg_master_detail;

End pkg_bg_main_master_qry;