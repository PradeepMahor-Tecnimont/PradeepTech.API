--------------------------------------------------------
--  DDL for View SS_LEAVE_APP_LEDG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_LEAVE_APP_LEDG" ("APP_NO", "EMPNO", "LEAVETYPE", "BDATE", "EDATE") AS 
  select distinct "APP_NO","EMPNO","LEAVETYPE","BDATE","EDATE" from (
select app_no, empno, leavetype, bdate, nvl(edate,bdate) edate from ss_leaveapp
union all
select app_no, empno, leavetype, bdate, nvl(edate,bdate) edate from ss_leaveledg where adj_type in ('LA') and db_cr = 'D' )
;
