--------------------------------------------------------
--  DDL for Package Body PKG_JOB_ERP_PHASES_FILE_QRY
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."PKG_JOB_ERP_PHASES_FILE_QRY" As

    Function fn_erp_phases_file_list(
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
                        a.job_no                                   As job_no,
                        a.clint_file_name                          As clint_file_name,
                        a.server_file_name                         As server_file_name,
                        a.modified_by || ' - ' || b.name           As modified_by,
                        a.modified_on                              As modified_on,
                        Row_Number() Over (Order By a.job_no Desc) row_number,
                        Count(*) Over ()                           total_row
                    From
                        job_erp_phases_file                  a, emplmast_view b
                    Where
                        a.modified_by = b.empno
                        and (
                            upper(a.job_no) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_erp_phases_file_list;

    Procedure sp_erp_phases_file_details(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_job_no               Varchar2,
        p_clint_file_name  Out Varchar2,
        p_server_file_name Out Varchar2,
        p_modified_by      Out Varchar2,
        p_modified_on      Out Varchar2,

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
        Distinct
            a.clint_file_name                     As clint_file_name,
            a.server_file_name                    As server_file_name,
            a.modified_by || ' - ' || b.name      As modified_by,
            to_char(a.modified_on, 'dd-Mon-yyyy HH:MI AM') As modified_on
        Into
            p_clint_file_name,
            p_server_file_name,
            p_modified_by,
            p_modified_on
        From
            job_erp_phases_file                  a, emplmast_view b
        Where
            a.modified_by = b.empno
            And job_no    = p_job_no;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_erp_phases_file_details;

End pkg_job_erp_phases_file_qry;
/
Grant Execute On "TIMECURR"."PKG_JOB_ERP_PHASES_FILE_QRY" To "TCMPL_APP_CONFIG";