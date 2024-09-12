--------------------------------------------------------
--  DDL for View SS_USERMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SS_USERMAST" ("EMPNO", "TYPE", "DESCRIPTION", "ACTIVE", "TCP_IP") AS 
  SELECT "EMPNO","TYPE","DESCRIPTION","ACTIVE","TCP_IP" 
    
FROM selfservice.SS_USERMAST
;
