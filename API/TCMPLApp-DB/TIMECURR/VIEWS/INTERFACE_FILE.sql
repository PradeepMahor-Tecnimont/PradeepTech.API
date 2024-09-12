--------------------------------------------------------
--  DDL for View INTERFACE_FILE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INTERFACE_FILE" ("COSTCODE", "YYMM", "EMPLOYEE_CODE", "MISSING1", "TCMNO", "TLGCODE", "TLPCODE", "DLCODE2", "ACTIVITY", "ORDER_CODE", "TPC", "C_TYPE", "WORKING_PERC", "JOB_TITLE", "RECORD_STATUS", "MANUAL_FLAG", "COMPANY", "HOUR_FLAG", "VALID_DATE", "HOURS") AS 
  select costcode,yymm,employee_code,'        ' as missing1,tcmno,tlgcode,tlpcode,
dlcode||' ' as dlcode2,activity,
substr(suborder_no,1,15) as order_code,
' ' as tpc,c_type,'000' as working_perc,
short_code||'                 ' as job_title,
'40' as record_status,'S' as manual_flag,company,'O ' as hour_flag,
to_char(sysdate,'DD/MM/YYYY') as valid_date,
to_char(round(nvl(ticb_hrs,0)+nvl(subc_hrs,0),0),'9999999.99') as hours from inv_workfile2

;
