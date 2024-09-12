--------------------------------------------------------
--  DDL for Procedure REMOVE_FROM_EXPT_INSERT_INTO_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."REMOVE_FROM_EXPT_INSERT_INTO_P" (OLD_PROJNO in PROJMAST.PROJNO%type,NEW_PROJNO in PROJMAST.PROJNO%type) IS
CURSOR C1 IS SELECT * FROM EXPTPRJC WHERE PROJNO = OLD_PROJNO;
V_COSTCODE CHAR(4);
V_YYMM CHAR(6);
V_HOURS NUMBER;
V_COUNT1 INTEGER;
V_COUNT INTEGER;
REC EXPTPRJC%ROWTYPE;
BEGIN
		open c1;
select COUNT(*) INTO V_COUNT from projmast where projno = NEW_PROJNO;
IF V_COUNT > 0 THEN
	select COUNT(*) INTO V_COUNT1 from prjcmast where projno = NEW_PROJNO;
	IF V_COUNT1 = 0 THEN
   Loop
      fetch c1 into rec;
	      exit when c1%NOTFOUND;
					V_COSTCODE := rec.costcode;
					v_yymm := rec.yymm;
					v_hours := rec.hours;
					INSERT INTO prjcMAST VALUES (v_COSTCODE,NEW_PROJNO,v_YYMM,v_HOURS);
   end loop;
   close c1;
	end if;

end if;  
commit;
 EXCEPTION
 when others then
        dbms_output.put_line('ERROR : '||SQLERRM);
        rollback;            
        raise;    
END;

/
