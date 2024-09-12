--------------------------------------------------------
--  DDL for View SAP_TCM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."SAP_TCM" ("RECORDTYPE", "WORKINGDEPT", "PERIOD", "EMPNO", "DEPTOFEMPLOYEE", "COMPANYCODE", "PROJECT", "GT", "PT", "DT", "ACTIVITY", "ORDERNUMBER", "HOURS", "SITEACTIVITY", "ORDERLINE", "QTY", "ITEMSERVICENO", "NAME", "PENALTY", "FORCINGCODE", "YYMM", "EMPTYPE", "GRP") AS 
  (
select decode(a.wpcode,4,2,1) RecordType ,GET_SAP_CC(a.costcode) WorkingDept ,  decode(a.wpcode,4,to_char(to_date('01'||A.YYMM,'ddyyyyMM')-1,'MMYYYY'), substr(yymm,5,2)||substr(yymm,1,4) ) Period , a.empno Empno,  
GET_SAP_CC(a.parent) DeptOfEmployee ,'3002EP' CompanyCode,  
substr(a.projno,2,6) Project, a.wpcode GT,' ' PT, a.ACTIVITY DT, ' ' Activity ,' ' OrderNumber, nvl(a.hours,0)+nvl(a.othours,0) Hours,  
' ' SiteActivity ,' ' OrderLine , 0.00 Qty, ' ' ItemServiceNo ,  
substr(c.name,1,20) Name ,' ' Penalty , ' ' ForcingCode   , a.yymm , C.EMPTYPE,A.GRP
from timetran a , costmast b , emplmast c  
where   
a.costcode = b.costcode and a.empno = c.empno    
)
;
