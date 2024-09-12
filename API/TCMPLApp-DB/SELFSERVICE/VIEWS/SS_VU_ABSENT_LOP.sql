--------------------------------------------------------
--  DDL for View SS_VU_ABSENT_LOP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_ABSENT_LOP" ("EMPNO", "NAME", "PARENT", "ASSIGN", "LOP_DATE", "PAYSLIP_YYYYMM", "HALF_FULL") AS 
  select
    a.empno,
    b.name,
    b.parent,
    b.assign,
    to_char(a.lop_4_date,'dd-Mon-yyyy') lop_date,
    a.payslip_yyyymm,
    a.half_full
from
    ss_absent_lop a,
    ss_emplmast b
where
    a.empno = b.empno
;
