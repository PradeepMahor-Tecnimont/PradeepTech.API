--------------------------------------------------------
--  DDL for View TM_STTUS_PIV
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TM_STTUS_PIV" ("EMPNO", "NAME", "'ToSubmit'", "'Submitted'", "'Locked'", "'Approved'", "'Posted'") AS 
  (
SELECT "EMPNO","NAME","'ToSubmit'","'Submitted'","'Locked'","'Approved'","'Posted'" FROM
(
select * from tm_status
)
PIVOT
(
  sum(rem)
  FOR remarks IN ('ToSubmit','Submitted','Locked','Approved','Posted')
)
)
;
