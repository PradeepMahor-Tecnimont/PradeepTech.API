--------------------------------------------------------
--  DDL for Procedure UPDATE_TMRAPPER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."UPDATE_TMRAPPER" (proc_month in timetran.yymm%type) IS

BEGIN
 delete from tm_rapper where yymm = proc_month;
 insert into tm_rapper (select ltrim(tcm_costcode),yymm,empno,'        '||substr(projno,2,6),'3' as t,tlpcode,
' ' as dl,wpcode,' ' as ordercode,' ' as tp,'OF' as co,' ' as item,'40' as recstat,'S' as mhflag,'ICB' as comp1,
' ' as comp2,'O' as ht,'N' as umflag,TO_CHAR(SYSDATE,'DD/MM/YYYY') as  vdate,
LPAD(ltrim(to_char(manhours,'099999.99')),11,'+0'),
LPAD(ltrim(to_char(manhours,'0999.99')),8,'0'),'0','0',TO_CHAR(SYSDATE,'DD/MM/YYYY'),'0','0' From TM_RAPPER_timetran
 where yymm = proc_month);
 --insert into tm_rapper (select ltrim(tcm_costcode),yymm,empno,'        '||substr(projno,2,6),'3' as t,tlpcode,' ' as dl,wpcode,' ' as ordercode,' ' as tp,'OF' as co,' ' as item,'40' as recstat,'S' as mhflag,'ICB' as comp1,' ' as comp2,'O' as ht,'N' as umflag,
 --'06/30/2005' as  vdate,'+0'||ltrim(to_char(manhours,'099999.99')),'0'||ltrim(to_char(manhours,'0999.99')) From TM_RAPPER_timetran
 --where yymm = proc_month);
   commit;
   EXCEPTION
   	 when others then
        dbms_output.put_line('ERROR : '||SQLERRM);
        rollback;            
        raise;    
END;

/
