--------------------------------------------------------
--  DDL for View SS_VU_4_LEAVE_CALENDAR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_4_LEAVE_CALENDAR" ("APP_NO", "EMPNO", "NAME", "APP_DATE", "BDATE", "EDATE", "WORK_LDATE", "LEAVETYPE", "REASON", "APPRL_STATUS") AS 
  SELECT
    a.app_no,
    a.empno,
    b.name,
    a.app_date,
    a.bdate,
    a.edate,
    a.work_ldate,
    a.leavetype,
    a.reason,
    nvl(a.hrd_apprl,ss.pending) apprl_status
FROM
    ss_leaveapp a,
    ss_emplmast b
WHERE
    a.empno = b.empno
AND
    a.edate >= SYSDATE - 365
AND
    a.leaveperiod > 8
AND
    b.mngr = '01412'
AND
    b.status = 1
AND
    nvl(a.hod_apprl,ss.pending) <> ss.rejected
AND
    nvl(a.lead_apprl,ss.pending) <> ss.rejected
AND
    nvl(a.hrd_apprl,ss.pending) <> ss.rejected
;
