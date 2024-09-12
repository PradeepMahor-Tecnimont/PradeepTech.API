--------------------------------------------------------
--  DDL for View ATTEND_VU_WEEK_ALL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."ATTEND_VU_WEEK_ALL" ("TEXT", "VAL", "WEEK_STATUS", "WK_START_DATE") AS 
  SELECT DISTINCT
        wk_start_date
        || ' - '
        || wk_end_date    text,
        to_char(wk_start_date,'dd-mm-yyyy')                            val,
        CASE
            WHEN attend_plan.get_week_start_date = wk_start_date    THEN
                'CURRENT WEEK'
            WHEN attend_plan.get_week_start_date < wk_start_date    THEN
                'NEXT WEEK'
            ELSE
                'PAST WEEK'
        END week_status,
        wk_start_date
    FROM
        attend_plan_wk
    ORDER BY
        wk_start_date DESC
;
