--------------------------------------------------------
--  DDL for View ATTEND_VU_DESK_PLANNER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."ATTEND_VU_DESK_PLANNER" ("WK_START_DATE", "WK_END_DATE", "PLANNED_DATE", "EMPNO", "NAME", "PARENT", "ASSIGN", "DEVICE", "DESKID", "OFFICE", "FLOOR", "WING", "PLANNED") AS 
  SELECT
    a.wk_start_date,
    a.wk_end_date,
    attend_plan.get_next_working_day        planned_date,
    a.empno,
    e.name,
    e.parent,
    e.assign,
    attend_plan.get_device(a.empno)         device,
    CASE TRIM(nvl(daa.office, 'NA'))
        WHEN 'Home'  THEN
            NULL
        WHEN 'NA'    THEN
            NULL
        ELSE
            daa.deskid
    END deskid,
    CASE TRIM(nvl(daa.office, 'NA'))
        WHEN 'Home'  THEN
            NULL
        WHEN 'NA'    THEN
            NULL
        ELSE
            daa.office
    END office,
    CASE TRIM(nvl(daa.office, 'NA'))
        WHEN 'Home'  THEN
            NULL
        WHEN 'NA'    THEN
            NULL
        ELSE
            daa.floor
    END floor,
    CASE TRIM(nvl(daa.office, 'NA'))
        WHEN 'Home'  THEN
            NULL
        WHEN 'NA'    THEN
            NULL
        ELSE
            daa.wing
    END wing,
    CASE attend_plan.get_today_day
        WHEN 1  THEN
            mon
        WHEN 7  THEN
            mon
        WHEN 2  THEN
            tue
        WHEN 3  THEN
            wed
        WHEN 4  THEN
            thu
        WHEN 5  THEN
            fri
        WHEN 6  THEN
            sat
    END planned
FROM
    attend_plan_wk  a,
    vu_emplmast     e,
    (
        SELECT
            *
        FROM
            (
                SELECT
                    empno1,
                    deskid,
                    office,
                    floor,
                    wing,
                    ROW_NUMBER() OVER(PARTITION BY empno1
                        ORDER BY
                            empno1, deskid
                    ) rn
                FROM
                    dm_vu_prop_final_desk
                WHERE
                    TRIM(empno1) IS NOT NULL
            )
        WHERE
            rn = 1
    ) daa
WHERE
        a.empno = e.empno
    AND e.status = 1
    AND a.empno = daa.empno1 (+)
    AND attend_plan.get_next_working_day BETWEEN a.wk_start_date AND a.wk_end_date
    AND attend_plan.get_last_planned_date(a.empno) > 6
;
