--------------------------------------------------------
--  DDL for Function TEST
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."TEST" RETURN TAB%ROWTYPE
IS
DECLARE
   TYPE ROWS IS TABLE OF TAB%ROWTYPE;
   ReturnRows ROWS;
BEGIN
   SELECT * BULK COLLECT INTO ReturnRows FROM tab;
   Rvalue := ReturnRows;
END;

/
