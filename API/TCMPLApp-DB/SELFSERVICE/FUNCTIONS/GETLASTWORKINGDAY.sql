--------------------------------------------------------
--  DDL for Function GETLASTWORKINGDAY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETLASTWORKINGDAY" (F_DATE IN DATE,OPER IN VARCHAR2) RETURN date IS
	x number :=0;
	c_dt date := F_DATE;
	v_count number := 1;
begin	
IF oper = '-' THEN	--Previos Working Date
	while v_count <> 0 loop
		x:= x+1;
		select count(*) into v_count from ss_holidays where holiday = c_dt - x;
	end loop;
	RETURN  c_dt - x;
elsif oper = '+'	then  --Next Working Date
	while v_count <> 0 loop
		x:= x+1;
		select count(*) into v_count from ss_holidays where holiday = c_dt + x;
	end loop;
	RETURN  c_dt + x;
end if;	
END;


/
