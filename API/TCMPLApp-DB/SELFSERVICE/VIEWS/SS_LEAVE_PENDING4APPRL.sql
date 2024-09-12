--------------------------------------------------------
--  DDL for View SS_LEAVE_PENDING4APPRL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_LEAVE_PENDING4APPRL" ("EMPNO", "APP_NO", "APP_DATE", "LEAVETYPE", "REASON", "LEAVE_PERIOD", "BDATE", "EDATE") AS 
  Select
    a.empno,
    a.app_no,
    a.app_date, 
    a.leavetype,
    a.reason,
    ( a.leaveperiod / 8 ) leave_period,
    a.bdate,
    a.edate
From
    ss_leaveapp  a

Where

    ( Nvl(a.lead_apprl, ss.pending) = ss.pending
          Or ( Nvl(a.lead_apprl, ss.pending) In (
        ss.pending,
        ss.apprl_none,
        ss.approved
    )
               And Nvl(a.hod_apprl, ss.pending) In (
        ss.pending
    ) )
          Or ( Nvl(a.lead_apprl, ss.pending) In (
        ss.pending,
        ss.apprl_none,
        ss.approved
    )
               And Nvl(a.hod_apprl, ss.pending) In (
        ss.pending,
        ss.approved
    )
               And hrd_apprl In (
        ss.pending
    ) ) )
;
