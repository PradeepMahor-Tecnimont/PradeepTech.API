--------------------------------------------------------
--  DDL for View JOB_PROJ_PH_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."JOB_PROJ_PH_LIST" ("PROJNO", "PHASE_SELECT", "TMAGRP", "NAME", "TCMNO", "JOB_OPEN_DATE", "CLIENT", "CLIENTNAME", "T_LOCATION", "INDUSTRY") AS 
  (select a.projno,a.phase_select,a.tmagrp,b.name,b.tcmno,c.job_open_date,c.client,d.NAME clientname,c.t_location,e.name Industry from job_proj_phase a,projmast b ,jobmaster c,clntmast d , job_industry e 
  where a.projno||a.phase_select = b.projno   and  a.projno = c.projno and c.client = d.client and c.industry = e.industry)
;
