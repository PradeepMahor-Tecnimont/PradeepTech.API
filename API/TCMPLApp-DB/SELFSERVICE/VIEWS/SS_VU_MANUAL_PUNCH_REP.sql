--------------------------------------------------------
--  DDL for View SS_VU_MANUAL_PUNCH_REP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_MANUAL_PUNCH_REP" ("EMPNO", "NAME", "PARENT", "GRADE", "P_DATE", "FIRST_PUNCH", "LAST_PUNCH", "PENDING_APPL", "EMP_OFFICE") AS 
  Select Distinct
    a.empno,
    b.name,
    b.parent,
    b.grade,
    to_char(pdate,'dd-Mon-yyyy') p_date,
    self_attendance.get_first_punch(
        a.empno,
        pdate
    ) first_punch,
    self_attendance.get_last_punch(
        a.empno,
        pdate
    ) last_punch,
    self_attendance.onduty_pending_approval(
        a.empno,
        pdate
    ) pending_appl,
    self_attendance.get_emp_office(
        a.empno,
        pdate
    ) emp_office
From
    ss_vu_manual_punch  a,
    ss_emplmast         b
Where
        a.empno = b.empno
;
