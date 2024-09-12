--------------------------------------------------------
--  DDL for Function DM_OFFICE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."DM_OFFICE" (vDeskid IN VARCHAR2) 
  RETURN VARCHAR2 IS
  vOffice Varchar2(4);
BEGIN
  Select trim(Office) INTO vOffice 
  from dm_deskmaster
  where deskid = vDeskid;

  Return vOffice;
END DM_OFFICE;


/
