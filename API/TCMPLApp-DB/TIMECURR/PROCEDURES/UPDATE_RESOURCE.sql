--------------------------------------------------------
--  DDL for Procedure UPDATE_RESOURCE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."UPDATE_RESOURCE" (proc_month in timetran.yymm%type)  IS
stryymm char(6);
v_yy integer;
v_mm integer;
v_nextmnth char(6);
v_count integer;
v_empno char(5);
v_costcode char(4);
  cursor c1 is select * from res_plan where yymm = proc_month;
BEGIN
  stryymm := proc_month;
if ltrim(rtrim(stryymm)) <> ' ' then
	v_yy := to_number(substr(Stryymm,1,4));
  v_mm := to_number(substr(Stryymm,5,2));
	v_mm := v_mm +1;
	if v_mm > 12 then
		v_mm := 1;
		v_yy := v_yy + 1;
	end if;
	v_nextmnth :=rtrim(to_char(v_yy)||lpad(to_char(v_mm),2,'0'));
	select count(*) into v_count from res_plan where yymm = v_nextmnth;
	if v_count > 0 then
		delete from res_plan where yymm = v_nextmnth;
		for c2 in c1 loop
			v_empno := ltrim(rtrim(C2.EMPNO));
			v_costcode := ltrim(rtrim(c2.costcode));
	 -- v_assign :=nvl(c2.assignment,'');
	    insert into res_plan (yymm,empno,costcode,projno,mnth1,mnth2,mnth3,mnth4,mnth5,mnth6,mnth7,mnth8,mnth9,mnth10,mnth11,mnth12,ASSIGNMENT)
	    values(v_nextmnth,v_Empno,v_costcode,c2.projno,c2.mnth2,c2.mnth3,c2.mnth4,c2.mnth5,c2.mnth6,c2.mnth7,c2.mnth8,c2.mnth9,c2.mnth10,c2.mnth11,c2.mnth12,0,c2.ASSIGNMENT);
		end loop;
		commit;
 else
		for c2 in c1 loop
			v_empno := ltrim(rtrim(C2.EMPNO));
			v_costcode := ltrim(rtrim(c2.costcode));
--			v_assign :=nvl(c2.assignment,'');
	    insert into res_plan (yymm,empno,costcode,projno,mnth1,mnth2,mnth3,mnth4,mnth5,mnth6,mnth7,mnth8,mnth9,mnth10,mnth11,mnth12,assignment)
	    values(v_nextmnth,v_Empno,v_costcode,c2.projno,c2.mnth2,c2.mnth3,c2.mnth4,c2.mnth5,c2.mnth6,c2.mnth7,c2.mnth8,c2.mnth9,c2.mnth10,c2.mnth11,c2.mnth12,0,c2.assignment);
		end loop;
		commit;
end if;
end if;
END;

/
