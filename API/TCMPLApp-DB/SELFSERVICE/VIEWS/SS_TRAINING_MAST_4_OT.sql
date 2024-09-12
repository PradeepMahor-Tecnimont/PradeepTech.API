--------------------------------------------------------
--  DDL for View SS_TRAINING_MAST_4_OT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_TRAINING_MAST_4_OT" ("TR_NO", "TR_NAME", "INT_EXT", "CONDUCTED_BY", "FROM_DATE", "TO_DATE", "GRP", "COURSEFEES", "YYYY", "ITRELATED", "TR_TYPE", "OT_APPL") AS 
  SELECT 
    "TR_NO","TR_NAME","INT_EXT","CONDUCTED_BY","FROM_DATE","TO_DATE","GRP","COURSEFEES","YYYY","ITRELATED","TR_TYPE","OT_APPL" 
FROM
trainingnew.trainingmaster
;
