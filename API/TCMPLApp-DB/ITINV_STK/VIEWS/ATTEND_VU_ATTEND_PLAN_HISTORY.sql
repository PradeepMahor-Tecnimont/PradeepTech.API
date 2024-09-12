--------------------------------------------------------
--  DDL for View ATTEND_VU_ATTEND_PLAN_HISTORY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."ATTEND_VU_ATTEND_PLAN_HISTORY" ("WEEK_START_DATE", "WEEK_END_DATE", "KEYID", "EMPNO", "NAME", "PARENT", "ASSIGN", "GRADE", "DESKID", "DEVICE", "OFFICE", "FLOOR", "WING", "MON", "MON_IS_ABSENT", "TUE", "TUE_IS_ABSENT", "WED", "WED_IS_ABSENT", "THU", "THU_IS_ABSENT", "FRI", "FRI_IS_ABSENT", "SAT", "SAT_IS_ABSENT") AS 
  SELECT
    a.wk_start_date                                               week_start_date,
    a.wk_end_date                                                 week_end_date,
    a.keyid                                                                       keyid,
    a.empno                                                                       empno,
    e.name,
    e.parent,
    e.assign,
    e.grade,
    CASE TRIM(nvl(daa.office, 'NA'))
        WHEN 'Home'  THEN
            NULL
        WHEN 'NA'    THEN
            NULL
        ELSE
            daa.deskid
    END deskid,
    attend_plan.get_device(a.empno)                                               device,
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
    mon,
    attend_plan.isabsent(a.wk_start_date, a.empno, 0)             mon_is_absent,
    tue,
    attend_plan.isabsent(a.wk_start_date, a.empno, 1)             tue_is_absent,
    wed,
    attend_plan.isabsent(a.wk_start_date, a.empno, 2)             wed_is_absent,
    thu,
    attend_plan.isabsent(a.wk_start_date, a.empno, 3)             thu_is_absent,
    fri,
    attend_plan.isabsent(a.wk_start_date, a.empno, 4)             fri_is_absent,
    sat,
    attend_plan.isabsent(a.wk_start_date, a.empno, 5)             sat_is_absent
FROM
    vu_emplmast     e,
    attend_plan_wk  a,
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
        e.status = 1
    AND a.empno = daa.empno1 (+)
    AND a.empno = e.empno
    AND a.wk_start_date < attend_plan.get_week_start_date
;
