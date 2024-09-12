--------------------------------------------------------
--  DDL for View OPENMAST_A
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."OPENMAST_A" ("PROJNO", "COSTCODE", "OPENLAST01", "CURR01", "OPEN01", "OPENLAST04", "CURR04", "OPEN04") AS 
  (select projno, costcode,sum(nvl(openlast01,0)) as openlast01,
sum(nvl(curr01,0)) as curr01,sum(nvl(open01,0)) as open01,
sum(nvl(openlast04,0)) as openlast04,sum(nvl(curr04,0)) as curr04,
sum(nvl(open04,0)) as open04 from openmast_0203 group by projno,costcode)

;
