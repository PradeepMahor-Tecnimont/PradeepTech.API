--------------------------------------------------------
--  File created - Thursday-March-24-2022   
--------------------------------------------------------
---------------------------
--New TABLE
--APP_MAIL_QUEUE
---------------------------
  CREATE TABLE "TCMPL_APP_CONFIG"."APP_MAIL_QUEUE" 
   (	"KEY_ID" VARCHAR2(8),
	"ENTRY_DATE" DATE,
	"MODIFIED_ON" DATE,
	"STATUS_CODE" NUMBER(1,0),
	"STATUS_MESSAGE" VARCHAR2(4000),
	"MAIL_TO" VARCHAR2(4000),
	"MAIL_CC" VARCHAR2(4000),
	"MAIL_BCC" VARCHAR2(4000),
	"MAIL_SUBJECT" VARCHAR2(1000),
	"MAIL_BODY1" VARCHAR2(4000),
	"MAIL_BODY2" VARCHAR2(4000),
	"MAIL_TYPE" VARCHAR2(10),
	"MAIL_FROM" VARCHAR2(100),
	"MAIL_ATTACHMENTS" VARCHAR2(4000)
   );
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
        And mr.module_id = 'M05'
        And c.costcode Not In (
            Select
                assign
            From
                selfservice.swp_exclude_assign
        )
        And c.noofemps > 0
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
        Null         module_name,
        mr.role_id,
        r.role_desc,
        sec.empno,
        sec.personid person_id,
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
                    Where
                        parent Not In (
                            Select
                                assign
                            From
                                selfservice.swp_exclude_assign
                        )
                )
        )                       sec,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_secretary
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.role_id(+)
        And mr.module_id = 'M05'
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
        And mr.module_id <> 'M05'
    Union
    Select
        mr.module_id,
        Null         module_name,
        mr.role_id,
        r.role_desc,
        sec.empno,
        sec.personid person_id,
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
                    Where
                        parent In (
                            Select
                                assign
                            From
                                selfservice.swp_include_assign_4_seat_plan
                        )
                )
        )                       sec,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_swp_seat_plan
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.role_id(+)
        And mr.module_id = 'M05'
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
        And mr.module_id <> 'M05'
        And c.costcode In (
            Select
                assign
            From
                selfservice.swp_include_assign_4_seat_plan
        );
---------------------------
--New PACKAGE
--PKG_APP_MAIL_QUEUE
---------------------------
CREATE OR REPLACE PACKAGE "TCMPL_APP_CONFIG"."PKG_APP_MAIL_QUEUE" As

    Procedure sp_add_to_queue(
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
        p_queue_key_id     Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_update_mail_status_error(
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

    c_role_hod Constant Varchar2(4) := 'R002';
    c_role_secretary Constant Varchar2(4) := 'R003';
    c_role_mngr_hod Constant Varchar2(4) := 'R004';
    c_role_mngr_hod_onbehalf Constant Varchar2(4) := 'R005';
    c_role_lead Constant Varchar2(4) := 'R006';

    c_role_seat_plan Constant Varchar2(4) := 'R029';

    Function role_id_hod Return Varchar2;

    Function role_id_mngr_hod Return Varchar2;

    Function role_id_mngr_hod_onbehalf Return Varchar2;

    Function role_id_lead Return Varchar2;

    Function role_id_secretary Return Varchar2;

    Function role_id_swp_seat_plan Return Varchar2;

End app_constants;
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


End app_constants;
/
---------------------------
--New PACKAGE BODY
--PKG_APP_MAIL_QUEUE
---------------------------
CREATE OR REPLACE PACKAGE BODY "TCMPL_APP_CONFIG"."PKG_APP_MAIL_QUEUE" As
    c_mail_status_pending Constant Number(1) := 0;
    c_mail_status_sent    Constant Number(1) := 1;
    c_mail_status_error   Constant Number(1) := -1;
    Procedure sp_add_to_queue(
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
