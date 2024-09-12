--------------------------------------------------------
--  DDL for View INV_WORKFILE2_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INV_WORKFILE2_VIEW" ("COSTCODE", "YYMM", "EMPLOYEE_CODE", "MISS1", "TCMNO", "TLGCODE", "TLPCODE", "DLCD", "ACTIVITY", "ORDER_CODE", "TPC", "C_TYPE", "WORKING_PERC", "JOB_TITLE", "RECORD_STATUS", "MANOUR_HR_FLAG", "COMPANY", "HOUR_FLAG", "VALIDATION_DATE", "TOTAL_HOURS") AS 
  select a.costcode,a.yymm,a.employee_code,
'      ' as miss1,a.tcmno,a.tlgcode,a.tlpcode,
' '||a.dlcode as dlcd,a.activity,
substr(a.suborder_no,1,15) as order_code,
' ' as tpc,c_type,
'000' as working_perc,
substr(b.name,1,31) as job_title,
'40' as record_status,
'S' as manour_hr_flag,
a.company,
'O' as hour_flag,
substr(a.yymm,5,2)||'/28/'||substr(a.yymm,1,4) as validation_date,
nvl(a.ticb_hrs,0)+nvl(a.subc_hrs,0) as total_hours
from inv_workfile2 a, projmast b where a.tcmno = b.tcmno

;
