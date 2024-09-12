--------------------------------------------------------
--  DDL for Procedure DELETEOT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."DELETEOT" (p_AppNo IN Varchar2) IS
BEGIN
  	Delete from SS_OTDetail Where App_No = Trim(p_AppNo);
  	Delete from SS_OTMaster Where App_No = Trim(p_AppNo);
  	Commit;
END;


/
