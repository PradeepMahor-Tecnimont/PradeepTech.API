--------------------------------------------------------
--  DDL for View LIST_CROSS_COMPANY_DETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."LIST_CROSS_COMPANY_DETAILS" ("EMPNO", "NAME", "COMPANY", "CO", "YYMM", "ASSIGN", "PROJNO", "NHRS", "OHRS") AS 
  select a.empno,a.name,a.company,c.co,B.YYMM,b.assign,b.projno,nhrs,ohrs from emplmast a,jobwise b ,projmast c
where b.projno not in('1111400','6666400','2222400') and a.empno = b.empno and b.projno = c.projno and substr(a.company,1,1) <> c.co
order by b.assign

;
