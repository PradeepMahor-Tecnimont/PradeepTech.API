--------------------------------------------------------
--  DDL for Procedure DT_DROPUSEROBJECTBYID
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "LOGBOOK1"."DT_DROPUSEROBJECTBYID" ( PARAM_ID IN NUMBER ) AS BEGIN DELETE FROM MICROSOFTDTPROPERTIES WHERE OBJECTID = PARAM_ID; END DT_DROPUSEROBJECTBYID; 

/
