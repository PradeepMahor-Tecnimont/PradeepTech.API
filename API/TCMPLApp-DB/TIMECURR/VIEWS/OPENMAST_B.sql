--------------------------------------------------------
--  DDL for View OPENMAST_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."OPENMAST_B" ("PROJNO", "COSTCODE", "OPENLAST01", "CURR01", "OPEN01", "OPENLAST04", "CURR04", "OPEN04") AS 
  (select projno, costcode,
openlast01, curr01, nvl(openlast01,0)+ nvl(curr01,0) as open01,
openlast04, curr04, nvl(openlast04,0)+ nvl(curr04,0) as open04
from openmast_A )

;
