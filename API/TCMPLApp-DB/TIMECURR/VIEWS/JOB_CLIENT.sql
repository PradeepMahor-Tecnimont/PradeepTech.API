--------------------------------------------------------
--  DDL for View JOB_CLIENT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."JOB_CLIENT" ("PROJNO", "PHASE_SELECT", "SHORT_DESC", "TCMNO", "TMAGRP", "NAME", "LOCATION", "JOB_OPEN_DATE", "BU_TYPE", "BUTYPEDESC") AS 
  (select a.projno,a.phase_select,b.short_desc,b.tcmno, 
a.tmagrp,c.name,
b.location,
b.job_open_date,b.bu_type,d.name butypedesc from job_proj_phase a, jobmaster b , clntmast c , JOB_BU_TYPE d
where a.projno = b.projno and b.client = c.client and nvl(b.bu_type,'') = d.BU_TYPE)
;
