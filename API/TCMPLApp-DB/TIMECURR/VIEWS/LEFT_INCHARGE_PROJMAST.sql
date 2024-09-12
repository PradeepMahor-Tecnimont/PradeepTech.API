--------------------------------------------------------
--  DDL for View LEFT_INCHARGE_PROJMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."LEFT_INCHARGE_PROJMAST" ("PROJNO", "NAME", "PRJDYMNGR") AS 
  (
select PROJNO,name, prjdymngr   from projmast
where  cdate is null 
and prjdymngr in (select empno from emplmast where dol is not null)
)
;
