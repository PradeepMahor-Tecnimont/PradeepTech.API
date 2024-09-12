--------------------------------------------------------
--  DDL for View PROJECTIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PROJECTIONS" ("CURREXPT", "PHASE", "COSTCODE", "PROJNO", "YYMM", "HOURS", "PRJDESC", "TMAGRP", "TCMNO", "CCDESC", "ACTIVEFUTURE", "PROJ_TYPE") AS 
  (
(select 'C' AS CURREXPT,SUBSTR(A.PROJNO,6,2) AS PHASE , a."COSTCODE",a."PROJNO",a."YYMM",a."HOURS",b.name as prjdesc ,b.newcostcode as tmagrp ,b.tcmno ,c.name as ccdesc, 0 as activeFuture ,'' as  proj_type  from prjcmast a,projmast b ,costmast c where a.costcode = c.costcode
and a.projno = b.projno and a.yymm >= '201601') 
union



(select 'E' AS CURREXPT,decode(c.tma_grp,'E','E','N') AS PHASE ,a."COSTCODE",a."PROJNO",a."YYMM",a."HOURS",b.name as prjdesc ,b.newcostcode as tmagrp ,
b.tcmno ,c.name as ccdesc, b.active as activeFuture ,  decode(b.proj_type,null,'2',b.PROJ_TYPE) as proj_type from exptprjc a,exptjobs b ,costmast c where a.costcode = c.costcode
and a.projno = b.projno and a.yymm >= '201601'  and (b.active = 1 or b.ACTIVEFUTURE = 1) ) 
)
;
