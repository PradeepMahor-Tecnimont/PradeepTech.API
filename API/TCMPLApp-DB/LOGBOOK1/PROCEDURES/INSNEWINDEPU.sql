--------------------------------------------------------
--  DDL for Procedure INSNEWINDEPU
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "LOGBOOK1"."INSNEWINDEPU" IS
BEGIN
	Delete from HrDepu;
	Insert Into HrDepu value (select A.Empno, DepBDate, DepEDate, Place, B.Parent from HrTempDepu A, HrEmpMast B where A.EmpNo = B.EmpNo);
	Insert Into HrDepu value (Select * from HrDepuBackUp);
	Commit;  
END;

/
