--------------------------------------------------------
--  DDL for Procedure DT_DROPUSEROBJECTBYID
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."DT_DROPUSEROBJECTBYID" ( PARAM_ID IN NUMBER ) AS BEGIN DELETE FROM MICROSOFTDTPROPERTIES WHERE OBJECTID = PARAM_ID; END DT_DROPUSEROBJECTBYID; /
 

/
