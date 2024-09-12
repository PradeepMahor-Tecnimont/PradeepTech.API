create or replace Package Body tcmpl_afc.pkg_bg_main_amendment_qry As
    Function fn_bg_amendment_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_refnum         Varchar2,
        p_generic_search Varchar2,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        refnum,
                        amendmentnum,
                        currid,
                        pkg_bg_common.fn_bg_get_currency_name(currid)                              currency,
                        bgamt,
                        bgrecdt,
                        pkg_bg_common.fn_bg_get_acceptable(bgaccept)                               bgaccept,
                        bgacceptrmk,
                        convrate,
                        docurl,
                        pkg_bg_main_status_qry.sp_bg_get_current_status_desc(refnum, amendmentnum) status,
                        Row_Number() Over (Order By refnum Desc)                                   row_number,
                        Count(*) Over ()                                                           total_row
                    From
                        bg_main_amendments
                    Where
                        refnum = p_refnum
                        And (upper(amendmentnum) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(currid) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(pkg_bg_common.fn_bg_get_currency_name(currid)) Like upper('%' || Trim(p_generic_search) ||
                            '%') Or
                            upper(bgamt) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(bgaccept) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(bgacceptrmk) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(convrate) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(docurl) Like upper('%' || Trim(p_generic_search) || '%'))
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                refnum Desc;
        Return c;
    End fn_bg_amendment_list;

    Procedure sp_bg_amendment_detail(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_refnum           Varchar2,
        p_amendment        Varchar2 Default Null,
        p_amendmentnum Out Varchar2,
        p_currid       Out Varchar2,
        p_currdesc     Out Varchar2,
        p_bgamt        Out Varchar2,
        p_bgrecdt      Out Date,
        p_bgaccept     Out Varchar2,
        p_bgacceptname Out Varchar2,
        p_convrate     Out Varchar2,
        p_bgacceptrmk  Out Varchar2,
        p_docurl       Out Varchar2,
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

        If length(trim(p_amendment)) > 0 Then
            Select
                amendmentnum,
                currid,
                pkg_bg_common.fn_bg_get_currency_name(currid) currdesc,
                bgamt,
                bgrecdt,
                bgaccept,
                pkg_bg_common.fn_bg_get_acceptable(bgaccept) bgacceptname,
                convrate,
                bgacceptrmk,
                docurl
            Into
                p_amendmentnum,
                p_currid,
                p_currdesc,
                p_bgamt,
                p_bgrecdt,
                p_bgaccept,
                p_bgacceptname,
                p_convrate,
                p_bgacceptrmk,
                p_docurl
            From
                bg_main_amendments
            Where
                refnum           = p_refnum
                And amendmentnum = Trim(p_amendment);
        Else
            Select
                amendmentnum,
                currid,
                pkg_bg_common.fn_bg_get_currency_name(currid) currdesc,
                bgamt,
                bgrecdt,
                bgaccept,
                pkg_bg_common.fn_bg_get_acceptable(bgaccept) bgacceptname,
                convrate,
                bgacceptrmk,
                docurl
            Into
                p_amendmentnum,
                p_currid,
                p_currdesc,
                p_bgamt,
                p_bgrecdt,                
                p_bgaccept,
                p_bgacceptname,
                p_convrate,
                p_bgacceptrmk,
                p_docurl
            From
                (
                    Select
                        amendmentnum,
                        currid,
                        pkg_bg_common.fn_bg_get_currency_name(currid)  currdesc,
                        bgamt,
                        bgrecdt,
                        bgaccept,
                        convrate,
                        bgacceptrmk,
                        docurl,
                        Row_Number() Over (Order By amendmentnum Desc) row_number
                    From
                        bg_main_amendments
                    Where
                        refnum = p_refnum
                )
            Where
                row_number = 1;
        End If;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_bg_amendment_detail;
End pkg_bg_main_amendment_qry;