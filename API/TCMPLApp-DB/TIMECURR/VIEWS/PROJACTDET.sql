--------------------------------------------------------
--  DDL for View PROJACTDET
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PROJACTDET" ("PROJNO", "PROJNAME", "YYMM", "COSTCODE", "COSTNAME", "TLPCODE", "TLPNAME", "TOTHOURS") AS 
  SELECT PROJNO,
GETPROJNAME(PROJNO)as Projname,YYMM,COSTCODE,
GETCOSTNAME(COSTCODE)as Costname,TLPCODE,
GETTLPNAME(COSTCODE,TLPCODE)as Tlpname,TOTHOURS 
FROM PROJACTIVITY

;
