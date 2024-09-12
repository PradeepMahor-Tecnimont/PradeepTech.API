--------------------------------------------------------
--  DDL for Procedure REMOV_FRM_EXPT_INS_INTO_P_COST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."REMOV_FRM_EXPT_INS_INTO_P_COST" (OLD_PROJNO in PROJMAST.PROJNO%type,NEW_PROJNO in PROJMAST.PROJNO%type,FOR_COSTCODE IN COSTMAST.COSTCODE%TYPE) IS
CURSOR C1 IS SELECT * FROM EXPTPRJC WHERE PROJNO = OLD_PROJNO AND COSTCODE = FOR_COSTCODE;
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
	select COUNT(*) INTO V_COUNT1 from prjcmast where projno = NEW_PROJNO AND COSTCODE = FOR_COSTCODE;
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
   DELETE FROM EXPTPRJC WHERE PROJNO = OLD_PROJNO AND COSTCODE = FOR_COSTCODE;
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
