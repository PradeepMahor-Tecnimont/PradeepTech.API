--------------------------------------------------------
--  DDL for View SS_INTEGRATEDPUNCH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_INTEGRATEDPUNCH" ("EMPNO", "HH", "MM", "SS", "PDATE", "DD", "MON", "YYYY", "HHSORT", "MMSORT", "FROMTAB", "TYPE", "ODTYPE", "MACH", "FALSEFLAG") AS 
  (SELECT empno,
    hh,
    mm,
    ss,
    pdate,
    dd,
    mon,
    yyyy,
    hh hhsort,
    mm mmsort,
    1 FromTab,
    'PP' AS Type,
    0    AS ODTYPE,
    Mach,
    FalseFlag
  FROM ss_punch
  )
UNION ALL
  (SELECT empno,
    hh,
    mm,
    ss,
    pdate,
    dd,
    mon,
    yyyy,
    hh hhsort,
    mm mmsort,
    2 FromTab,
    'AA'   AS Type,
    0      AS ODTYPE,
    'AUTO' AS MACH,
    FalseFlag
  FROM ss_punch_auto
  )
UNION ALL
  (SELECT empno,
    hh,
    mm,
    0 ss,
    pdate,
    dd,
    mon,
    yyyy,
    hhsort,
    mmsort,
    3 FromTab,
    Type,
    ODType,
    'ODApp' AS MACH,
    1       AS FalseFlag
  FROM ss_onduty
  WHERE type <> 'LE'
  AND type   <> 'SL'
  )
UNION ALL
  (SELECT empno,
    hh,
    mm,
    ss,
    pdate,
    dd,
    mon,
    yyyy,
    hh hhsort,
    mm mmsort,
    4 FromTab,
    'SA' Type,
    0 ODType,
    'SA00' AS MACH,
    FalseFlag
  FROM ss_punch_manual
  )
  UNION ALL
  (SELECT empno,
    hh,
    mm,
    ss,
    pdate,
    dd,
    mon,
    yyyy,
    hh hhsort,
    mm mmsort,
    4 FromTab,
    'SA' Type,
    0 ODType,
    'WFH0' AS MACH,
    FalseFlag
  FROM ss_punch_wfh
  )
;
