--------------------------------------------------------
--  DDL for Trigger TRIG_EMP_LOCK_STATUS_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "COMMONMASTERS"."TRIG_EMP_LOCK_STATUS_01" Before
    Insert Or Update Of empno, prim_lock_open, fmly_lock_open, nom_lock_open, gtli_lock On emp_lock_status
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    :new.modified_on := Sysdate;
    If :new.nom_lock_open = pkg_ed.ed_open Then
        Update emp_nomination_status
        Set
            submitted = 'KO',
            modified_by = 'Sys'
        Where
            empno = :old.empno;

        If Sql%rowcount = 0 Then
            Insert Into emp_nomination_status (
                empno,
                submitted,
                modified_on,
                modified_by
            ) Values (
                :new.empno,
                'KO',
                Sysdate,
                'Sys'
            );

        End If;

    End If;

    If :new.gtli_lock = pkg_ed.ed_open Then
        Delete From emp_scan_file
        Where
            empno = :new.empno
            And file_type = 'GT';

    End If;

End;
/
ALTER TRIGGER "COMMONMASTERS"."TRIG_EMP_LOCK_STATUS_01" ENABLE;
