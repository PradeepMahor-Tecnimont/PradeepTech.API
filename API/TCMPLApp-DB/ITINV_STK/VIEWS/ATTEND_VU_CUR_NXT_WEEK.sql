--------------------------------------------------------
--  DDL for View ATTEND_VU_CUR_NXT_WEEK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."ATTEND_VU_CUR_NXT_WEEK" ("TEXT", "VAL") AS 
  SELECT
    'Current Week ('
    || to_char(attend_plan.get_week_start_date,'DD-Mon-YYYY')
    || ' - '
    || to_char(attend_plan.get_week_end_date,'DD-Mon-YYYY')
    || ')' text,
    to_char(attend_plan.get_week_start_date,'yyyy-mm-dd') val
FROM
    dual
UNION ALL
SELECT
    'Next Week ('
    || to_char(attend_plan.get_week_start_date + 7,'DD-Mon-YYYY')
    || ' - '
    || to_char(attend_plan.get_week_end_date + 7,'DD-Mon-YYYY')
    || ')' text,
    to_char(attend_plan.get_week_start_date + 7,'yyyy-mm-dd') val
FROM
    dual
WHERE attend_plan.get_today_day > 4
;
