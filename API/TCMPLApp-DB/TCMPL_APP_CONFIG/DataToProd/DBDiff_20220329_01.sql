--------------------------------------------------------
--  File created - Tuesday-March-29-2022   
--------------------------------------------------------
---------------------------
--New TABLE
--SEC_MODULE_USERS_ROLES_ACTIONS
---------------------------
  CREATE TABLE "TCMPL_APP_CONFIG"."SEC_MODULE_USERS_ROLES_ACTIONS" 
   (	"MODULE_ID" CHAR(3) NOT NULL ENABLE,
	"EMPNO" CHAR(5) NOT NULL ENABLE,
	"ROLE_ID" CHAR(4) NOT NULL ENABLE,
	"ACTION_ID" CHAR(4) NOT NULL ENABLE,
	CONSTRAINT "SEC_MODULE_USERS_ROLES_ACT_PK" PRIMARY KEY ("MODULE_ID","EMPNO","ROLE_ID","ACTION_ID") ENABLE
   );
---------------------------
--Changed TABLE
--SEC_ACTIONS
---------------------------
ALTER TABLE "TCMPL_APP_CONFIG"."SEC_ACTIONS" MODIFY ("ACTION_NAME" VARCHAR2(30));

---------------------------
--Changed VIEW
--VU_MODULE_USER_ROLE_ACTIONS
---------------------------
CREATE OR REPLACE FORCE VIEW "TCMPL_APP_CONFIG"."VU_MODULE_USER_ROLE_ACTIONS" 
 ( "MODULE_ID", "MODULE_NAME", "ROLE_ID", "ROLE_NAME", "EMPNO", "PERSON_ID", "ACTION_ID"
  )  AS 
  Select
        ur.module_id,
        m.module_name,
        ur.role_id,
        r.role_name,
        ur.empno,
        ur.person_id,
        ra.action_id
    From
        sec_modules             m,
        sec_module_user_roles   ur,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        m.module_id               = ur.module_id
        And ur.role_id            = r.role_id
        And ur.module_role_key_id = ra.module_role_key_id(+)

    Union

    Select
        mr.module_id,
        Null      module_name,
        mr.role_id,
        r.role_desc,
        mngr.mngr empno,
        Null      person_id,
        ra.action_id
    From
        (
            Select
            Distinct mngr
            From
                vu_emplmast
            Where
                status = 1
                And mngr Is Not Null
        )                       mngr,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_mngr_hod
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.role_id(+)
        And mr.module_id = 'M04'

    Union
    Select
        mr.module_id,
        Null    module_name,
        mr.role_id,
        r.role_desc,
        d.empno empno,
        Null    person_id,
        ra.action_id
    From
        selfservice.ss_delegate d,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_mngr_hod_onbehalf
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.role_id(+)
        And mr.module_id = 'M04'

    Union
    Select
        mr.module_id,
        Null          module_name,
        mr.role_id,
        r.role_desc,
        lead.empno,
        lead.personid person_id,
        ra.action_id
    From
        (
            Select
                empno, personid
            From
                vu_emplmast
            Where
                status = 1
                And empno In (
                    Select
                        empno
                    From
                        selfservice.ss_lead_approver
                )
        )                       lead,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_lead
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.role_id(+)
        And mr.module_id = 'M04'

    Union
    Select
        mr.module_id,
        Null          module_name,
        mr.role_id,
        r.role_desc,
        lead.empno,
        lead.personid person_id,
        ra.action_id
    From
        (
            Select
                empno, personid
            From
                vu_emplmast
            Where
                status = 1
                And empno In (
                    Select
                        empno
                    From
                        selfservice.ss_user_dept_rights
                )
        )                       lead,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_secretary
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.role_id(+)
        And mr.module_id = 'M04'

    Union

    Select
        mr.module_id,
        Null module_name,
        mr.role_id,
        r.role_desc,
        hod  empno,
        Null person_id,
        ra.action_id
    From
        vu_costmast             c,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_hod
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.role_id(+)
        And mr.module_id not in( 'M05','M07')
    Union

    Select
        mura.module_id,
        m.module_name module_name,
        mura.role_id,
        r.role_desc   role_desc,
        mura.empno,
        e.personid    person_id,
        mura.action_id
    From
        sec_module_users_roles_actions mura,
        vu_emplmast                    e,
        sec_roles                      r,
        sec_modules                    m

    Where
        mura.empno         = e.empno
        And mura.role_id   = r.role_id
        And mura.module_id = m.module_id;
