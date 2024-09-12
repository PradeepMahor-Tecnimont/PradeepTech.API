--------------------------------------------------------
--  DDL for View MISSINGEMAILMANAGERCONTRACT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."MISSINGEMAILMANAGERCONTRACT" ("EMPNO", "EMAIL") AS 
  (
select empno,email from emplmast
where empno in
(
select mngr from (select distinct mngr from emplmast where status = 1) where 
mngr in (select empno from emplmast where emptype <> 'R') and email is null
)
)

;
