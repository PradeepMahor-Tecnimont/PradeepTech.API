--------------------------------------------------------
--  DDL for View SS_CONSTRAINT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_CONSTRAINT" ("CONSTRAINT_NAME", "TABLE_NAME", "CONSTRAINT_TYPE") AS 
  select constraint_name, table_name, constraint_type from
user_constraints
;
