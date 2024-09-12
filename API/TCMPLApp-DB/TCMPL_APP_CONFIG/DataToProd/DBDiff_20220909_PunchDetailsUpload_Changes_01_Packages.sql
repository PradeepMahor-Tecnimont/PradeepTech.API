--------------------------------------------------------
--  File created - Friday-September-09-2022   
--------------------------------------------------------
---------------------------
--Changed TABLE
--APP_PROCESS_QUEUE_LOG
---------------------------
COMMENT ON COLUMN "TCMPL_APP_CONFIG"."APP_PROCESS_QUEUE_LOG"."PROCESS_LOG_TYPE" IS 'I-Info, W-Warning, E-Error ';

---------------------------
--New TABLE
--APP_PROCESS_QUEUE_PLAN_HIST
---------------------------
  CREATE TABLE "TCMPL_APP_CONFIG"."APP_PROCESS_QUEUE_PLAN_HIST" 
   (	"KEY_ID" VARCHAR2(8) NOT NULL ENABLE,
	"EMPNO" CHAR(5) NOT NULL ENABLE,
	"MODULE_ID" CHAR(3) NOT NULL ENABLE,
	"PROCESS_ID" VARCHAR2(10) NOT NULL ENABLE,
	"PROCESS_DESC" VARCHAR2(200) NOT NULL ENABLE,
	"PARAMETER_JSON" VARCHAR2(4000),
	"PLANNED_START_DATE" DATE,
	"CREATED_ON" DATE NOT NULL ENABLE,
	"MAIL_TO" VARCHAR2(4000),
	"MAIL_CC" VARCHAR2(4000),
	"DELETED_ON" DATE
   );
---------------------------
--New TABLE
--APP_PROCESS_QUEUE_PLANNED
---------------------------
  CREATE TABLE "TCMPL_APP_CONFIG"."APP_PROCESS_QUEUE_PLANNED" 
   (	"KEY_ID" VARCHAR2(8) NOT NULL ENABLE,
	"EMPNO" CHAR(5) NOT NULL ENABLE,
	"MODULE_ID" CHAR(3) NOT NULL ENABLE,
	"PROCESS_ID" VARCHAR2(10) NOT NULL ENABLE,
	"PROCESS_DESC" VARCHAR2(200) NOT NULL ENABLE,
	"PARAMETER_JSON" VARCHAR2(4000),
	"PLANNED_START_DATE" DATE,
	"CREATED_ON" DATE NOT NULL ENABLE,
	"MAIL_TO" VARCHAR2(4000),
	"MAIL_CC" VARCHAR2(4000)
   );
---------------------------
--New TRIGGER
--TRIG_PROCESS_QUEUE_PLAN
---------------------------
  CREATE OR REPLACE TRIGGER "TCMPL_APP_CONFIG"."TRIG_PROCESS_QUEUE_PLAN"
  BEFORE DELETE ON "TCMPL_APP_CONFIG"."APP_PROCESS_QUEUE_PLANNED"
  REFERENCING FOR EACH ROW
  Begin
    Insert Into app_process_queue_plan_hist
    (
        key_id,
        empno,
        module_id,
        process_id,
        process_desc,
        parameter_json,
        planned_start_date,
        created_on,
        mail_to,
        mail_cc,
        deleted_on
    )
    Values
    (
        :old.key_id,
        :old.empno,
        :old.module_id,
        :old.process_id,
        :old.process_desc,
        :old.parameter_json,
        :old.planned_start_date,
        :old.created_on,
        :old.mail_to,
        :old.mail_cc,
        sysdate

    );
