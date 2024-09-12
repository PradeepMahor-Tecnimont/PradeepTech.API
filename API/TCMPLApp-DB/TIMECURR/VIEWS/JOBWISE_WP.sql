create or replace force view "TIMECURR"."JOBWISE_WP" (
   "YYMM",
   "ASSIGN",
   "PROJNO",
   "EMPNO",
   "ACTIVITY",
   "WPCODE",
   "NHRS",
   "OHRS"
) as
   select yymm, assign, projno, empno, activity, WPCODE, sum(total) as nhrs, 000.00 as ohrs
     from time_daily
    group by yymm, assign, projno, empno, activity, WPCODE union all
   select yymm, assign, projno, empno, activity, WPCODE, 000.00 as nhrs, sum(total) as ohrs
     from time_ot
    group by yymm, assign, projno, empno, activity, WPCODE;