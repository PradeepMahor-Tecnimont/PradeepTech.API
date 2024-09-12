--------------------------------------------------------
--  DDL for Trigger TRIG_USERIDS_02
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."TRIG_USERIDS_02" Before
    Delete Or Insert Or Update On userids
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    If inserting Then
        Insert Into userid_log (
            userid_nu,
            empno_nu,
            modified_on,
            operation
        ) Values (
            :new.userid,
            :new.empno,
            Sysdate,
            'INSERT'
        );

    Elsif updating Then
        If Upper(:old.userid) <> Upper(:new.userid) Or Upper(:old.empno) <> Upper(:new.empno) Then
            Insert Into userid_log (
                userid_old,
                empno_old,
                userid_nu,
                empno_nu,
                modified_on,
                operation
            ) Values (
                :old.userid,
                :old.empno,
                :new.userid,
                :new.empno,
                Sysdate,
                'UPDATE'
            );

        End If;
    Elsif deleting Then
        Insert Into userid_log (
            userid_old,
            empno_old,
            modified_on,
            operation
        ) Values (
            :old.userid,
            :old.empno,
            Sysdate,
            'DELETE'
        );

    End If;
End;

/
ALTER TRIGGER "SELFSERVICE"."TRIG_USERIDS_02" ENABLE;
