--------------------------------------------------------
--  DDL for View VU_TO_DELETE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."VU_TO_DELETE" ("EMPLOYEE_NAME", "PARENT", "APPLICATION_DATE", "APPLICATION_NO", "START_DATE", "END_DATE", "LEAVE_PERIOD", "LEAVE_TYPE", "LEAD", "MED_CERT_FILE_NAME") AS 
  Select
    l.empno || ' - ' || e.name       As employee_name,
    parent,
    app_date                         As application_date,
    app_no                           As application_no,
    bdate                            As start_date,
    edate                            As end_date,
    to_days(leaveperiod)             As leave_period,
    leavetype                        As leave_type,
    get_emp_name(l.lead_apprl_empno) As lead,
    med_cert_file_name
From
    ss_leaveapp                l, ss_emplmast e
Where
    (nvl(hod_apprl, ss.pending) = ss.pending)
    And l.empno                 = e.empno
    And nvl(lead_apprl, ss.pending) In (ss.approved, ss.apprl_none)
    And l.empno In (
        Select
            empno
        From
            ss_emplmast
        Where
            mngr = Trim('02640')
    )
Order By
    parent,
    l.empno
;
