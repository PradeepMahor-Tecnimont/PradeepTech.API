--------------------------------------------------------
--  DDL for View IDM_TEST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."IDM_TEST" ("COMPANY_ID", "EMPLOYEE_ID", "LASTNAME", "NAME", "GENDER", "BIRTH_DATE", "FISCAL_CODE", "JOBGROUP", "JOBGROUPDESC", "JOBDISCIPLINE", "JOBDISCIPLINEDESC", "JOBSUBDISCIPLINE", "JOBSUBDISCIPLINEDESC", "JOBCATEGORY", "JOBCATEGOORYDESC", "JOBSUBCATEGORY", "JOBSUBCATEGORYDESC", "CONTRACT_TYPE_CODE", "CONTRACT_TYPE_DESCRIPTION", "RESOURCE_TYPE", "RESOURCE_TYPE_DESCRIPTION", "HIRING_DATE", "LEAVE_DATE", "SHORT_TERM_CONTRACT_END_DATE", "DATE_OF_RETURN", "BUILDING_CODE", "BUILDING_DESCRIPTION", "COST_CENTRE_CODE", "COST_CENTER_DESCRIPTION", "DESK", "EMPLOYEE_CATEGORY_CODE", "EMPLOYEE_CATEGORY_DESCRIPTION", "LOCATION_ADDRESS", "LOCATION_POSTAL_CODE", "LOCATION_COUNTRY", "LOCATION_CITY", "EMPLOYEE_ON_DEP", "SITE_CODE", "SITE_DESCRIPTION", "METAID", "COMPANY_EMAIL", "USER_STATUS") AS 
  (SELECT '3002' AS company_id,
    '00000000000'
    ||a.empno AS employee_id,
    lastname ,
    firstname
    || ' '
    || middlename AS name,
    sex           AS gender,
    dob           AS birth_date,
    Itno          As Fiscal_Code,
    nvl(jobGroup,'na'),
   nvl(JobGroupDesc,'NA') ,
     nvl(JOBDISCIPLINE ,'NA'),
     nvl(JOBDISCIPLINEDESC,'NA') ,
     nvl(JOBSUBDISCIPLINE,'NA'),
     nvl(JOBSUBDISCIPLINEDESC,'NA') ,
     nvl(JOBCATEGORY ,'NA'),
     nvl(JOBCATEGOORYDESC ,'NA'),
     Nvl(Jobsubcategory,'NA'),
     nvl(JOBSUBCATEGORYDESC,'NA') ,
    '00'                                                                                                                                                                  AS contract_type_code,
    'Long Term '                                                                                                                                                          AS Contract_type_Description,
    '00'                                                                                                                                                                  AS Resource_Type ,
    'Permanent Employee'                                                                                                                                                  AS Resource_Type_Description ,
    doj                                                                                                                                                                   AS hiring_date,
    dol                                                                                                                                                                   AS Leave_Date,
    contract_end_date                                                                                                                                                     AS Short_term_Contract_End_Date,
    a.dor                                                                                                                                                                 AS Date_of_Return,
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
    DECODE(trim(d.office),'MOC1','Mumbai ','MOC2','Mumbai','MOC3','Mumbai','' )                                                                                           AS location_city,
    DECODE(a.assign,'0236',1,'0238',1,0)                                                                                                                                  AS Employee_on_Dep,
    ''                                                                                                                                                                    AS sITE_CODE,
    ''                                                                                                                                                                    AS Site_Description,
    ''                                                                                                                                                                    AS Metaid,
    a.email                                                                                                                                                               AS Company_Email,
    1                                                                                                                                                                     AS user_status
  FROM emplmast a ,
    selfservice.dm_usermaster b ,
    costmast c ,
    selfservice.dm_deskmaster d
  WHERE a.empno = b.empno(+)
  AND b.deskid  = d.deskid(+)
  AND a.parent  = c.costcode
  AND a.status  = 1
  AND a.emptype = 'R'
  )
UNION
  (SELECT '3002' AS company_id,
    '00000000000'
    ||a.empno AS employee_id,
    lastname ,
    firstname
    || ' '
    || middlename AS name,
    sex           AS gender,
    dob           AS birth_date,
    Itno          As Fiscal_Code,
    nvl(jobGroup,'NA'),
   nvl(JobGroupDesc,'NA') ,
     nvl(JOBDISCIPLINE ,'NA'),
     nvl(JOBDISCIPLINEDESC,'NA') ,
     nvl(JOBSUBDISCIPLINE,'NA'),
     nvl(JOBSUBDISCIPLINEDESC,'NA') ,
     nvl(JOBCATEGORY ,'NA'),
     nvl(JOBCATEGOORYDESC ,'NA'),
     nvl(JOBSUBCATEGORY,'NA'),
     nvl(JOBSUBCATEGORYDESC,'NA') ,
    '01'                                                                                                                                                                  AS contract_type_code,
    'Short Term '                                                                                                                                                         AS Contract_type_Description,
    '01'                                                                                                                                                                  AS Resource_Type ,
    'Contract Employee'                                                                                                                                                   AS Resource_Type_Description ,
    doj                                                                                                                                                                   AS hiring_date,
    dol                                                                                                                                                                   AS Leave_Date,
    contract_end_date                                                                                                                                                     AS Short_term_Contract_End_Date,
    a.dor                                                                                                                                                                 AS Date_of_Return,
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
    DECODE(trim(d.office),'MOC1','Mumbai ','MOC2','Mumbai','MOC3','Mumbai','' )                                                                                           AS location_city,
    DECODE(a.assign,'0236',1,'0238',1,0)                                                                                                                                  AS Employee_on_Dep,
    ''                                                                                                                                                                    AS sITE_CODE,
    ''                                                                                                                                                                    AS Site_Description,
    ''                                                                                                                                                                    AS Metaid,
    a.email                                                                                                                                                               AS Company_Email,
    1                                                                                                                                                                     AS user_status
  FROM emplmast a ,
    selfservice.dm_usermaster b ,
    costmast c ,
    selfservice.dm_deskmaster d
  WHERE a.empno  = b.empno(+)
  AND b.deskid   = d.deskid(+)
  AND a.parent   = c.costcode
  AND a.status   = 1
  AND a.emptype <> 'R'
  AND (a.empno LIKE 'EC%'
  Or A.Empno Like 'OC%')
  )
;
