--------------------------------------------------------
--  DDL for Package Body PKG_RAP_OSC_SES_QRY
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."PKG_RAP_OSC_SES_QRY" As

    Function fn_osc_ses(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        
        p_oscm_id        Varchar2,
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
                    Distinct
                        a.oscs_id                                   As oscs_id,
                        a.oscm_id                                   As oscm_id,
                        b.projno5                                   As project_no,
                        (
                            Select
                            Distinct
                                b.name
                            From
                                projmast b
                            Where
                                substr(b.projno, 1, 5) = b.projno5
                        )                                           As project_name,

                        a.ses_no                                    As ses_no,
                        to_char(a.ses_date, 'dd-Mon-yyyy')          As ses_date,
                        a.ses_amount                                As ses_amount,
                        Row_Number() Over (Order By a.ses_date Desc) row_number,
                        Count(*) Over ()                            total_row
                    From
                        rap_osc_ses                   a, rap_osc_master b
                    Where
                        a.oscm_id = b.oscm_id
                        and  a.oscm_id = p_oscm_id
                        And
                        (
                            upper(b.projno5) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.ses_no) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(to_char(a.ses_date, 'dd-Mon-yyyy')) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.ses_amount) Like '%' || upper(Trim(p_generic_search))
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_osc_ses;

    Function fn_xl_download_osc_ses(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_oscm_id        Varchar2,
        p_generic_search Varchar2 Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
            Distinct
                a.oscs_id                          As oscs_id,
                a.oscm_id                          As oscm_id,
                b.projno5                          As project_no,
                (
                    Select
                    Distinct
                        b.name
                    From
                        projmast b
                    Where
                        substr(b.projno, 1, 5) = b.projno5
                )                                  As project_name,

                a.ses_no                           As ses_no,
                to_char(a.ses_date, 'dd-Mon-yyyy') As ses_date,
                a.ses_amount                       As ses_amount
            From
                rap_osc_ses                   a, rap_osc_master b
            Where
                a.oscm_id = b.oscm_id
                and  a.oscm_id = p_oscm_id
                And
                (
                    upper(b.projno5) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.ses_no) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(to_char(a.ses_date, 'dd-Mon-yyyy')) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.ses_amount) Like '%' || upper(Trim(p_generic_search))
                )
            Order By
                b.projno5 desc ;
        Return c;
    End fn_xl_download_osc_ses;

    Procedure sp_osc_ses_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscs_id          Varchar2,
        p_oscm_id      Out Varchar2,
        p_ses_no       Out Varchar2,
        p_ses_date     Out Date,
        p_ses_amount   Out Number,

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
        Distinct
            oscm_id, ses_no, ses_date, ses_amount
        Into
            p_oscm_id, p_ses_no, p_ses_date, p_ses_amount
        From
            rap_osc_ses
        Where
            oscs_id = p_oscs_id;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_osc_ses_details;

End pkg_rap_osc_ses_qry;
/
Grant Execute On "TIMECURR"."PKG_RAP_OSC_SES_QRY" To "TCMPL_APP_CONFIG";