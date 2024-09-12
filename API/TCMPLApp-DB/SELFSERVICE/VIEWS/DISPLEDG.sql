--------------------------------------------------------
--  DDL for View DISPLEDG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DISPLEDG" ("APP_NO", "APP_DATE", "LEAVETYPE", "DESCRIPTION", "EMPNO", "LEAVEPERIOD", "DB_CR", "DISPBDATE", "DISPEDATE", "DBDAY", "CRDAY", "ADJ_TYPE") AS 
  SELECT SS_LEAVELEDG.APP_NO, SS_LEAVELEDG.APP_DATE, SS_LEAVELEDG.LEAVETYPE, 
SS_LEAVELEDG.DESCRIPTION, SS_LEAVELEDG.EMPNO, 
SS_LEAVELEDG.LEAVEPERIOD, SS_LEAVELEDG.DB_CR, 
SS_Leaveledg.BDate DispBDate, 
SS_Leaveledg.EDate DispEDate, 
DECODE(SS_LEAVELEDG.DB_CR, 
'D', SS_LEAVELEDG.LEAVEPERIOD*-1, NULL) DbDay, 
DECODE(SS_LEAVELEDG.DB_CR, 
'C', SS_LEAVELEDG.LEAVEPERIOD, NULL) CrDay,
SS_LEAVE_ADJ.ADJ_TYPE
FROM SS_LEAVE_ADJ, 
SS_LEAVEAPP, SS_LEAVELEDG
WHERE 
 (SS_LEAVELEDG.APP_NO=SS_LEAVE_ADJ.ADJ_NO(+))
 AND (SS_LEAVELEDG.APP_NO=SS_LEAVEAPP.APP_NO(+))
 AND (SS_LEAVELEDG.EMPNO=SS_LEAVE_ADJ.EMPNO(+))
 AND (SS_LEAVELEDG.EMPNO=SS_LEAVEAPP.EMPNO(+))
;
