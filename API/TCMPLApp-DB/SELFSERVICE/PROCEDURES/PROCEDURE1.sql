--------------------------------------------------------
--  DDL for Procedure PROCEDURE1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."PROCEDURE1" AS 

v_out_succ varchar2(50);
v_out_msg varchar2(1000);
cursor c1 is select distinct empno,payslip_yyyymm,to_char(lop_4_date,'YYYYMM') absent_yyyymm from ss_absent_lop;
begin
    for c2 in c1 loop
        pkg_absent.regenerate_list_4_one_emp(c2.absent_yyyymm, c2.payslip_yyyymm,c2.empno, 'ticb\deven',v_out_succ,v_out_msg);
        dbms_output.put_line(c2.empno || '- '||v_out_succ);
        v_out_succ := null;
    end loop;
end;


/
