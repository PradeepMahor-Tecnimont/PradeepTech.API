--------------------------------------------------------
--  DDL for Procedure DELINSPERKS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "LOGBOOK1"."DELINSPERKS" IS
BEGIN
	Delete from HrPerks;
	Insert Into HrPerks value (select A.EmpNo, B.Parent, A.Perk, A.Remark, A.Amt from HrTempPerks A, HrEmpMast B where A.EmpNo = B.EmpNo);
	Commit;  
END;  

/
