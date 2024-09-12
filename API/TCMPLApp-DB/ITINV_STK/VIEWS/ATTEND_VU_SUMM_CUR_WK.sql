--------------------------------------------------------
--  DDL for View ATTEND_VU_SUMM_CUR_WK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."ATTEND_VU_SUMM_CUR_WK" ("OFFICE", "TOTAL_SEATS_CAPACITY", "TOTAL_SEATS_AVAILABLE", "ALLOCATED_OCCUPANY", "MON", "TUE", "WED", "THU", "FRI", "SAT") AS 
  SELECT
    office,
    attend_plan.get_tot_seat_cap(office, attend_plan.get_week_start_date)           total_seats_capacity,
    attend_plan.get_tot_seat_avl(office, attend_plan.get_week_start_date)           total_seats_available,
    attend_plan.get_allt_ocu(office, attend_plan.get_week_start_date)               allocated_occupany,
    SUM(mon)                                                                       mon,
    SUM(tue)                                                                       tue,
    SUM(wed)                                                                       wed,
    SUM(thu)                                                                       thu,
    SUM(fri)                                                                       fri,
    SUM(sat)                                                                       sat
FROM
    (
        SELECT
            nvl(daa.office, 'NA') office,
            CASE attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 0)
                WHEN - 1 THEN
                    a.mon
                ELSE
                    attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 0)
            END mon,
            CASE attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 1)
                WHEN - 1 THEN
                    a.tue
                ELSE
                    attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 1)
            END tue,
            CASE attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 2)
                WHEN - 1 THEN
                    a.wed
                ELSE
                    attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 2)
            END wed,
            CASE attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 3)
                WHEN - 1 THEN
                    a.thu
                ELSE
                    attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 3)
            END thu,
            CASE attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 4)
                WHEN - 1 THEN
                    a.fri
                ELSE
                    attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 4)
            END fri,
            CASE attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 5)
                WHEN - 1 THEN
                    a.sat
                ELSE
                    attend_plan.is_present(attend_plan.get_week_start_date, a.empno, 5)
            END sat
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
