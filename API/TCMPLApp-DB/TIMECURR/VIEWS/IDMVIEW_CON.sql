--------------------------------------------------------
--  DDL for View IDMVIEW_CON
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."IDMVIEW_CON" ("COMPANY_ID", "EMPLOYEE_ID", "LASTNAME", "NAME", "GENDER", "BIRTH_DATE", "FISCAL_CODE", "JOBGROUP", "JOBGROUPDESC", "JOBDISCIPLINE", "JOBDISCIPLINEDESC", "JOBSUBDISCIPLINE", "JOBSUBDISCIPLINEDESC", "JOBCATEGORY", "JOBCATEGOORYDESC", "JOBSUBCATEGORY", "JOBSUBCATEGORYDESC", "CONTRACT_TYPE_CODE", "CONTRACT_TYPE_DESCRIPTION", "RESOURCE_TYPE", "RESOURCE_TYPE_DESCRIPTION", "HIRING_DATE", "LEAVE_DATE", "LEAVE_TYPE_CODE", "LEAVE_TYPE_DESCRIPTION", "SHORT_TERM_CONTRACT_END_DATE", "BUILDING_CODE", "BUILDING_DESCRIPTION", "COST_CENTRE_CODE", "COST_CENTER_DESCRIPTION", "DESK", "EMPLOYEE_CATEGORY_CODE", "EMPLOYEE_CATEGORY_DESCRIPTION", "LOCATION_ADDRESS", "LOCATION_POSTAL_CODE", "LOCATION_COUNTRY", "LOCATION_CITY") AS 
  SELECT 
    '3002'  AS company_id,
    '00000000000'
    ||a.empno AS employee_id,
    lastname ,
    firstname
    || ' '
    || middlename AS name,
    sex           AS gender,
    dob           AS birth_date,
    itno          AS fiscal_code,
    jobGroup,
    JobGroupDesc ,
    JOBDISCIPLINE ,
    JOBDISCIPLINEDESC ,
    JOBSUBDISCIPLINE,
    JOBSUBDISCIPLINEDESC ,
    JOBCATEGORY ,
    JOBCATEGOORYDESC ,
    JOBSUBCATEGORY,
    JOBSUBCATEGORYDESC ,
    0 AS contract_type_code,
    'Short Term '                                                                                                                                                         AS Contract_type_Description,
    '01'                                                                                                                                                                  AS Resource_Type ,
    'Contract Employee'                                                                                                                                                   AS Resource_Type_Description ,
    doj                                                                                                                                                                   AS hiring_date,
    dol                                                                                                                                                                   AS Leave_Date,
    'NA'                                                                                                                                                                  AS Leave_Type_Code,
    'NA'                                                                                                                                                                  AS Leave_Type_Description,
    contract_end_date                                                                                                                                                     AS Short_term_Contract_End_Date,
    d.office                                                                                                                                                              AS Building_Code,
    DECODE(trim(d.office),'MOC1','Tecnimont ICB House' , 'MOC2' , 'Interface - Seventh floor','MOC3','Interface - First Floor','')                                        AS Building_Description,
    c.sapcc                                                                                                                                                               AS Cost_Centre_Code,
    c.name                                                                                                                                                                AS Cost_Center_Description,
    b.deskid                                                                                                                                                              AS Desk,
    category                                                                                                                                                              AS Employee_Category_Code,
    DECODE(category,'1','Senior Manager','2', 'Mid Manager','3','Employee','')                                                                                            AS Employee_Category_Description,
    DECODE(trim(d.office),'MOC1','504 Link Rd - Tecnimont ICB House - Chincholi Bunder' , 'MOC2' , '702 Interface 11 Link Road ','MOC3','101 Interface 11 Link Road ','') AS location_address,
    DECODE(trim(d.office),'MOC1','400064','MOC2','400064','MOC3','400064','' )                                                                                            AS location_postal_code,
    DECODE(trim(d.office),'MOC1','India ','MOC2','India','MOC3','India','' )                                                                                              AS location_country,
    DECODE(trim(d.office),'MOC1','Mumbai ','MOC2','Mumbai','MOC3','Mumbai','' )     AS location_city
   FROM emplmast a ,
    selfservice.dm_usermaster b ,
    costmast c ,
    selfservice.dm_deskmaster d
  WHERE a.empno  = b.empno(+)
  AND b.deskid   = d.deskid(+)
  AND a.parent   = c.costcode
  AND a.status   = 1
  AND a.emptype <> 'R'

;
