--------------------------------------------------------
--  DDL for View HRP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."HRP" ("RESOURCEID", "FISCALID", "LASTNAME", "NAME", "SEX", "NU1", "BIRTHDATE", "HOMEOFFICE", "NU2", "NU3", "CONTRACTKI", "NU4", "NU5", "NU6", "EMPLOYEEID", "NU7", "CONTRACTTE", "HIRINGDATE", "LEAVEDATE", "CENDDATE", "NU8", "COMPANY", "COSTCENTER", "NU9", "NU10", "NU11", "NU12", "NU13", "PTFT", "PTPERCENT", "HIRINGJT", "HIRINGJTD", "PERSONALDT", "EMPLDATE1", "NU14", "NU15", "JOBTITLEDT", "SYSDATE1", "ESTARTDT", "NU16", "EMPLSTATUS", "NU17", "EXPBEGINDT", "EXPENDDT", "EXPEXTNBEG", "EXPEXTNEND", "EXPANTIEND", "EXPVALDT", "EXPCHGDT", "RESOTYPE", "RESOTYPEDT", "EMPLDATE2", "JTINITDATE", "JTCODE") AS 
  (
SELECT '3002'   ||'00'    ||a.EMPNO AS RESOURCEID ,
    a.ITNO    AS FISCALID,
a.LASTNAME ,
a.FIRSTNAME||' '||a.MIDDLENAME AS NAME,
a.SEX,
'' AS NU1,
a.DOB AS BIRTHDATE ,
'BO' AS HOMEOFFICE,
'' AS NU2,'' AS NU3,
'00' AS CONTRACTKI,
'' AS NU4,'' AS NU5,'' AS NU6,
'00'||a.EMPNO AS EMPLOYEEID,
'' AS NU7,
'0' AS CONTRACTTE,
a.DOJ AS HiringDate,
a.DOL AS LeaveDate,
'' AS cEndDate,
'' AS Nu8,
'3002' AS Company,
b.sapcc AS CostCenter,
'' AS Nu9,
'' AS Nu10,
'' AS Nu11,
'' AS Nu12,
'' AS Nu13,
'FT' AS PTFT,
'      ' AS PTPercent,
'' as HiringJT,
'' as HiringJTD,
'' as PersonalDt,
'' as EmplDate1,
'' AS Nu14,
'' AS Nu15,
'' as JobTitleDt,
'' as SysDate1,
'' as EStartDt,
'' AS Nu16,
'' as EmplStatus,
'' AS Nu17,
'' as ExpBeginDt,
'' as ExpEndDt,
'' as ExpExtnBeg,
'' as ExpExtnEnd,
'' as ExpAntiEnd,
'' as ExpValDt,
'' as ExpChgDt,
'' as ResoType,
'' as ResoTypeDt,
'' as EmplDate2,
'' as JTInitDate,
'' as JTCode
  FROM EMPLMAST a, costmast b
  WHERE
  a.assign = b.costcode and 
 a.ASSIGN IN ('0232','0238','0289')
  AND a.STATUS    = 1
  AND a.EMPTYPE   = 'R'
 )
;
