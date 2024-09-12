--------------------------------------------------------
--  DDL for Procedure UPDATE_COMPANY_IN_TIMEMAST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."UPDATE_COMPANY_IN_TIMEMAST" (proc_month in timetran.yymm%type)  IS
V_YY INTEGER;
V_MM INTEGER;
V_MNTH CHAR(6);
cursor c1 is select * from emplmast where trans_in is not null and status = 1;
BEGIN
	for c2 in c1 loop
		V_YY:=SUBSTR(TO_CHAR(c2.TRANS_IN,'dd-mm-YYYY'),7,4);
    v_mm := SUBSTR(TO_CHAR(c2.TRANS_IN,'dd-mm-YYYY'),4,2);
	v_mnth :=rtrim(to_char(v_yy)||lpad(to_char(v_mm),2,'0'));
	if v_mnth = proc_month then
  UPDATE TIME_MAST SET COMPANY = C2.COMPANY WHERE yymm = V_MNTH  AND EMPNO = C2.EMPNO;
  UPDATE TIME_DAILY SET COMPANY = C2.COMPANY WHERE yymm = V_MNTH AND EMPNO = C2.EMPNO;
  UPDATE TIME_OT SET COMPANY = C2.COMPANY WHERE yymm = V_MNTH  AND EMPNO = C2.EMPNO;
  UPDATE TIMEtran SET COMPANY = C2.COMPANY WHERE yymm = V_MNTH AND EMPNO = C2.EMPNO;
 end if;
  end loop;
		commit;

end;

/
