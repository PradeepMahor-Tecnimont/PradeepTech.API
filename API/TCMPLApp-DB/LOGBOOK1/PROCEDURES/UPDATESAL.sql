--------------------------------------------------------
--  DDL for Procedure UPDATESAL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "LOGBOOK1"."UPDATESAL" IS
BEGIN
	update hrsal a
		set (parent,sal)
		= (select parent,sal from ntrlfile b
		where ltrim(rtrim(a.empno)) = ltrim(rtrim(b.empno))) where a.empno in
		(select empno
		from(select empno,parent,sal from ntrlfile minus
		select empno,parent,sal from hrsal));
	Commit;
END;

/
