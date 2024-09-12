--------------------------------------------------------
--  DDL for View TEMPVIEW1
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TEMPVIEW1" ("EMPNO", "NAME", "DEP") AS 
  (select empno,name,decode(assign,'0236',1,'0238',1,0) as dep from emplmast where parent in ('0106','0107'))
;
