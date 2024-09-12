--------------------------------------------------------
--  DDL for Procedure INSNEWINEMPMAST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "LOGBOOK1"."INSNEWINEMPMAST" as
Begin
	insert into hrempmast value
		(select Empno, Parent, Desg, Qual, Name, Dob, Doj, Yog, Payroll, Stat,
		Office from paysname b where
		b.empno in (select empno from paysname minus select empno from hrempmast));
		Commit;
End;

/
