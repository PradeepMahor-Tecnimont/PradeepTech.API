create or replace Package Body tcmpl_app_config.pkg_app_mail_process_status_log As

    Function fn_mail_process_status_log_list(
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
                        process_mail                                 As process_status,
                        (Case
                             When process_mail = ok Then
                                 'ON'
                             Else
                                 'OFF'
                         End)                                        As process_mail_text,
                        modified_on                                  As modified_on,
                        modified_by                                  As modified_by,
                        selfservice.get_emp_name(modified_by)        As emp_name,
                        Row_Number() Over(Order By modified_on Desc) row_number,
                        Count(*) Over()                              total_row
                    From
                        app_mail_process_status_log
                    Where
                        (upper(modified_by) Like '%' || upper(Trim(p_generic_search)) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_mail_process_status_log_list;

    Procedure sp_process_mail_detail(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_process_mail      Out Varchar2,
        p_process_mail_text Out Varchar2,

        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := app_users.get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            process_mail,
            (Case
                 When process_mail = ok Then
                     'ON'
                 Else
                     'OFF'
             End) As process_mail_text
        Into
            p_process_mail,
            p_process_mail_text
        From
            app_mail_process_status;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'Err - Data not found.';
            
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_process_mail_detail;
End pkg_app_mail_process_status_log;