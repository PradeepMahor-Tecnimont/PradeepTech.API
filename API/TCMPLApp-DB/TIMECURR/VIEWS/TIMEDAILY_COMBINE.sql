--------------------------------------------------------
--  DDL for View TIMEDAILY_COMBINE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TIMEDAILY_COMBINE" () AS 
  (SELECT yymm,
    empno,
    costcode,
    projno,
    wpcode,
    activity,
    grp,
    hours,
    othours
  FROM time_daily
  WHERE yymm >= '201904'
  )
  UNION
    (SELECT yymm,
    empno,
    costcode,
    projno,
    wpcode,
    activity,
    grp,
    hours,
    othours
  FROM time_2018.time_daily
  WHERE yymm >= '201804'
  AND yymm   <= '201903'
  )
  UNION
   (SELECT yymm,
    empno,
    costcode,
    projno,
    wpcode,
    activity,
    grp,
    hours,
    othours
  FROM time_2017.time_daily
  WHERE yymm >= '201704'
  AND yymm   <= '201803'
  )
   UNION
  (SELECT yymm,
    empno,
    costcode,
    projno,
    wpcode,
    activity,
    grp,
    hours,
    othours
  FROM time_2016.time_daily
  WHERE yymm >= '201604'
  AND yymm   <= '201703'
  )
   UNION
  (SELECT yymm,
    empno,
    costcode,
    projno,
    wpcode,
    activity,
    grp,
    hours,
    othours
  FROM time2015.time_daily
  WHERE yymm >= '201504'
  AND yymm   <= '201603'
  )
   UNION
  (SELECT yymm,
    empno,
    costcode,
    projno,
    wpcode,
    activity,
    grp,
    hours,
    othours
  FROM time2014.time_daily
  WHERE yymm >= '201404'
  AND yymm   <= '201503'
  )
  UNION
  (SELECT yymm,
    empno,
    costcode,
    projno,
    wpcode,
    activity,
    grp,
    hours,
    othours
  FROM time2013.time_daily
  WHERE yymm >= '201304'
  AND yymm   <= '201403'
  )
UNION
  (SELECT yymm,
    empno,
    costcode,
    projno,
    wpcode,
    activity,
    grp,
    hours,
    othours
  FROM time2012.time_daily
  WHERE yymm >= '201204'
  AND yymm   <= '201303'
  )
UNION
  (SELECT yymm,
    empno,
    costcode,
    projno,
    wpcode,
    activity,
    grp,
    hours,
    othours
  FROM time2011.time_daily
  WHERE yymm >= '201104'
  AND yymm   <= '201203'
  )
;
