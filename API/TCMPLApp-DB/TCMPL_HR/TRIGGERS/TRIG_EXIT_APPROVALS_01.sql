--------------------------------------------------------
--  DDL for Trigger TRIG_EXIT_APPROVALS_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TCMPL_HR"."TRIG_EXIT_APPROVALS_01" Before
    Update Of empno, action_id, role_id, approval_date, approved_by, is_approved, remarks On ofb_emp_exit_approvals
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    Declare
        v_key_id Varchar2(8);
    Begin
        v_key_id := dbms_random.string('X', 8);
        Insert Into ofb_exit_approvals_log (
            empno,
            action_id,
            is_approved,
            remarks,
            approved_by,
            modified_on,
            key_id
        ) Values (
            :new.empno,
            :new.action_id,
            :new.is_approved,
            :new.remarks,
            :new.approved_by,
            Sysdate,
            v_key_id
        );

        Insert Into ofb_exit_approvals_log (
            empno,
            action_id,
            is_approved,
            remarks,
            approved_by,
            modified_on,
            key_id
        ) Values (
            :new.empno,
            :new.action_id,
            :old.is_approved,
            :old.remarks,
            :old.approved_by,
            Sysdate,
            v_key_id
        );

    End;
End;

/
ALTER TRIGGER "TCMPL_HR"."TRIG_EXIT_APPROVALS_01" ENABLE;
