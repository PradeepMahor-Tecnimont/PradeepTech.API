--------------------------------------------------------
--  DDL for View ATTEND_VU_SHIFTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."ATTEND_VU_SHIFTS" ("SHIFT_TEXT", "SHIFT_VAL") AS 
  SELECT 'General Shift' shift_text, 'GS' shift_val from dual

union all

SELECT 'First Shift' shift_text, 'FS' shift_val  from dual

union all

SELECT 'Second Shift' shift_text, 'SS' shift_val from dual
;
