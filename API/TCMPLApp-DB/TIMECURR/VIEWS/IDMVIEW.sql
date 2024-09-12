--------------------------------------------------------
--  DDL for View IDMVIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."IDMVIEW" ("RESOURCEID", "COMPANY_ID", "EMPLOYEE_ID", "LASTNAME", "NAME", "GENDER", "BIRTH_DATE", "FISCAL_CODE", "JOBTITLE_CODE", "JOB_TITLE_DESCRIPTION", "DEPARTMENT_CODE", "DEPARTMENT_DESCRIPTION", "JOBGROUP", "JOBGROUPDESC", "JOBDISCIPLINE", "JOBDISCIPLINEDESC", "JOBSUBDISCIPLINE", "JOBSUBDISCIPLINEDESC", "JOBCATEGORY", "JOBCATEGOORYDESC", "JOBSUBCATEGORY", "JOBSUBCATEGORYDESC", "FUNCTION_CODE", "FUNCTION_DESCRIPTION", "UNIT_CODE", "UNIT_DESCRIPTION", "STATUS_CODE", "STATUS_DESCRIPTION", "CONTRACT_TYPE_CODE", "CONTRACT_TYPE_DESCRIPTION", "RESOURCE_TYPE", "RESOURCE_TYPE_DESCRIPTION", "HIRING_DATE", "LEAVE_DATE", "LEAVE_TYPE_CODE", "LEAVE_TYPE_DESCRIPTION", "SHORT_TERM_CONTRACT_END_DATE", "BUILDING_CODE", "BUILDING_DESCRIPTION", "SITE_CODE", "SITE_DESCRIPTION", "COST_CENTRE_CODE", "COST_CENTER_DESCRIPTION", "DESK", "EMPLOYEE_CATEGORY_CODE", "EMPLOYEE_CATEGORY_DESCRIPTION", "LOCATION_ADDRESS", "LOCATION_POSTAL_CODE", "LOCATION_COUNTRY", "LOCATION_CITY") AS 
  select '' as resourceid,
'3002' as company_id,
'00000000000'||a.empno as employee_id,
lastname ,firstname || ' ' || middlename as name,
sex as gender, dob as birth_date, itno as fiscal_code,
'NA' as jobtitle_code,jobtitle as job_title_description,
'NA' as department_code ,'NA' as Department_description,
jobGroup,JobGroupDesc ,
JOBDISCIPLINE          ,JOBDISCIPLINEDESC      ,
JOBSUBDISCIPLINE,  JOBSUBDISCIPLINEDESC ,
JOBCATEGORY ,       JOBCATEGOORYDESC  ,
JOBSUBCATEGORY, JOBSUBCATEGORYDESC  ,
'NA' as Function_Code,'NA' as Function_Description,'NA' as Unit_Code,'NA' as Unit_Description,
'NA' as Status_Code,'NA' as Status_Description,
0 as contract_type_code, 'Long Term ' as Contract_type_Description,
'00' as Resource_Type ,'DIPEND' as Resource_Type_Description  ,
doj as hiring_date,dol as Leave_Date,
'NA' as Leave_Type_Code,
'NA' as Leave_Type_Description,
contract_end_date  as Short_term_Contract_End_Date,d.office as Building_Code,
decode(trim(d.office),'MOC1','Tecnimont ICB House' ,
 'MOC2' , 'Interface - Seventh floor','MOC3','Interface - First Floor','')
 as Building_Description,
'NA' as Site_Code,
'NA' as Site_Description ,
parent as Cost_Centre_Code,
c.name as Cost_Center_Description,
b.deskid as Desk,category as Employee_Category_Code,
decode(category,'1','Senior Manager','2', 'Mid Manager','3','Employee','')
 as Employee_Category_Description,
decode(trim(d.office),'MOC1','504 Link Rd - Tecnimont ICB House - Chincholi Bunder' ,
 'MOC2' , '702 Interface 11 Link Road ','MOC3','101 Interface 11 Link Road ','') as location_address,
decode(trim(d.office),'MOC1','400064','MOC2','400064','MOC3','400064',''  ) as location_postal_code,
decode(trim(d.office),'MOC1','India ','MOC2','India','MOC3','India',''  ) as location_country,
decode(trim(d.office),'MOC1','Mumbai ','MOC2','Mumbai','MOC3','Mumbai',''  ) as location_city
 from emplmast a , selfservice.dm_usermaster b , costmast c ,selfservice.dm_deskmaster d
 where
a.empno = b.empno(+)
and b.deskid = d.deskid(+)
and a.parent = c.costcode
and a.status = 1 and a.emptype = 'R'

;
