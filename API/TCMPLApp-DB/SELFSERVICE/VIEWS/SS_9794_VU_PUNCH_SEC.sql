--------------------------------------------------------
--  DDL for View SS_9794_VU_PUNCH_SEC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_9794_VU_PUNCH_SEC" ("EMPNO", "YYYY", "MON", "DD", "P_DATE", "FIRST_PUNCH", "LAST_PUNCH", "FIRST_PUNCH_C", "LAST_PUNCH_C") AS 
  select empno,yyyy,mon,dd,to_date(YYYY||MON||DD,'YYYYMMDD') p_date,
pkg_09794.get_access_control_punch_sec(empno,to_date(YYYY||MON||DD,'YYYYMMDD'),'OK') first_punch ,
pkg_09794.get_access_control_punch_sec(empno,to_date(YYYY||MON||DD,'YYYYMMDD'),'KO') last_punch ,
pkg_09794.get_access_control_punch(empno,to_date(YYYY||MON||DD,'YYYYMMDD'),'OK') first_punch_c,
pkg_09794.get_access_control_punch(empno,to_date(YYYY||MON||DD,'YYYYMMDD'),'KO') last_punch_c
from(
select empno, yyyy,mon,dd from ss_9794_punch group by empno,yyyy,mon,dd)
;