---------------------------
--New INDEX
--SEC_MODULE_USERS_ROLES_ACT_PK
---------------------------
  CREATE UNIQUE INDEX "TCMPL_APP_CONFIG"."SEC_MODULE_USERS_ROLES_ACT_PK" ON "TCMPL_APP_CONFIG"."SEC_MODULE_USERS_ROLES_ACTIONS" ("MODULE_ID","EMPNO","ROLE_ID","ACTION_ID");
---------------------------
--New INDEX
--SEC_MODULE_USERS_ROLES_ACTION
---------------------------
  CREATE INDEX "TCMPL_APP_CONFIG"."SEC_MODULE_USERS_ROLES_ACTION" ON "TCMPL_APP_CONFIG"."SEC_MODULE_USERS_ROLES_ACTIONS" ("MODULE_ID","EMPNO");
---------------------------
--Changed PACKAGE
--TASK_SCHEDULER
---------------------------
CREATE OR REPLACE PACKAGE "TCMPL_APP_CONFIG"."TASK_SCHEDULER" As

    Procedure sp_log_failure(
        p_proc_name     Varchar2,
        p_business_name Varchar2,
        p_message       Varchar2
    );

    Procedure sp_log_success(
        p_proc_name     Varchar2,
        p_business_name Varchar2
    );

    Procedure sp_daily_jobs;

