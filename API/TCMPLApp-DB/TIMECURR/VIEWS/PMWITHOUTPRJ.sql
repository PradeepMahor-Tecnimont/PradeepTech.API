--------------------------------------------------------
--  DDL for View PMWITHOUTPRJ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PMWITHOUTPRJ" ("EMPNO", "NAME", "DESG", "PARENT", "ASSIGN") AS 
  (
select empno,name,b.desg,a.parent,a.assign from emplmast a , desgmast b where a.desgcode = b.desgcode and 
a.projmngr = 1 and a.status = 1 and a.empno
not in (select distinct pm_empno from jobmaster)
and a.empno not in 
(select distinct hod from costmast)
)
;
