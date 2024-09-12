--------------------------------------------------------
--  DDL for View SS_IPFORMAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_IPFORMAT" ("EMPNO", "HH", "MM", "SS", "PDATE", "DD", "MON", "YYYY", "MACH") AS 
  (SELECT empno,
    to_number(hh) hh,
    to_number(mm) mm,
    to_number(ss) ss,
    to_date(dd
    ||'-'
    ||mon
    ||'-'
    ||yyyy,'dd-mm-yyyy') PDate,
    dd,
    mon,
    yyyy,
    mach
  FROM ss_importpunch
  )
;
