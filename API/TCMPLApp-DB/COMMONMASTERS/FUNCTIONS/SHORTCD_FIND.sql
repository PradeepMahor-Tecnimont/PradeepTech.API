--------------------------------------------------------
--  DDL for Function SHORTCD_FIND
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "COMMONMASTERS"."SHORTCD_FIND" 
  ( V_SHORTCD IN VARCHAR2)
  RETURN  NUMBER IS
  V_RETURN NUMBER;
BEGIN 
  V_RETURN := 0;
  --SELECT COUNT(*) INTO V_RETURN FROM LIST1 WHERE NVL(NEW_SHORTCD,' ') = V_SHORTCD;
  --SELECT COUNT(*) INTO V_RETURN FROM LIST1 WHERE trim(NEW_SHORTCD) = trim(V_SHORTCD);
  SELECT COUNT(*) INTO V_RETURN FROM EMPLMAST WHERE EMPTYPE = 'R' AND STATUS = 1 AND trim(ABBR) = trim(V_SHORTCD);
  RETURN V_RETURN;
EXCEPTION
   WHEN OTHERS THEN
       RETURN -1;
END;

/
