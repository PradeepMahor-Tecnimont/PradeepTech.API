--------------------------------------------------------
--  DDL for View LEFT_PM_PROJMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."LEFT_PM_PROJMAST" ("PROJNO", "NAME", "PRJMNGR") AS 
  (
select PROJNO,NAME,PRJMNGR from projmast
where  cdate is null 
and prjmngr in (select empno from emplmast where dol is not null)
and substr(projno,6,2)  not in ('LA','LB','LC','LD','LM','00','52')
)

;
