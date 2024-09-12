Create Or Replace Package Body pkg_process_log_qry As

    Function fn_process_finished (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_start_date     Date Default Null,
        p_end_date       Date Default Null,
        p_process_module Varchar2 Default Null,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          key_id,
                                          empno,
                                          selfservice.get_emp_name(empno) As emp_name,
                                          module_id,
                                          (
                                              Select
                                                  module_name || ' - ' || module_long_desc
                                                From
                                                  sec_modules
                                               Where
                                                  sec_modules.module_id = app_process.module_id
                                          )                               As module_desc,
                                          process_id,
                                          process_desc,
                                          parameter_json,
                                          to_char(
                                              process_start_date,
                                              'dd-Mon-yyyy : HH24:MI:SS'
                                          )                               As process_start_date,
                                          to_char(
                                              process_finish_date,
                                              'dd-Mon-yyyy : HH24:MI:SS'
                                          )                               As process_finish_date,
                                          to_char(
                                              created_on,
                                              'dd-Mon-yyyy : HH24:MI:SS'
                                          )                               As created_on,
                                          created_on                      As created_on_for_sort,
                                          to_char(status)                 status,
                                          mail_to,
                                          mail_cc,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  created_on Desc
                                          )                               row_number,
                                          Count(*)
                                          Over()                          total_row
                                        From
                                          app_process_finished app_process
                                       Where
                                              trunc(process_start_date)  = trunc(
                                                  nvl(
                                                      p_start_date,
                                                      process_start_date
                                                  )
                                              ) And
                                          trunc(process_finish_date) = trunc(
                                              nvl(
                                                  p_end_date,
                                                  process_finish_date
                                              )
                                          ) And
                                          ( upper(process_id) Like '%' || upper(
                                              Trim(p_generic_search)
                                          ) || '%' Or
                                            upper(empno) Like '%' || upper(
                                                Trim(p_generic_search)
                                            ) || '%' Or
                                            upper(process_desc) Like '%' || upper(
                                                Trim(p_generic_search)
                                            ) || '%' Or
                                            upper(module_id) Like '%' || upper(
                                                Trim(p_generic_search)
                                            ) || '%' )
                                  )
                    Where
                       row_number Between ( nvl(
                           p_row_number,
                           0
                       ) + 1 ) And ( nvl(
                           p_row_number,
                           0
                       ) + p_page_length )
                    Order By
                       created_on_for_sort Desc;
        Return c;
    End fn_process_finished;

    Function fn_process_queue (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_start_date     Date Default Null,
        p_end_date       Date Default Null,
        p_process_module Varchar2 Default Null,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          key_id,
                                          empno,
                                          selfservice.get_emp_name(empno) As emp_name,
                                          module_id,
                                          (
                                              Select
                                                  module_name || ' - ' || module_long_desc
                                                From
                                                  sec_modules
                                               Where
                                                  sec_modules.module_id = app_process.module_id
                                          )                               As module_desc,
                                          process_id,
                                          process_desc,
                                          parameter_json,
                                          to_char(
                                              process_start_date,
                                              'dd-Mon-yyyy : HH24:MI:SS'
                                          )                               As process_start_date,
                                          to_char(
                                              process_finish_date,
                                              'dd-Mon-yyyy : HH24:MI:SS'
                                          )                               As process_finish_date,
                                          to_char(
                                              created_on,
                                              'dd-Mon-yyyy : HH24:MI:SS'
                                          )                               As created_on,
                                          created_on                      As created_on_for_sort,
                                          to_char(status)                 status,
                                          mail_to,
                                          mail_cc,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  created_on Desc
                                          )                               row_number,
                                          Count(*)
                                          Over()                          total_row
                                        From
                                          app_process_queue app_process
                                       Where
                                              trunc(created_on) = trunc(
                                                  nvl(
                                                      p_start_date,
                                                      created_on
                                                  )
                                              )
                       -- And trunc(process_finish_date) = trunc(nvl(p_end_date, process_finish_date))
                                               And
                                          module_id         = nvl(
                                              p_process_module,
                                              module_id
                                          ) And
                                          ( upper(process_id) Like '%' || upper(
                                              Trim(p_generic_search)
                                          ) || '%' Or
                                            upper(empno) Like '%' || upper(
                                                Trim(p_generic_search)
                                            ) || '%' Or
                                            upper(process_desc) Like '%' || upper(
                                                Trim(p_generic_search)
                                            ) || '%' Or
                                            upper(module_id) Like '%' || upper(
                                                Trim(p_generic_search)
                                            ) || '%' )
                                  )
                    Where
                       row_number Between ( nvl(
                           p_row_number,
                           0
                       ) + 1 ) And ( nvl(
                           p_row_number,
                           0
                       ) + p_page_length )
                    Order By
                       created_on_for_sort Desc;
        Return c;
    End fn_process_queue;

    Function fn_app_task_scheduler (
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          key_id,
                                          to_char(
                                              run_date,
                                              'dd-Mon-yyyy : HH24:MI:SS'
                                          )                    As run_date,
                                          run_date             As run_date_for_sort,
                                          to_char(exec_status) As exec_status,
                                          exec_message,
                                          proc_name,
                                          proc_business_name,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  run_date Desc
                                          )                    row_number,
                                          Count(*)
                                          Over()               total_row
                                        From
                                          app_task_scheduler_log
                                       Where
                                          trunc(run_date) = trunc(
                                              nvl(
                                                  p_start_date,
                                                  run_date
                                              )
                                          )
                                  )
                    Where
                       row_number Between ( nvl(
                           p_row_number,
                           0
                       ) + 1 ) And ( nvl(
                           p_row_number,
                           0
                       ) + p_page_length )
                    Order By
                       run_date_for_sort Desc;
        Return c;
    End fn_app_task_scheduler;

    Function fn_app_process_queue (
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  *
                                From
                                  (
                                      Select
                                          key_id,
                                          process_log,
                                          process_log_type,
                                          to_char(
                                              created_on,
                                              'dd-Mon-yyyy : HH24:MI:SS'
                                          )          As created_on,
                                          created_on As created_on_for_dort,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  created_on Desc
                                          )          row_number,
                                          Count(*)
                                          Over()     total_row
                                        From
                                          app_process_queue_log
                                       Where
                                          trunc(created_on) = trunc(
                                              nvl(
                                                  p_start_date,
                                                  created_on
                                              )
                                          )
                                  )
                    Where
                       row_number Between ( nvl(
                           p_row_number,
                           0
                       ) + 1 ) And ( nvl(
                           p_row_number,
                           0
                       ) + p_page_length )
                    Order By
                       created_on_for_dort Desc;
        Return c;
    End fn_app_process_queue;

    Procedure sp_process_finished_detail (
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_key_id              Varchar2,
        p_empno               Out Varchar2,
        p_emp_name            Out Varchar2,
        p_module_id           Out Varchar2,
        p_module_desc         Out Varchar2,
        p_process_id          Out Varchar2,
        p_process_desc        Out Varchar2,
        p_parameter_json      Out Varchar2,
        p_process_start_date  Out Varchar2,
        p_process_finish_date Out Varchar2,
        p_created_on          Out Varchar2,
        p_status              Out Varchar2,
        p_mail_to             Out Varchar2,
        p_mail_cc             Out Varchar2,
        p_message_type        Out Varchar2,
        p_message_text        Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            empno,
            selfservice.get_emp_name(empno) As emp_name,
            module_id,
            (
                Select
                    module_name || ' - ' || module_long_desc
                  From
                    sec_modules
                 Where
                    sec_modules.module_id = app_process.module_id
            )                               As module_desc,
            process_id,
            process_desc,
            parameter_json,
            to_char(
                process_start_date,
                'dd-Mon-yyyy : HH24:MI:SS'
            )                               As process_start_date,
            to_char(
                process_finish_date,
                'dd-Mon-yyyy : HH24:MI:SS'
            )                               As process_finish_date,
            to_char(
                created_on,
                'dd-Mon-yyyy : HH24:MI:SS'
            )                               As created_on,
            to_char(status)                 status,
            mail_to,
            mail_cc
          Into
            p_empno,
            p_emp_name,
            p_module_id,
            p_module_desc,
            p_process_id,
            p_process_desc,
            p_parameter_json,
            p_process_start_date,
            p_process_finish_date,
            p_created_on,
            p_status,
            p_mail_to,
            p_mail_cc
          From
            app_process_finished app_process
         Where
            key_id = p_key_id;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_process_finished_detail;

    Procedure sp_process_queue_detail (
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_key_id              Varchar2,
        p_empno               Out Varchar2,
        p_emp_name            Out Varchar2,
        p_module_id           Out Varchar2,
        p_module_desc         Out Varchar2,
        p_process_id          Out Varchar2,
        p_process_desc        Out Varchar2,
        p_parameter_json      Out Varchar2,
        p_process_start_date  Out Varchar2,
        p_process_finish_date Out Varchar2,
        p_created_on          Out Varchar2,
        p_status              Out Varchar2,
        p_mail_to             Out Varchar2,
        p_mail_cc             Out Varchar2,
        p_message_type        Out Varchar2,
        p_message_text        Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            empno,
            selfservice.get_emp_name(empno) As emp_name,
            module_id,
            (
                Select
                    module_name || ' - ' || module_long_desc
                  From
                    sec_modules
                 Where
                    sec_modules.module_id = app_process.module_id
            )                               As module_desc,
            process_id,
            process_desc,
            parameter_json,
            to_char(
                process_start_date,
                'dd-Mon-yyyy : HH24:MI:SS'
            )                               As process_start_date,
            to_char(
                process_finish_date,
                'dd-Mon-yyyy : HH24:MI:SS'
            )                               As process_finish_date,
            to_char(
                created_on,
                'dd-Mon-yyyy : HH24:MI:SS'
            )                               As created_on,
            to_char(status)                 status,
            mail_to,
            mail_cc
          Into
            p_empno,
            p_emp_name,
            p_module_id,
            p_module_desc,
            p_process_id,
            p_process_desc,
            p_parameter_json,
            p_process_start_date,
            p_process_finish_date,
            p_created_on,
            p_status,
            p_mail_to,
            p_mail_cc
          From
            app_process_queue app_process
         Where
            key_id = p_key_id;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_process_queue_detail;

End pkg_process_log_qry;