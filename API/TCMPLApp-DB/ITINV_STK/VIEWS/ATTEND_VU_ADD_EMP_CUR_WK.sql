--------------------------------------------------------
--  DDL for View ATTEND_VU_ADD_EMP_CUR_WK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."ATTEND_VU_ADD_EMP_CUR_WK" ("WEEK_START_DATE", "WEEK_END_DATE", "EMPNO", "NAME", "PARENT", "ASSIGN") AS 
  SELECT
    attend_plan.get_week_start_date    week_start_date,
    attend_plan.get_week_end_date      week_end_date,
    e.empno                            empno,
    e.name,
    e.parent,
    e.assign
FROM
    vu_emplmast e
WHERE
        e.status = 1
    AND NOT EXISTS (
        SELECT
            *
        FROM
            attend_plan_wk a
        WHERE
                a.empno = e.empno
            AND a.wk_start_date = attend_plan.get_week_start_date
            AND a.wk_end_date = attend_plan.get_week_end_date
    )
;
