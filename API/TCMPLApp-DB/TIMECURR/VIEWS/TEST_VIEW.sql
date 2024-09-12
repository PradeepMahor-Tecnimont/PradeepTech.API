--------------------------------------------------------
--  DDL for View TEST_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TEST_VIEW" ("PROJNO", "TCMNO", "NAME", "SAPCC", "'201904'", "'201905'", "'201906'", "'201907'", "'201908'", "'201909'", "'201910'", "'201911'", "'201912'", "'202001'", "'202002'", "'202003'") AS 
  (
SELECT "PROJNO" , "TCMNO","NAME","SAPCC","'201904'","'201905'","'201906'","'201907'","'201908'","'201909'","'201910'","'201911'","'201912'","'202001'","'202002'","'202003'" FROM
(
  SELECT projno,TCMNO,NAME,SAPCC,yymm,tothours
  FROM prj_cc_tcm where tothours <> 0 and yymm >= '201904'
)
PIVOT
(
  sum(tothours)
  FOR yymm IN ('201904','201905','201906','201907','201908','201909','201910','201911','201912','202001','202002','202003')
)
)
;
