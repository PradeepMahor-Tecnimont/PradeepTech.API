--------------------------------------------------------
--  DDL for View ATTEND_VU_PLAN_ACTUAL_STATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."ATTEND_VU_PLAN_ACTUAL_STATUS" ("PLANNED_DATE", "EMPNO", "NAME", "PARENT", "ASSIGN", "PLAN", "ACTUAL") AS 
  SELECT
    planned_date,
    h.empno,
    e.name,
    e.parent,
    e.assign,
    'Planned'                                                plan,
    attend_plan.isabsent(planned_date, h.empno, 0)           actual
FROM
    attend_plan_wk_history  h,
    vu_emplmast             e
WHERE
    h.empno = e.empno
UNION ALL
SELECT
    punch_date,
    empno,
    name,
    parent,
    assign,
    'Unplanned' plan,
    'P'
FROM
    attend_plan_calendar  c,
    vu_emplmast           e
WHERE
        selfservice.isabsent(empno, punch_date) = 0
    AND NOT EXISTS (
        SELECT
            *
        FROM
            attend_plan_wk_history h
        WHERE
                h.planned_date = c.punch_date
            AND h.empno = e.empno
    )
;
