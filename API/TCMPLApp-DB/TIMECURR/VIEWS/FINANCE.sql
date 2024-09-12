--------------------------------------------------------
--  DDL for View FINANCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."FINANCE" ("YYMM", "COSTCODE", "EMPTYPE", "TOTHRS") AS 
  (
 select A.YYMM yymm,a.costcode COSTCODE ,b.emptype EMPTYPE,sum(nvl(a.hours,0)) +
   sum(nvl(a.othours,0)) TOTHRS
  from timetran a,emplmast b  where
 a.projno in (select projno from projmast
  where co = 'E' ) and
  a.projno not in
  ('1111400','2222400','5555400','6666400',
 'E111400','E222400','E555400','E666400')
   and a.empno = b.empno
 group by A.YYMM,a.costcode,b.emptype
  )

;
