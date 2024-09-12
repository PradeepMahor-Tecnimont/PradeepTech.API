--------------------------------------------------------
--  DDL for View SS_CONSCENT_REP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_CONSCENT_REP" ("FLAG_BUS", "FLAG_YES", "TOTAL") AS 
  select flag_bus, flag_yes, Count(Flag_Yes)  Total from ss_conscent
group by flag_bus, flag_yes order by flag_bus, flag_yes
;
