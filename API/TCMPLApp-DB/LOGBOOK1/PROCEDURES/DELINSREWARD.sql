--------------------------------------------------------
--  DDL for Procedure DELINSREWARD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "LOGBOOK1"."DELINSREWARD" IS
BEGIN
	Delete from HrReward;
	Insert Into HrReward value (select A.EmpNo, B.Parent, A.Reward, A.RewardDt from HrTempReward A, HrEmpMast B where A.EmpNo = B.EmpNo);
	Commit;  
END;

/
