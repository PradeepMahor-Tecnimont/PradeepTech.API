--------------------------------------------------------
--  DDL for Procedure INSNEWINSAL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "LOGBOOK1"."INSNEWINSAL" IS
BEGIN
	insert into hrsal value
		(select * from ntrlfile b where
		b.empno in (select empno from ntrlfile minus select empno from hrsal));
		Commit;
END;

/
