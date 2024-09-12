--------------------------------------------------------
--  DDL for View LEFT_INCHARGE_JOBMASTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."LEFT_INCHARGE_JOBMASTER" ("PROJNO", "SHORT_DESC", "INCHARGE", "ACTUAL_CLOSING_DATE", "APPROVED_AMFI") AS 
  (
select PROJNO,short_desc , INCHARGE,actual_closing_date,approved_amfi from jobmaster
where 
INCHARGE in (select empno from emplmast where dol is not null) and nvl(approved_amfi,0) = 0)
;
