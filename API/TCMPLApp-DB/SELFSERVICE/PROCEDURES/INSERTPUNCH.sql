--------------------------------------------------------
--  DDL for Procedure INSERTPUNCH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."INSERTPUNCH" (ErrLevel OUT number) IS
BEGIN
	insert into SS_Punch value (select SS_IPFormat.*,0 from SS_IPFormat);
	commit;
	ErrLevel := 0;
exception
	when others then
		if SQLCODE = -1 then
			ErrLevel := 1;
		else
			ErrLevel := 2;
		end if;
END;


/
