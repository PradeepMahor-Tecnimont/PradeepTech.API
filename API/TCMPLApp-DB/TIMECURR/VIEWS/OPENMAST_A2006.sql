--------------------------------------------------------
--  DDL for View OPENMAST_A2006
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."OPENMAST_A2006" ("PROJNO", "COSTCODE", "OPENLAST01", "CURR01", "OPEN01", "OPENLAST04", "CURR04", "OPEN04") AS 
  (select projno,costcode,sum(nvl(openlast01,0)) as openlast01,
sum(nvl(curr01,0)) as curr01,sum(nvl(openlast01,0))+sum(nvl(curr01,0)) as open01,sum(nvl(openlast04,0)) as openlast04,
sum(nvl(curr04,0)) as curr04,sum(nvl(openlast04,0))+sum(nvl(curr04,0)) as open04 from openmast_0607 group by projno,costcode)

;
