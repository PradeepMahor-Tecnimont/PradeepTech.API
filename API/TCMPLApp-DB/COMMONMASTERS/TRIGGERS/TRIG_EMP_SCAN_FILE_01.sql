--------------------------------------------------------
--  DDL for Trigger TRIG_EMP_SCAN_FILE_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "COMMONMASTERS"."TRIG_EMP_SCAN_FILE_01" Before
    Insert On emp_scan_file
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    If :new.file_type = 'GT' Then
        Update emp_lock_status
        Set
            gtli_lock = pkg_ed.ed_locked
        Where
            empno = :new.empno;

        If Sql%rowcount = 0 Then
            Insert Into emp_lock_status (
                empno,
                prim_lock_open,
                nom_lock_open,
                fmly_lock_open,
                adhaar_lock,
                pp_lock,
                login_lock_open,
                gtli_lock
            ) Values (
                :new.empno,
                pkg_ed.ed_open,
                pkg_ed.ed_open,
                pkg_ed.ed_open,
                pkg_ed.ed_open,
                pkg_ed.ed_open,
                pkg_ed.ed_open,
                pkg_ed.ed_locked
            );

        End If;

    End If;
End;
/
ALTER TRIGGER "COMMONMASTERS"."TRIG_EMP_SCAN_FILE_01" ENABLE;
