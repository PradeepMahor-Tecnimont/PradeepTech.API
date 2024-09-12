--------------------------------------------------------
--  DDL for View TM_STATUS_UPD_PIV
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TM_STATUS_UPD_PIV" ("EMPNO", "NAME", "ASSIGN", "YYMM", "'Eligible'", "'Filled'", "'Locked'", "'Approved'", "'Posted'") AS 
  (
select empno,name,assign,yymm,    "'Eligible'","'Filled'","'Locked'","'Approved'","'Posted'" from
(
select * from tm_status_upd
)
PIVOT
(
  sum(rem)
  FOR remarks IN ('Eligible' as Eligible,'Filled' as Filled,'Locked' as Locked,'Approved' as Approved,'Posted' as Posted)
)
)
;
