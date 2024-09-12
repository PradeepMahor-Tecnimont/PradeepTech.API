--------------------------------------------------------
--  DDL for Procedure UPDATEEMPMAST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "LOGBOOK1"."UPDATEEMPMAST" IS
BEGIN
	update hrempmast a
		set (parent,desg,qual,name,dob,doj,yog,payroll,stat,office)
		= (select parent,desg,qual,name,dob,doj,yog,payroll,stat,office from paysname b
		where ltrim(rtrim(a.empno)) = ltrim(rtrim(b.empno))) where a.empno in
		(select empno
		from(select empno,parent,desg,qual,name,dob,doj,yog,payroll,stat,office from paysname minus
		select empno,parent,desg,qual,name,dob,doj,yog,payroll,stat,office from hrempmast));
		Commit;
END;

/
