--------------------------------------------------------
--  DDL for Procedure INSERT_PRJC_INTO_NEW_EXPTPRJC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."INSERT_PRJC_INTO_NEW_EXPTPRJC" (OLD_PROJNO in PROJMAST.PROJNO%type,NEW_PROJNO in PROJMAST.PROJNO%type) IS
V_COSTCODE CHAR(4);
V_YYMM CHAR(6);
V_HOURS NUMBER;
V_COUNT1 INTEGER;
V_COUNT INTEGER;
REC EXPTPRJC%ROWTYPE;
BEGIN
select COUNT(*) INTO V_COUNT from exptJOBS where projno = NEW_PROJNO;
IF V_COUNT > 0 THEN
	select COUNT(*) INTO V_COUNT1 from exptprjc where projno = NEW_PROJNO;
	IF V_COUNT1 = 0 THEN
     update exptprjc set projno = new_projno where projno = old_projno;
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
