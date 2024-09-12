--------------------------------------------------------
--  DDL for View TEMPTEST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."TEMPTEST" ("EMPNO", "HH", "MM", "PDATE", "DD", "MON", "YYYY", "HHSORT", "MMSORT") AS 
  (select empno,hh,mm,pdate,dd,mon,yyyy,hh hhsort, mm mmsort from ss_punch) union
(select empno,hh,mm,pdate,dd,mon,yyyy,hhsort,mmsort from ss_onduty)
;
