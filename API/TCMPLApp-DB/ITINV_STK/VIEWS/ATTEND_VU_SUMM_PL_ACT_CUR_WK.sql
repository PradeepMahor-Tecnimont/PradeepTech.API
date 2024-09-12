--------------------------------------------------------
--  DDL for View ATTEND_VU_SUMM_PL_ACT_CUR_WK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."ATTEND_VU_SUMM_PL_ACT_CUR_WK" ("OFFICE", "TOTAL_SEATS_CAPACITY", "TOTAL_SEATS_AVAILABLE", "ALLOCATED_OCCUPANY", "MON_PLANNED", "MON_ACTUAL", "TUE_PLANNED", "TUE_ACTUAL", "WED_PLANNED", "WED_ACTUAL", "THU_PLANNED", "THU_ACTUAL", "FRI_PLANNED", "FRI_ACTUAL", "SAT_PLANNED", "SAT_ACTUAL") AS 
  SELECT
    office,
    attend_plan.get_tot_seat_cap(office, attend_plan.get_week_start_date)           total_seats_capacity,
    attend_plan.get_tot_seat_avl(office, attend_plan.get_week_start_date)           total_seats_available,
    attend_plan.get_allt_ocu(office, attend_plan.get_week_start_date)               allocated_occupany,
    SUM(mon_planned)                                                               mon_planned,
    SUM(mon_actual)                                                                mon_actual,
    SUM(tue_planned)                                                               tue_planned,
    SUM(tue_actual)                                                                tue_actual,
    SUM(wed_planned)                                                               wed_planned,
    SUM(wed_actual)                                                                wed_actual,
    SUM(thu_planned)                                                               thu_planned,
    SUM(thu_actual)                                                                thu_actual,
    SUM(fri_planned)                                                               fri_planned,
    SUM(fri_actual)                                                                fri_actual,
    SUM(sat_planned)                                                               sat_planned,
    SUM(sat_actual)                                                                sat_actual
FROM
    (
        SELECT
            nvl(daa.office, 'NA')        office,
            a.mon                        mon_planned,
            CASE attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 0)
                WHEN - 1 THEN
                    0
                ELSE
                    attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 0)
            END mon_actual,
            a.tue                        tue_planned,
            CASE attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 1)
                WHEN - 1 THEN
                    0
                ELSE
                    attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 1)
            END tue_actual,
            a.wed                        wed_planned,
            CASE attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 2)
                WHEN - 1 THEN
                    0
                ELSE
                    attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 2)
            END wed_actual,
            a.thu                        thu_planned,
            CASE attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 3)
                WHEN - 1 THEN
                    0
                ELSE
                    attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 3)
            END thu_actual,
            a.fri                        fri_planned,
            CASE attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 4)
                WHEN - 1 THEN
                    0
                ELSE
                    attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 4)
            END fri_actual,
            a.sat                        sat_planned,
            CASE attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 5)
                WHEN - 1 THEN
                    0
                ELSE
                    attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 5)
            END sat_actual
        FROM
            attend_plan_wk a,
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
                a.empno = daa.empno1 (+)
            AND a.wk_start_date = attend_plan.get_week_start_date
            AND a.wk_end_date = attend_plan.get_week_end_date
    )
GROUP BY
    office
;
