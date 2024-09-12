--------------------------------------------------------
--  DDL for Type TYP_ROW_PUNCH_DATA
--------------------------------------------------------

  CREATE OR REPLACE TYPE "SELFSERVICE"."TYP_ROW_PUNCH_DATA" As Object(
    empno                    Char(5),
    dd                       Varchar2(2),
    ddd                      Varchar2(3),
    punch_date               Date,
    shift_code               Varchar2(2),
    wk_of_year               Varchar2(2),
    first_punch              Varchar2(10),
    last_punch               Varchar2(10),
    penalty_hrs              Number,
    is_odd_punch             Number,
    is_ldt                   Number,
    is_sunday                Number,
    is_lwd                   Number,
    is_lc_app                Number,
    is_sleave_app            Number,
    is_absent                Number,
    sl_app_cntr              Number,
    ego                      Number,
    wrk_hrs                  Number,
    delta_hrs                Number,
    extra_hrs                Number,
    comp_off_hrs             Number,
    last_day_cfwd_dhrs       Number,
    wk_sum_work_hrs          Number,
    wk_sum_delta_hrs         Number,
    wk_sum_extra_hrs         Number,
    wk_sum_comp_off_hrs      Number,
    wk_sum_weekday_extra_hrs Number,
    wk_sum_holiday_extra_hrs Number,
    wk_bfwd_delta_hrs        Number,
    wk_cfwd_delta_hrs        Number,
    wk_penalty_leave_hrs     Number,
    day_punch_count          Number,
    remarks                  Varchar2(100)
    --,
--str_wrk_hrs              Varchar2(6),
--str_delta_hrs            Varchar2(6),
--str_extra_hrs            Varchar2(6),
--str_ts_work_hrs          Varchar2(6),
--str_ts_extra_hrs         Varchar2(6),
--str_wk_sum_work_hrs      Varchar2(6),
--str_wk_sum_delta_hrs     Varchar2(6),
--str_wk_bfwd_delta_hrs    Varchar2(6),
--str_wk_cfwd_delta_hrs    Varchar2(6),
--str_wk_penalty_leave_hrs Varchar2(6)
);

/