End task_scheduler;
/
---------------------------
--Changed PACKAGE
--PKG_APP_MAIL_QUEUE
---------------------------
CREATE OR REPLACE PACKAGE "TCMPL_APP_CONFIG"."PKG_APP_MAIL_QUEUE" As

    Procedure sp_add_to_queue(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_mail_to          Varchar2,
        p_mail_cc          Varchar2,
        p_mail_bcc         Varchar2,
        p_mail_subject     Varchar2,
        p_mail_body1       Varchar2,
        p_mail_body2       Varchar2,
        p_mail_type        Varchar2,
        p_mail_from        Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_update_mail_status_success(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_queue_key_id     Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_update_mail_status_error(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_queue_key_id     Varchar2,
        p_log_message      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Function fn_mails_pending(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

End pkg_app_mail_queue;
/
---------------------------
--Changed PACKAGE
--APP_CONSTANTS
---------------------------
CREATE OR REPLACE PACKAGE "TCMPL_APP_CONFIG"."APP_CONSTANTS" As

    --Module ID
    c_mod_id_swp_vaccine Constant Varchar(3) := 'M01';

    c_mod_id_ofb Constant Varchar(3) := 'M02';

    c_mod_id_hrmasters Constant Varchar(3) := 'M03';

    c_mod_id_selfservice Constant Varchar(3) := 'M04';

    c_mod_id_swp Constant Varchar(3) := 'M05';

    c_mod_id_letter_of_credit Constant Varchar(3) := 'M06';

    c_mod_id_rap_reporting Constant Varchar(3) := 'M07';
    --**************

    --ROLE ID
    c_role_hod Constant Varchar2(4) := 'R002';
    c_role_secretary Constant Varchar2(4) := 'R003';
    c_role_mngr_hod Constant Varchar2(4) := 'R004';
    c_role_mngr_hod_onbehalf Constant Varchar2(4) := 'R005';
    c_role_lead Constant Varchar2(4) := 'R006';

    c_role_seat_plan Constant Varchar2(4) := 'R029';
    --***************

    --ROLES
    Function role_id_hod Return Varchar2;

    Function role_id_mngr_hod Return Varchar2;

    Function role_id_mngr_hod_onbehalf Return Varchar2;

    Function role_id_lead Return Varchar2;

    Function role_id_secretary Return Varchar2;

    Function role_id_swp_seat_plan Return Varchar2;

    --MODULES
    Function mod_id_swp Return Varchar2;

    Function mod_id_swp_vaccine Return Varchar2;

    Function mod_id_ofb Return Varchar2;

    Function mod_id_selfservice Return Varchar2;

    Function mod_id_rap_reporting Return Varchar2;

    Function mod_id_hrmasters Return Varchar2;

    Function mod_id_letter_of_credit Return Varchar2;

End app_constants;
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

    Procedure sp_daily_jobs As

    Begin
        Delete
            From app_task_scheduler_log
        Where
            trunc(run_date) >= trunc(sysdate) - 14;
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
    End sp_daily_jobs;

End task_scheduler;
/
---------------------------
--Changed PACKAGE BODY
--PKG_GENERATE_USER_ACCESS
---------------------------
CREATE OR REPLACE PACKAGE BODY "TCMPL_APP_CONFIG"."PKG_GENERATE_USER_ACCESS" As

    --Generate access rights for SWP Primary WorkSpace Planning
    Procedure swp_pws_planning_access As
        c_swp_module_id   Varchar2(3);
        c_swp_hod_role_id Varchar2(4);
        c_swp_sec_role_id Varchar2(4);
    Begin
        c_swp_module_id   := app_constants.mod_id_swp;
        c_swp_hod_role_id := app_constants.role_id_hod;
        c_swp_sec_role_id := app_constants.role_id_secretary;
        --HOD access

        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_hod_role_id;

        Insert Into sec_module_users_roles_actions(
            module_id, empno, role_id, action_id
        )
        With
            hod_4_pws As(
                Select
                    hod
                From
                    vu_costmast
                Where
                    noofemps > 0
                    And costcode Not In(
                        Select
                            assign
                        From
                            selfservice.swp_exclude_assign
                    )
            )
        Select
        Distinct
            module_id, hod.hod empno, role_id, action_id
        From
            sec_module_role_actions mra,
            hod_4_pws               hod
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_hod_role_id;

        --SECRETARY Access
        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_sec_role_id;

        Insert Into sec_module_users_roles_actions(
            module_id, empno, role_id, action_id
        )
        With
            sec_4_pws As(
                Select
                    empno
                From
                    selfservice.ss_user_dept_rights
                Where
                    parent Not In(
                        Select
                            assign
                        From
                            selfservice.swp_exclude_assign
                    )
                    And parent In
                    (
                        Select
                            costcode
                        From
                            vu_costmast
                        Where
                            noofemps > 0
                    )
            )
        Select
        Distinct
            module_id, sec.empno empno, role_id, action_id
        From
            sec_module_role_actions mra,
            sec_4_pws               sec
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_sec_role_id;
    End;

    Procedure swp_ows_sws_planning_access As
        c_swp_module_id             Varchar2(3);
        c_swp_hod_seat_plan_role_id Varchar2(4) := 'R029';
        c_swp_sec_seat_plan_role_id Varchar2(4) := 'R030';

    Begin
        c_swp_module_id := app_constants.mod_id_swp;
        --HOD SEAT PLAN access

        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_hod_seat_plan_role_id;

        Insert Into sec_module_users_roles_actions(
            module_id, empno, role_id, action_id
        )

        With
            hod_4_seat_plan As(
                Select
                    hod
                From
                    vu_costmast
                Where
                    noofemps > 0
                    And costcode Not In(
                        Select
                            assign
                        From
                            selfservice.swp_exclude_assign
                    )
                    And costcode In (
                        Select
                            assign
                        From
                            selfservice.swp_include_assign_4_seat_plan
                    )
            )
        Select
        Distinct
            module_id, hod.hod empno, role_id, action_id
        From
            sec_module_role_actions mra,
            hod_4_seat_plan         hod
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_hod_seat_plan_role_id;

        --SECRETARY Access
        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_sec_seat_plan_role_id;

        Insert Into sec_module_users_roles_actions(
            module_id, empno, role_id, action_id
        )
        With
            sec_4_seat_plan As(
                Select
                    empno
                From
                    selfservice.ss_user_dept_rights
                Where
                    parent Not In(
                        Select
                            assign
                        From
                            selfservice.swp_exclude_assign
                    )
                    And parent In
                    (
                        Select
                            costcode
                        From
                            vu_costmast
                        Where
                            noofemps > 0
                            And costcode In (
                                Select
                                    assign
                                From
                                    selfservice.swp_include_assign_4_seat_plan
                            )
                    )
            )
        Select
        Distinct
            module_id, sec.empno empno, role_id, action_id
        From
            sec_module_role_actions mra,
            sec_4_seat_plan         sec
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_sec_seat_plan_role_id;
    End;

    Procedure sp_rap_proj_mngr_access As
    Begin
        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = 'M07'
            And role_id = 'R022';

        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, prjmngr empno, ra.role_id, ra.action_id
        From
            timecurr.projmast       p,
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            module_id    = 'M07'
            And role_id  = 'R022' --Project Manager
            And e.empno  = p.prjmngr
            And e.status = 1;
    End;

    Procedure sp_rap_proj_rpt_access As
    Begin

        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = 'M07'
            And role_id = 'R021';

        --Job Incharge
        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, p.prjdymngr, ra.role_id, ra.action_id
        From
            timecurr.projmast       p,
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            ra.module_id   = 'M07'
            And ra.role_id = 'R021'
            And e.empno    = p.prjdymngr
            And e.status   = 1;

        --Project Secretary
        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, prjoper empno, ra.role_id, ra.action_id
        From
            timecurr.projmast       p,
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            module_id    = 'M07'
            And role_id  = 'R021' --Project REPORTS
            And e.empno  = p.prjoper
            And e.status = 1;

    End;

    Procedure sp_rap_sec_access As
    Begin
        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = 'M07'
            And role_id = 'R003';

        --DEPT Secretary
        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, rh.empno, ra.role_id, ra.action_id
        From
            timecurr.rap_hod        rh,
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            module_id    = 'M07'
            And role_id  = 'R003'
            And e.empno  = rh.empno
            And e.status = 1;

        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, rh.empno, ra.role_id, ra.action_id
        From
            timecurr.rap_dyhod      rh,
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            module_id    = 'M07'
            And role_id  = 'R003'
            And e.empno  = rh.empno
            And e.status = 1;

        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, rs.empno, ra.role_id, ra.action_id
        From
            timecurr.rap_secretary  rs,
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            module_id    = 'M07'
            And role_id  = 'R003'
            And e.empno  = rs.empno
            And e.status = 1;

    End;

    Procedure sp_rap_hod_access As
    Begin
        --HoD
        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = 'M07'
            And role_id = 'R002';

        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, cc.hod, ra.role_id, ra.action_id
        From
            vu_costmast             cc,
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            module_id    = 'M07'
            And role_id  = 'R002'
            And e.empno  = cc.hod
            And e.status = 1
            And cc.costcode Like '02%';

    End;

    Procedure sp_rap_director_access As
    Begin
        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = 'M07'
            And role_id = 'R028';


        --Director
        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, e.empno, ra.role_id, ra.action_id
        From
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            module_id      = 'M07'
            And role_id    = 'R028'
            And e.status   = 1
            And e.director = 1;

    End;

    Procedure sp_generate As
        v_key_id Varchar2(8);
    Begin
        v_key_id := dbms_random.string('X', 8);
        -- PRIMARY Workspace planning
        Begin
            /***************************/
            /*                         */
            swp_pws_planning_access;
            /*                         */
            /***************************/

            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.swp_pws_planning_access',
                p_business_name => 'Generate SWP PWS Planning access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.swp_pws_planning_access',
                    p_business_name => 'Generate SWP PWS Planning access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;

        --SWP DESK / OWS - SWS desk planning
        Begin
            /***************************/
            /*                         */
            swp_ows_sws_planning_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.swp_ows_sws_planning_access',
                p_business_name => 'Generate SWP OWS-SWS Desk Planning access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.swp_ows_sws_planning_access',
                    p_business_name => 'Generate SWP OWS-SWS Desk Planning access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;


        --RAP Reporting PROJECT Manager Access
        Begin
            /***************************/
            /*                         */
            sp_rap_proj_mngr_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.sp_rap_proj_mngr_access',
                p_business_name => 'Generate RAPReporting PROJ MNGR access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.sp_rap_proj_mngr_access',
                    p_business_name => 'Generate RAPReporting PROJ MNGR access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;

        --RAP Reporting PROJECT REPORTING Access
        Begin
            /***************************/
            /*                         */
            sp_rap_proj_rpt_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                    p_proc_name     => 'tcmpl_app.config.sp_rap_proj_rpt_access',
                    p_business_name => 'Generate RAPReporting PROJ REPORTING access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.sp_rap_proj_rpt_access',
                    p_business_name => 'Generate RAPReporting PROJ REPORTING access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;


        --RAP Reporting SECRETARY Access
        Begin
            /***************************/
            /*                         */
            sp_rap_sec_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.sp_rap_sec_access',
                p_business_name => 'Generate RAPReporting Secertary access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.sp_rap_sec_access',
                    p_business_name => 'Generate RAPReporting Secertary access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;

        --RAP Reporting HoD Access
        Begin
            /***************************/
            /*                         */
            sp_rap_hod_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.sp_rap_hod_access',
                p_business_name => 'Generate RAPReporting HoD access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.sp_rap_hod_access',
                    p_business_name => 'Generate RAPReporting HoD access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;

        --RAP Reporting Director Access
        Begin
            /***************************/
            /*                         */
            sp_rap_director_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.sp_rap_director_access',
                p_business_name => 'Generate RAPReporting Director access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.sp_rap_director_access',
                    p_business_name => 'Generate RAPReporting Director access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;


    End;

End pkg_generate_user_access;
/
---------------------------
--Changed PACKAGE BODY
--PKG_APP_MAIL_QUEUE
---------------------------
CREATE OR REPLACE PACKAGE BODY "TCMPL_APP_CONFIG"."PKG_APP_MAIL_QUEUE" As
    c_mail_status_pending Constant Number(1) := 0;
    c_mail_status_sent    Constant Number(1) := 1;
    c_mail_status_error   Constant Number(1) := -1;
    Procedure sp_add_to_queue(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_mail_to          Varchar2,
        p_mail_cc          Varchar2,
        p_mail_bcc         Varchar2,
        p_mail_subject     Varchar2,
        p_mail_body1       Varchar2,
        p_mail_body2       Varchar2,
        p_mail_type        Varchar2,
        p_mail_from        Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_key_id  Varchar2(8);
        v_sysdate Date;
    Begin
        v_key_id       := dbms_random.string('X', 8);
        Insert Into app_mail_queue(
            key_id,
            entry_date,
            modified_on,
            status_code,
            status_message,
            mail_to,
            mail_cc,
            mail_bcc,
            mail_subject,
            mail_body1,
            mail_body2,
            mail_type,
            mail_from
        )
        Values(
            v_key_id,
            v_sysdate,
            v_sysdate,
            c_mail_status_pending,
            'Waiting',
            p_mail_to,
            p_mail_cc,
            p_mail_bcc,
            p_mail_subject,
            p_mail_body1,
            p_mail_body2,
            p_mail_type,
            p_mail_from
        );
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_update_mail_status_success(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_queue_key_id     Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Update
            app_mail_queue
        Set
            status_code = c_mail_status_sent,
            status_message = 'Sent',
            modified_on = sysdate
        Where
            key_id = p_queue_key_id;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_update_mail_status_error(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_queue_key_id     Varchar2,
        p_log_message      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Update
            app_mail_queue
        Set
            status_code = c_mail_status_error,
            status_message = p_log_message,
            modified_on = sysdate
        Where
            key_id = p_queue_key_id;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Function fn_mails_pending(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor
    Is
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                app_mail_queue
            Where
                status_code = c_mail_status_pending
                And Rownum <= p_page_length
            Order By
                entry_date;
        Return c;
    End;

End pkg_app_mail_queue;
/
---------------------------
--Changed PACKAGE BODY
--APP_CONSTANTS
---------------------------
CREATE OR REPLACE PACKAGE BODY "TCMPL_APP_CONFIG"."APP_CONSTANTS" As

    Function role_id_hod Return Varchar2 Is
    Begin
        Return c_role_hod;
    End;

    Function role_id_mngr_hod Return Varchar2 Is
    Begin
        Return c_role_mngr_hod;
    End;

    Function role_id_mngr_hod_onbehalf Return Varchar2 Is
    Begin
        Return c_role_mngr_hod_onbehalf;
    End;

    Function role_id_lead Return Varchar2 Is
    Begin
        Return c_role_lead;
    End;

    Function role_id_secretary Return Varchar2 Is
    Begin
        Return c_role_secretary;
    End;

    Function role_id_swp_seat_plan Return Varchar2 Is
    Begin
        Return c_role_seat_plan;
    End;

    --MODULES

    Function mod_id_swp Return Varchar2 As
    Begin
        Return c_mod_id_swp;
    End;

    Function mod_id_swp_vaccine Return Varchar2
    As
    Begin
        Return c_mod_id_swp_vaccine;
    End;

    Function mod_id_ofb Return Varchar2 As
    Begin
        Return c_mod_id_ofb;
    End;

    Function mod_id_selfservice Return Varchar2 As
    Begin
        Return c_mod_id_selfservice;
    End;

    Function mod_id_rap_reporting Return Varchar2 As
    Begin
        Return c_mod_id_rap_reporting;
    End;

    Function mod_id_hrmasters Return Varchar2 As
    Begin
        Return c_mod_id_hrmasters;
    End;

    Function mod_id_letter_of_credit Return Varchar2 As
    Begin
        Return c_mod_id_letter_of_credit;
    End;

End app_constants;
/
