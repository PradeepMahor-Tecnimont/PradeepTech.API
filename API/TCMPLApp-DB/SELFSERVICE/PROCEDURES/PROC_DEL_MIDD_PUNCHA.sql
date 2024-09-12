--------------------------------------------------------
--  DDL for Procedure PROC_DEL_MIDD_PUNCHA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."PROC_DEL_MIDD_PUNCHA" 
is 
cursor c1 is select empno, pdate, count(empno) from ss_punch where
pdate in ('15-Oct-2010') and 
empno In (Select EmpNo from ss_muster ss_Must where ss_must.mnth = '201010' and substr(ss_must.s_mrk, ((15 * 2) - 1), 2) = 'S2')
and mach in (Select mach_name from ss_swipe_mach_mast where valid_4_in_out = 1)
group by empno, pdate
having count(empno) > 2;

cursor cur_punch(c_empno in char, c_pdate in date) is select * from ss_punch where empno = c_empno and pdate = c_pdate
  order by hh,mm,ss;
loopCntr number;  

  hh1 number;
  hh2 number;
  mm1 number;
  mm2 number;
  ss1 number;
  ss2 number;

begin
    for c2 in c1 loop
        loopcntr := 1;
        for c3 in cur_punch (c2.empno, c2.pdate ) loop
           If loopcntr = 1 then
              hh1 := c3.hh;
              mm1 := c3.mm;
              ss1 := c3.ss;
           else
              hh2 := c3.hh;
              mm2 := c3.mm;
              ss2 := c3.ss;
           End If;
           loopcntr := loopcntr + 1;
        end loop;

        update ss_punch set falseflag = 0 where
        empno=c2.empno and pdate=c2.pdate and hh*60+mm <> hh1*60+mm1 and hh*60+mm <> hh2*60+mm2;

        DELETE FROM ss_punch_auto WHERE empno=c2.empno AND pdate=c2.pdate;
        COMMIT;

    commit;
    end loop;
end;


/
