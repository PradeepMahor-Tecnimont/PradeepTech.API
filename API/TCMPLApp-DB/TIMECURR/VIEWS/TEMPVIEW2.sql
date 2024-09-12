--------------------------------------------------------
--  DDL for View TEMPVIEW2
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TEMPVIEW2" ("EMPNO", "NAME", "LOC") AS 
  (select empno,name,decode(assign,'0236',1,'0238',1,0) as loc from emplmast where parent in ('0106','0107'))
;
