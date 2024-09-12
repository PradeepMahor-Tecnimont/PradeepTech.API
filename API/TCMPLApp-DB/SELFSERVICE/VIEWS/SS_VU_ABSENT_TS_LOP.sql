--------------------------------------------------------
--  DDL for View SS_VU_ABSENT_TS_LOP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_ABSENT_TS_LOP" ("EMPNO", "NAME", "PARENT", "ASSIGN", "PAYSLIP_YYYYMM", "ABSENT_YYYYMM", "LOP_DAYS_CSV", "EMP_TOT_LOP", "REVERSE_LOP_DAYS_CSV") AS 
  select
     a.empno,
     b.name,
     b.parent,
     b.assign,
     a.payslip_yyyymm,
     a.absent_yyyymm,
     a.lop_days_csv,
     a.emp_tot_lop,
     reverse_lop_days_csv
 from
     (
         select
             empno,
             payslip_yyyymm,
             absent_yyyymm,
             listagg(lop_days,', ') within group(
                 order by
                     lop_4_date
             ) lop_days_csv,
             sum(half_full) emp_tot_lop,
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
                     end lop_days,
                     aa.half_full,
                     case nvl(bb.half_full,-1)
                         when 1    then to_char(bb.lop_4_date,'dd')
                         when.5   then '*'
                                     || to_char(bb.lop_4_date,'dd')
                         else null
                     end reverse_lop_days
                 from
                     ss_absent_ts_lop aa,
                     ss_absent_ts_lop_reverse bb
                 where
                     aa.empno = bb.empno (+)
                     and aa.lop_4_date = bb.lop_4_date (+)
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
