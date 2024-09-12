--------------------------------------------------------
--  DDL for View POSTINGDATA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."POSTINGDATA" ("MASTKEYID", "YYMM", "PARENT", "ASSIGN", "GRP", "COMPANY", "PROJNO", "EMPNO", "WPCODE", "ACTIVITY", "REASONCODE", "NHRS", "OHRS") AS 
  select mastkeyid,yymm,parent,assign,grp,company,projno,empno,wpcode,activity,reasoncode,sum(nvl(total,0)) as nhrs,0000.00 as ohrs from time_daily group by mastkeyid,yymm,parent,assign,grp,company,projno,empno,wpcode,activity,reasoncode union all
select mastkeyid,yymm,parent,assign,grp,company,projno,empno,wpcode,activity,reasoncode,0000.00 as nhrs,sum(nvl(total,0)) as ohrs from time_ot group by mastkeyid,yymm,parent,assign,grp,company,projno,empno,wpcode,activity,reasoncode
;
