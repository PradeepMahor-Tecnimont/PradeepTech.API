--------------------------------------------------------
--  DDL for View SS_HEALTH_STATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_HEALTH_STATUS" ("EMPNO", "YYYY", "APPLNO", "DEP", "CLINIC", "LOCATION", "CHKDATE", "WEIGHT", "RPT_DATE", "MSTATUS", "CLINIC_NAME") AS 
  select a.empno,a.yyyy,a.applno,a.dep,a.clinic,a.location,b.chkdate,
c.weight,c.rpt_date,c.mstatus,e.clinic_name 
from ss_health_emp a,ss_health_hrd b,ss_health_rpt c,ss_clinic e 
where a.applno = b.applno and a.applno = c.applno 
and a.clinic = e.clinic order by yyyy desc, b.chkdate desc,c.mstatus
;
