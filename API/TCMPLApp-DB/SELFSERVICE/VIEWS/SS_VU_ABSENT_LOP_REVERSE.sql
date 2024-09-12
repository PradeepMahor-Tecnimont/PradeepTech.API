--------------------------------------------------------
--  DDL for View SS_VU_ABSENT_LOP_REVERSE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_ABSENT_LOP_REVERSE" ("EMPNO", "NAME", "PARENT", "ASSIGN", "PAYSLIP_YYYYMM", "ABSENT_YYYYMM", "EMP_TOT_REV_LOP", "REVERSE_LOP_DAYS_CSV") AS 
  select
     a.empno,
     b.name,
     b.parent,
     b.assign,
     a.payslip_yyyymm,
     a.absent_yyyymm,
     a.emp_tot_rev_lop,
     reverse_lop_days_csv
 from
     (
         select
             empno,
             payslip_yyyymm,
             absent_yyyymm,
             sum(half_full*-1) emp_tot_rev_lop,
             listagg(reverse_lop_days,', ') within group(
                 order by
                     lop_4_date
             ) reverse_lop_days_csv
         from
             (
                 select
                     aa.empno,
                     aa.lop_4_date,
                     aa.payslip_yyyymm,
                     to_char(aa.lop_4_date,'yyyymm') absent_yyyymm,
                     case aa.half_full
                         when 1   then to_char(aa.lop_4_date,'dd')
                         else '*'
                              || to_char(aa.lop_4_date,'dd')
                     end reverse_lop_days,
                     aa.half_full
                 from
                     ss_absent_lop_reverse aa
             )
         group by
             empno,
             payslip_yyyymm,
             absent_yyyymm
         order by
             empno,
             payslip_yyyymm
     ) a,
     ss_emplmast b
 where
     a.empno = b.empno
;