End;
/
---------------------------
--Changed PACKAGE
--PKG_APP_PROCESS_QUEUE
---------------------------
CREATE OR REPLACE PACKAGE "TCMPL_APP_CONFIG"."PKG_APP_PROCESS_QUEUE" As

    Procedure sp_process_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_module_id        Varchar2,
        p_process_id       Varchar2,
        p_process_desc     Varchar2,
        p_parameter_json   Varchar2,
        p_mail_to          Varchar2 Default Null,
        p_mail_cc          Varchar2 Default Null,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_process_add_planning(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_module_id          Varchar2,
        p_process_id         Varchar2,
        p_process_desc       Varchar2,
        p_parameter_json     Varchar2,
        p_planned_start_date Date,

        p_mail_to            Varchar2 Default Null,
        p_mail_cc            Varchar2 Default Null,
        p_message_type Out   Varchar2,
        p_message_text Out   Varchar2
    ) ;

    Procedure sp_process_started(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_process_stop_with_error(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_process_stop_with_success(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_process_log_info(
        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_process_log_error(
        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_process_log_warning(
        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Function fn_get_emp_process_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_empno     Varchar2,
        p_module_id Varchar2 Default Null
    ) Return Sys_Refcursor;

    Function fn_get_pending_process_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_get_process_log(
        p_key_id Varchar2
    ) Return Varchar2;

End pkg_app_process_queue;
/
---------------------------
--Changed PACKAGE BODY
--TASK_SCHEDULER
---------------------------
CREATE OR REPLACE PACKAGE BODY "TCMPL_APP_CONFIG"."TASK_SCHEDULER" As
    c_daily Constant Number := 1;
    Procedure sp_log_success(
        p_proc_name     Varchar2,
        p_business_name Varchar2
    ) As
        v_key_id Char(8);
    Begin
        v_key_id := dbms_random.string('X', 8);

        Insert Into app_task_scheduler_log(
            key_id,
            run_date,
            proc_name,
            proc_business_name,
            exec_status,
            exec_message
        )
        Values(
            v_key_id,
            sysdate,
            p_proc_name,
            p_business_name,
            1,
            'Procedure executed successfully.'

        );
        Commit;
    Exception
        When Others Then
            Null;
    End;
    Procedure sp_log_failure(
        p_proc_name     Varchar2,
        p_business_name Varchar2,
        p_message       Varchar2
    ) As
        v_key_id Char(8);
    Begin
        v_key_id := dbms_random.string('X', 8);

        Insert Into app_task_scheduler_log(
            key_id,
            run_date,
            proc_name,
            proc_business_name,
            exec_status,
            exec_message
        )
        Values(
            v_key_id,
            sysdate,
            p_proc_name,
            p_business_name,
            0,
            p_message

        );

        Commit;
    Exception
        When Others Then
            Null;
    End;

    Procedure sp_daily_punch_data_upload As
        v_proc_start_date_1      Date;
        v_proc_start_date_2      Date;
        v_proc_start_date_3      Date;
        v_success                Varchar2(10);
        v_message                Varchar2(1000);
        c_mail_to                Constant Varchar2(100) := 'd.bhavsar@tecnimont.in;a.kotian@tecnimont.in';
        c_process_id_punch_uplod Constant Varchar2(10)  := 'PUNCHUPLOD';
        c_process_desc           Constant Varchar2(100) := 'Upload punch data';
        c_module_id_selfservice  Constant Varchar2(3)   := 'M04';
        c_service_account_metaid Constant Varchar2(30)  := '-APPS02SRV012345';
    Begin

        v_proc_start_date_1 := trunc(sysdate) + ((7 * 60) + 15) / (24 * 60);
        v_proc_start_date_2 := trunc(sysdate) + (11 * 60) / (24 * 60);
        v_proc_start_date_2 := trunc(sysdate) + (16 * 60) / (24 * 60);

        If sysdate <= v_proc_start_date_1 Then
            pkg_app_process_queue.sp_process_add_planning(
                p_person_id          => Null,
                p_meta_id            => c_service_account_metaid,

                p_module_id          => c_module_id_selfservice,
                p_process_id         => c_process_id_punch_uplod,
                p_process_desc       => c_process_desc,
                p_parameter_json     => Null,
                p_planned_start_date => v_proc_start_date_1,

                p_mail_to            => c_mail_to,
                p_mail_cc            => Null,
                p_message_type       => v_success,
                p_message_text       => v_message
            );
        End If;

        If sysdate <= v_proc_start_date_2 Then
            pkg_app_process_queue.sp_process_add_planning(
                p_person_id          => Null,
                p_meta_id            => c_service_account_metaid,

                p_module_id          => c_module_id_selfservice,
                p_process_id         => c_process_id_punch_uplod,
                p_process_desc       => c_process_desc,
                p_parameter_json     => Null,
                p_planned_start_date => v_proc_start_date_2,

                p_mail_to            => c_mail_to,
                p_mail_cc            => Null,
                p_message_type       => v_success,
                p_message_text       => v_message
            );
        End If;

        If sysdate <= v_proc_start_date_3 Then
            pkg_app_process_queue.sp_process_add_planning(
                p_person_id          => Null,
                p_meta_id            => c_service_account_metaid,

                p_module_id          => c_module_id_selfservice,
                p_process_id         => c_process_id_punch_uplod,
                p_process_desc       => c_process_desc,
                p_parameter_json     => Null,
                p_planned_start_date => v_proc_start_date_3,

                p_mail_to            => c_mail_to,
                p_mail_cc            => Null,
                p_message_type       => v_success,
                p_message_text       => v_message
            );
        End If;
        sp_log_success(
            p_proc_name     => 'tcmpl_app_config.task_scheduler.sp_daily_punch_data_upload',
            p_business_name => 'SWP Send auto emails'
        );

    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'tcmpl_app_config.task_scheduler.sp_daily_punch_data_upload',
                p_business_name => 'SWP Send auto emails',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );

    End;

    Procedure sp_daily_swp_sendmail As
    Begin

        selfservice.task_scheduler.sp_daily_swp_sendmail;
        sp_log_success(
            p_proc_name     => 'selfservice.task_scheduler.sp_daily_swp_sendmail',
            p_business_name => 'SWP Send auto emails'
        );

    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'selfservice.task_scheduler.sp_daily_swp_sendmail',
                p_business_name => 'SWP Send auto emails',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );
    End;

    Procedure sp_daily_swp_add_new_joinees As
    Begin
        selfservice.task_scheduler.sp_daily_swp_add_nu_joinees;
        sp_log_success(
            p_proc_name     => 'selfservice.task_scheduler.sp_daily_swp_add_nu_joinees',
            p_business_name => 'Add new joinees to Primary Workspace'
        );
    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'selfservice.task_scheduler.sp_daily_swp_add_nu_joinees',
                p_business_name => 'Add new joinees to Primary Workspace',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );
    End;

    Procedure sp_daily_rap_clear_batch_rep As
    Begin
        timecurr.task_scheduler.sp_daily_del_rap_batch_reports;
        sp_log_success(
            p_proc_name     => 'timecurr.task_scheduler.sp_daily_del_rap_batch_reports',
            p_business_name => 'Clear RAP_REPORTING shceduled reports'
        );
    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'timecurr.task_scheduler.sp_daily_del_rap_batch_reports',
                p_business_name => 'Clear RAP_REPORTING shceduled reports',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );

    End;

    Procedure sp_weekly_etraining_sendmail As
    Begin
    
	Trainingnew.task_scheduler.sp_weekly_reminder_emp;
        sp_log_success(
            p_proc_name     => 'etraining.task_scheduler.sp_weekly_reminder_emp',
            p_business_name => 'eTraining Send auto emails'
        );

    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'etraining.task_scheduler.sp_weekly_reminder_emp',
                p_business_name => 'eTraining Send auto emails',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );
    End;
    
    Procedure sp_weekly_travel_sendmail As
    Begin
	travel.task_scheduler.sp_weekly_reminder_hod_pm;
        sp_log_success(
            p_proc_name     => 'travel.task_scheduler.sp_weekly_reminder_hod_pm',
            p_business_name => 'Travel Management Send auto emails'
        );

    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'travel.task_scheduler.sp_weekly_reminder_hod_pm',
                p_business_name => 'Travel Management Send auto emails',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );
    End;
    
    Procedure sp_daily_jobs As

    Begin
        Delete
            From app_task_scheduler_log
        Where
            trunc(run_date) <= trunc(sysdate) - 14;
        
        --SELFSERVICE
        sp_daily_punch_data_upload;

        --RAP
        sp_daily_rap_clear_batch_rep;

        --SWP
        sp_daily_swp_add_new_joinees;

        sp_daily_swp_sendmail;
        
        -- eTraining
        sp_weekly_etraining_sendmail;
        
        -- Travel Management
        sp_weekly_travel_sendmail;
        
    End sp_daily_jobs;

