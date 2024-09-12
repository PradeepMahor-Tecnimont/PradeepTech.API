--------------------------------------------------------
--  DDL for View PROJPHASE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PROJPHASE" ("PHASE_SELECT", "DESCRIPTION", "PROJNO", "PHASE", "TMAGRP", "NAME") AS 
  (
select d.phase_select,d.description, d.projno,d.phase,d.tmagrp, c.name from
(select a.phase phase_select,a.description, b.projno,b.phase, b.tmagrp
 from job_phases a,job_proj_phase b
where a.timesheet = 1 and a.phase = b.phase_select(+)) d,costmast c
where d.tmagrp = c.costcode(+) )

;
