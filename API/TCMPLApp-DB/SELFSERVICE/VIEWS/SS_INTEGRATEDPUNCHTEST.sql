--------------------------------------------------------
--  DDL for View SS_INTEGRATEDPUNCHTEST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_INTEGRATEDPUNCHTEST" ("EMPNO", "HH", "MM", "PDATE", "DD", "MON", "YYYY", "HHSORT", "MMSORT", "FROMTAB", "TYPE", "ODTYPE") AS 
  (select empno,hh,mm,pdate,dd,mon,yyyy,hh hhsort, mm mmsort, 1 FromTab, 'PP' As Type,0 As ODTYPE from ss_punch) union all
(select empno,hh,mm,pdate,dd,mon,yyyy,hhsort,mmsort, 2 FromTab, Type,ODType from ss_onduty where type <> 'LE' And  type <> 'SL')
;