End task_scheduler;
/
---------------------------
--Changed PACKAGE BODY
--PKG_APP_PROCESS_QUEUE
---------------------------
CREATE OR REPLACE PACKAGE BODY "TCMPL_APP_CONFIG"."PKG_APP_PROCESS_QUEUE" As

    c_process_error        Constant Number := -1;
    c_process_pending      Constant Number := 0;
    c_process_started      Constant Number := 1;
    c_process_finished     Constant Number := 2;

    const_log_type_info    Char(1)         := 'I';
    const_log_type_warning Char(1)         := 'W';
    const_log_type_error   Char(1)         := 'E';
    err_text               Varchar2(4000);

    Procedure sp_process_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_module_id        Varchar2,
        p_process_id       Varchar2,
        p_process_desc     Varchar2,
        p_parameter_json   Varchar2,
        p_mail_to          Varchar2 Default Null,
        p_mail_cc          Varchar2 Default Null,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno  Varchar2(5);
        v_email  vu_userids.email%Type;
        v_key_id Varchar2(8);
    Begin
        v_empno  := selfservice.get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            --p_key_id := null;
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            email
        Into
            v_email
        From
            vu_userids
        Where
            empno = Trim(v_empno);

        v_key_id := dbms_random.string('X', 8);

        Delete
            From app_process_queue
        Where
            p_parameter_json = Trim(p_parameter_json)
            And process_id   = Trim(p_process_id)
            And module_id    = Trim(p_module_id)
            And empno        = Trim(v_empno);

        Delete
            From app_process_finished
        Where
            p_parameter_json = Trim(p_parameter_json)
            And process_id   = Trim(p_process_id)
            And module_id    = Trim(p_module_id)
            And empno        = Trim(v_empno);

        Insert Into app_process_queue
            (key_id, empno, module_id, process_id, process_desc, parameter_json, created_on, status, mail_to, mail_cc)
        Values (v_key_id, Trim(v_empno), Trim(p_module_id), Trim(p_process_id), Trim(p_process_desc), p_parameter_json, sysdate,
            c_process_pending,
            v_email, p_mail_cc);

        sp_process_log_info(v_key_id, 'Process added', p_message_type, p_message_text);

    Exception
        When Others Then
            err_text       := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            sp_process_log_error(v_key_id, 'Error in sp_add_process_queue - ' || err_text,
                                 p_message_type, p_message_text);
            p_message_type := 'KO';
            p_message_text := err_text;
    End sp_process_add;

    Procedure sp_process_add_planning(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_module_id          Varchar2,
        p_process_id         Varchar2,
        p_process_desc       Varchar2,
        p_parameter_json     Varchar2,
        p_planned_start_date Date,

        p_mail_to            Varchar2 Default Null,
        p_mail_cc            Varchar2 Default Null,
        p_message_type Out   Varchar2,
        p_message_text Out   Varchar2
    ) As
        v_empno  Varchar2(5);
        v_email  vu_userids.email%Type;
        v_key_id Varchar2(8);
    Begin
        v_empno  := selfservice.get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            --p_key_id := null;
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            email
        Into
            v_email
        From
            vu_userids
        Where
            empno = Trim(v_empno);

        v_key_id := dbms_random.string('X', 8);

        Delete
            From app_process_queue_planned
        Where
            p_parameter_json = Trim(p_parameter_json)
            And process_id   = Trim(p_process_id)
            And module_id    = Trim(p_module_id)
            And empno        = Trim(v_empno);

        Delete
            From app_process_finished
        Where
            p_parameter_json = Trim(p_parameter_json)
            And process_id   = Trim(p_process_id)
            And module_id    = Trim(p_module_id)
            And empno        = Trim(v_empno);

        Insert Into app_process_queue_planned
        (key_id, empno, module_id, process_id, process_desc, parameter_json, planned_start_date, created_on, mail_to,
            mail_cc)
        Values (v_key_id, Trim(v_empno), Trim(p_module_id), Trim(p_process_id), Trim(p_process_desc), p_planned_start_date,
            p_parameter_json, sysdate,
            v_email, p_mail_cc);

        sp_process_log_info(v_key_id, 'Process added to planned queue', p_message_type, p_message_text);

    Exception
        When Others Then
            err_text       := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            sp_process_log_error(v_key_id, 'Error in sp_add_process_queue - ' || err_text,
                                 p_message_type, p_message_text);
            p_message_type := 'KO';
            p_message_text := err_text;
    End sp_process_add_planning;

    Procedure sp_process_started(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Update
            app_process_queue
        Set
            process_start_date = sysdate,
            status = c_process_started
        Where
            key_id = Trim(p_key_id);

        sp_process_log_info(p_key_id, 'Process started - ' || p_process_log, p_message_type, p_message_text);

    Exception
        When Others Then
            err_text       := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            sp_process_log_error(p_key_id, 'Error in sp_start_process_queue - ' || err_text,
                                 p_message_type, p_message_text);
            p_message_type := 'KO';
            p_message_text := err_text;
    End sp_process_started;

    Procedure sp_process_stop_with_success(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Update
            app_process_queue
        Set
            process_finish_date = sysdate,
            status = c_process_finished
        Where
            key_id = Trim(p_key_id);
        sp_process_log_info(p_key_id, 'Process finished - ' || p_process_log, p_message_type, p_message_text);

        Insert Into app_process_finished
        Select
            *
        From
            app_process_queue
        Where
            key_id = Trim(p_key_id);

        Delete
            From app_process_queue
        Where
            status In (c_process_finished, c_process_error);

        sp_process_log_info(p_key_id, 'Process archived', p_message_type, p_message_text);

    Exception
        When Others Then
            err_text       := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            sp_process_log_error(p_key_id, 'Error in sp_finish_process_queue - ' || err_text,
                                 p_message_type, p_message_text);
            p_message_type := 'KO';
            p_message_text := err_text;
    End sp_process_stop_with_success;

    Procedure sp_process_stop_with_error(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Update
            app_process_queue
        Set
            status = c_process_error
        Where
            key_id = Trim(p_key_id);

        sp_process_log_error(p_key_id, 'Process error - ' || p_process_log, p_message_type, p_message_text);

        --send mail to IT ???

        Insert Into app_process_finished
        Select
            *
        From
            app_process_queue
        Where
            key_id = Trim(p_key_id);

        sp_process_log_info(p_key_id, 'Process archived', p_message_type, p_message_text);
    Exception
        When Others Then
            err_text       := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            sp_process_log_error(p_key_id, 'Error in sp_error_process_queue - ' || err_text,
                                 p_message_type, p_message_text);
            p_message_type := 'KO';
            p_message_text := err_text;
    End sp_process_stop_with_error;

    Procedure sp_add_process_queue_log(
        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_process_log_type Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Insert Into app_process_queue_log(key_id, process_log, process_log_type, created_on)
        Values
            (p_key_id, p_process_log, p_process_log_type, sysdate);
        Commit;
        p_message_type := 'OK';
        p_message_text := 'Success';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_process_queue_log;

    Procedure sp_process_log_info(
        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        sp_add_process_queue_log(
            p_key_id           => p_key_id,
            p_process_log      => p_process_log,
            p_process_log_type => const_log_type_info,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_process_log_info;

    Procedure sp_process_log_warning(
        p_key_id           Varchar2,
        p_process_log      Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        sp_add_process_queue_log(
            p_key_id           => p_key_id,
            p_process_log      => p_process_log,
            p_process_log_type => const_log_type_warning,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_process_log_warning;

    Procedure sp_process_log_error(
        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        sp_add_process_queue_log(
            p_key_id           => p_key_id,
            p_process_log      => p_process_log,
            p_process_log_type => const_log_type_error,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_process_log_error;

    Function fn_get_emp_process_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_empno     Varchar2,
        p_module_id Varchar2 Default Null
    ) Return Sys_Refcursor Is
        p_rec Sys_Refcursor;
    Begin
        Open p_rec For
            Select
                pq.key_id,
                pq.module_id,
                pq.process_id,
                pq.process_desc,
                pq.parameter_json,
                pq.process_start_date,
                pq.process_finish_date,
                pq.created_on,
                pq.status,
                ps.status_desc,
                fn_get_process_log(pq.key_id) process_log
            From
                app_process_queue  pq,
                app_process_status ps
            Where
                pq.status = ps.status
                And Exists

                (
                    Select
                        Max(pq2.created_on), pq2.parameter_json, pq2.process_id, pq2.empno
                    From
                        app_process_queue pq2
                    Where
                        pq2.created_on         = pq.created_on
                        And pq2.parameter_json = pq.parameter_json
                        And pq2.process_id     = pq.process_id
                        And pq2.empno          = pq.empno
                        And pq2.empno          = Trim(p_empno)
                        And pq2.module_id      = nvl(Trim(p_module_id), pq2.module_id)
                    Group By
                        pq2.parameter_json, pq2.process_id, pq2.empno
                )

            Union All

            Select
                pf.key_id,
                pf.module_id,
                pf.process_id,
                pf.process_desc,
                pf.parameter_json,
                pf.process_start_date,
                pf.process_finish_date,
                pf.created_on,
                pf.status,
                ps.status_desc,
                fn_get_process_log(pf.key_id) process_log
            From
                app_process_finished pf,
                app_process_status   ps
            Where
                pf.status = ps.status
                And Exists

                (
                    Select
                        Max(pf2.created_on), pf2.parameter_json, pf2.process_id, pf2.empno
                    From
                        app_process_finished pf2
                    Where
                        pf2.created_on         = pf.created_on
                        And pf2.parameter_json = pf.parameter_json
                        And pf2.process_id     = pf.process_id
                        And pf2.empno          = pf.empno
                        And pf2.empno          = Trim(p_empno)
                        And pf2.module_id      = nvl(Trim(p_module_id), pf2.module_id)
                    Group By
                        pf2.parameter_json, pf2.process_id, pf2.empno
                );
        Return p_rec;
    End fn_get_emp_process_list;

    Function fn_get_pending_process_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c         Sys_Refcursor;
        v_sysdate Date;
    Begin
        v_sysdate := sysdate;
        Insert Into app_process_finished
        (
            key_id,
            empno,
            module_id,
            process_id,
            process_desc,
            parameter_json,
            process_start_date,
            process_finish_date,
            created_on,
            status,
            mail_to,
            mail_cc
        )
        Select
            key_id,
            empno,
            module_id,
            process_id,
            process_desc,
            parameter_json,
            process_start_date,
            process_finish_date,
            created_on,
            status,
            mail_to,
            mail_cc
        From
            app_process_queue
        Where
            status In (c_process_finished, c_process_error);

        Delete
            From app_process_queue
        Where
            status In (c_process_finished, c_process_error);

        Insert Into app_process_queue(
            key_id,
            empno,
            module_id,
            process_id,
            process_desc,
            parameter_json,
            created_on,
            status,
            mail_to,
            mail_cc
        )
        Select
            key_id,
            empno,
            module_id,
            process_id,
            process_desc,
            parameter_json,
            v_sysdate,
            c_process_pending,
            mail_to,
            mail_cc
        From
            app_process_queue_planned
        Where
            planned_start_date <= v_sysdate;

        Delete
            From app_process_queue_planned
        Where
            planned_start_date <= v_sysdate;

        Commit;

        Open c For
            Select
                *
            From
                app_process_queue
            Where
                status = c_process_pending
                And Rownum <= p_page_length
            Order By
                created_on;
        Return c;

    End;

    Function fn_get_process_log(
        p_key_id Varchar2
    ) Return Varchar2 As
        v_process_log app_process_queue_log.process_log%Type;
    Begin
        Select
            process_log
        Into
            v_process_log
        From
            (
                Select
                    process_log
                From
                    app_process_queue_log
                Where
                    key_id = Trim(p_key_id)
                Order By created_on Desc
            )
        Where
            Rownum = 1;
        Return v_process_log;
    Exception
        When Others Then
            Return Null;
    End;
End pkg_app_process_queue;
/
