--------------------------------------------------------
--  DDL for View IDM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."IDM" ("COMPANY_ID", "EMPLOYEE_ID", "LASTNAME", "NAME", "COMPANY_DESCRIPTION", "GENDER", "BIRTH_DATE", "FISCAL_CODE", "JOBGROUP", "JOBGROUPDESC", "JOBDISCIPLINE", "JOBDISCIPLINEDESC", "JOBSUBDISCIPLINE", "JOBSUBDISCIPLINEDESC", "JOBCATEGORY", "JOBCATEGOORYDESC", "JOBSUBCATEGORY", "JOBSUBCATEGORYDESC", "CONTRACT_TYPE_CODE", "CONTRACT_TYPE_DESCRIPTION", "RESOURCE_TYPE", "RESOURCE_TYPE_DESCRIPTION", "HIRING_DATE", "LEAVE_DATE", "SHORT_TERM_CONTRACT_END_DATE", "DATE_OF_RETURN", "BUILDING_CODE", "BUILDING_DESCRIPTION", "COST_CENTRE_CODE", "COST_CENTER_DESCRIPTION", "DESK", "EMPLOYEE_CATEGORY_CODE", "EMPLOYEE_CATEGORY_DESCRIPTION", "LOCATION_ADDRESS", "LOCATION_POSTAL_CODE", "LOCATION_COUNTRY", "LOCATION_CITY", "LOCATION_CITY_CODE", "EMPLOYEE_ON_DEP", "SITE_CODE", "SITE_DESCRIPTION", "METAID", "COMPANY_EMAIL", "USER_STATUS", "PERSONID", "CID") AS 
  (SELECT '3002' AS company_id,
    '00000000000'
    ||a.empno AS employee_id,
    lastname ,
    firstname
    || ' '
    || Middlename                                                                                                                                                         AS Name,
    'Tecnimont Private Limited'                                                                                                                                             AS Company_Description,
    NVL(sex,'M')                                                                                                                                                          AS gender,
    dob                                                                                                                                                                   AS birth_date,
    Itno                                                                                                                                                                  AS Fiscal_Code,
    NVL(jobGroup,'NA')                                                                                                                                                    AS jobGroup,
    NVL(JobGroupDesc,'NA')                                                                                                                                                AS JobGroupDesc ,
    NVL(JOBDISCIPLINE ,'NA')                                                                                                                                              AS JOBDISCIPLINE,
    NVL(JOBDISCIPLINEDESC,'NA')                                                                                                                                           AS JOBDISCIPLINEDESC,
    NVL(JOBSUBDISCIPLINE,'NA')                                                                                                                                            AS JOBSUBDISCIPLINE,
    NVL(JOBSUBDISCIPLINEDESC,'NA')                                                                                                                                        AS JOBSUBDISCIPLINEDESC ,
    NVL(JOBCATEGORY ,'NA')                                                                                                                                                AS JOBCATEGORY,
    NVL(JOBCATEGOORYDESC ,'NA')                                                                                                                                           AS JOBCATEGOORYDESC,
    NVL(Jobsubcategory,'NA')                                                                                                                                              AS Jobsubcategory ,
    NVL(JOBSUBCATEGORYDESC,'NA')                                                                                                                                          AS JOBSUBCATEGORYDESC ,
    '00'                                                                                                                                                                  AS contract_type_code,
    'Long Term '                                                                                                                                                          AS Contract_type_Description,
    '00'                                                                                                                                                                  AS Resource_Type ,
    'Permanent Employee'                                                                                                                                                  AS Resource_Type_Description ,
    doj                                                                                                                                                                   AS hiring_date,
    dol                                                                                                                                                                   AS Leave_Date,
    Contract_End_Date                                                                                                                                                     AS Short_Term_Contract_End_Date,
    DECODE(a.ondeputation,0,NULL,1,a.dor,NULL )                                                                                                                           AS Date_of_Return,
    d.office                                                                                                                                                              AS Building_Code,
    DECODE(trim(d.office),'MOC1','Tecnimont House' , 'MOC2' , 'Interface - Seventh floor','MOC3','Interface - First Floor','')                                        AS Building_Description,
    get_parent_assign(a.empno)                                                                                                                                                               AS Cost_Centre_Code,
    get_costcode_name(a.empno)                                                                                                                                                                AS Cost_Center_Description,
    B.Deskid                                                                                                                                                              AS Desk,
    NVL(category ,3)                                                                                                                                                      AS Employee_Category_Code,
    DECODE(category,'1','Senior Manager','2', 'Mid Manager','3','Employee','4','Worker','')                                                                               AS Employee_Category_Description,
    DECODE(trim(d.office),'MOC1','504 Link Rd - Tecnimont House - Chincholi Bunder' , 'MOC2' , '702 Interface 11 Link Road ','MOC3','101 Interface 11 Link Road ','') AS location_address,
    DECODE(Trim(D.Office),'MOC1','400064','MOC2','400064','MOC3','400064','' )                                                                                            AS Location_Postal_Code,
    DECODE(trim(d.office),'MOC1','IN','MOC2','IN','MOC3','IN','' )                                                                                                        AS location_country,
    DECODE(Trim(D.Office),'MOC1','Mumbai ','MOC2','Mumbai','MOC3','Mumbai','' )                                                                                           AS Location_City,
    DECODE(trim(d.office),'MOC1','MB','MOC2','MB','MOC3','MB','' )                                                                                                        AS location_city_code,
    DECODE(a.ondeputation,0,0,1,1,2,1,0)                                                                                                                                  AS Employee_on_Dep,
    ''                                                                                                                                                                    AS sITE_CODE,
    ''                                                                                                                                                                    AS Site_Description,
    ''                                                                                                                                                                    AS Metaid,
    a.email                                                                                                                                                               AS Company_Email,
    1                                                                                                                                                                     AS user_status,
    a.personid,
    a.cid
  FROM emplmast a ,
    (SELECT empno,
      MIN(deskid) deskid
    FROM dms.dm_usermaster
    GROUP BY empno
    ) b,
    costmast c ,
    dms.dm_deskmaster d
  WHERE a.empno = b.empno(+)
  AND b.deskid  = d.deskid(+)
  AND a.parent  = c.costcode
  AND A.Status  = 1
  AND a.emptype = 'R'
  AND a.parent <> '0187'
  AND nvl(a.no_tcm_upd,0) = 0 
  UNION
  SELECT '3002' AS company_id,
    '00000000000'
    ||a.empno AS employee_id,
    lastname ,
    firstname
    || ' '
    || Middlename                                                                                                                                                         AS Name,
    'Tecnimont Private Limited'                                                                                                                                             AS Company_Description,
    NVL(sex,'M')                                                                                                                                                          AS gender,
    dob                                                                                                                                                                   AS birth_date,
    Itno                                                                                                                                                                  AS Fiscal_Code,
    NVL(jobGroup,'NA')                                                                                                                                                    AS jobGroup,
    NVL(JobGroupDesc,'NA')                                                                                                                                                AS JobGroupDesc ,
    NVL(JOBDISCIPLINE ,'NA')                                                                                                                                              AS JOBDISCIPLINE,
    NVL(JOBDISCIPLINEDESC,'NA')                                                                                                                                           AS JOBDISCIPLINEDESC,
    NVL(JOBSUBDISCIPLINE,'NA')                                                                                                                                            AS JOBSUBDISCIPLINE,
    NVL(JOBSUBDISCIPLINEDESC,'NA')                                                                                                                                        AS JOBSUBDISCIPLINEDESC ,
    NVL(JOBCATEGORY ,'NA')                                                                                                                                                AS JOBCATEGORY,
    NVL(JOBCATEGOORYDESC ,'NA')                                                                                                                                           AS JOBCATEGOORYDESC,
    NVL(Jobsubcategory,'NA')                                                                                                                                              AS Jobsubcategory ,
    NVL(JOBSUBCATEGORYDESC,'NA')                                                                                                                                          AS JOBSUBCATEGORYDESC ,
    '01'                                                                                                                                                                  AS contract_type_code,
    'Short Term '                                                                                                                                                         AS Contract_type_Description,
    '01'                                                                                                                                                                  AS Resource_Type ,
    'Contract Employee'                                                                                                                                                   AS Resource_Type_Description ,
    doj                                                                                                                                                                   AS hiring_date,
    dol                                                                                                                                                                   AS Leave_Date,
    Contract_End_Date                                                                                                                                                     AS Short_Term_Contract_End_Date,
    DECODE(a.ondeputation,0,NULL,1,a.dor,NULL )                                                                                                                           AS Date_of_Return,
    d.office                                                                                                                                                              AS Building_Code,
    DECODE(trim(d.office),'MOC1','Tecnimont House' , 'MOC2' , 'Interface - Seventh floor','MOC3','Interface - First Floor','')                                        AS Building_Description,
    get_parent_assign(a.empno)                                                                                                                                                               AS Cost_Centre_Code,
    get_costcode_name(a.empno)                                                                                                                                                             AS Cost_Center_Description,
    b.deskid                                                                                                                                                              AS Desk,
    NVL(category ,3)                                                                                                                                                      AS Employee_Category_Code,
    DECODE(category,'1','Senior Manager','2', 'Mid Manager','3','Employee','4','Worker','')                                                                               AS Employee_Category_Description,
    DECODE(trim(d.office),'MOC1','504 Link Rd - Tecnimont House - Chincholi Bunder' , 'MOC2' , '702 Interface 11 Link Road ','MOC3','101 Interface 11 Link Road ','') AS location_address,
    DECODE(Trim(D.Office),'MOC1','400064','MOC2','400064','MOC3','400064','' )                                                                                            AS Location_Postal_Code,
    DECODE(trim(d.office),'MOC1','IN ','MOC2','IN','MOC3','IN','' )                                                                                                       AS location_country,
    DECODE(Trim(D.Office),'MOC1','Mumbai ','MOC2','Mumbai','MOC3','Mumbai','' )                                                                                           AS Location_City,
    DECODE(trim(d.office),'MOC1','MB','MOC2','MB','MOC3','MB','' )                                                                                                        AS location_city_code,
    DECODE(a.ondeputation,0,0,1,1,2,1,0)                                                                                                                                  AS Employee_on_Dep,
    ''                                                                                                                                                                    AS sITE_CODE,
    ''                                                                                                                                                                    AS Site_Description,
    ''                                                                                                                                                                    AS Metaid,
    a.email                                                                                                                                                               AS Company_Email,
    1                                                                                                                                                                     AS user_status,
    a.personid,
    a.cid
  FROM emplmast a ,
    (SELECT empno,
      MIN(deskid) deskid
    FROM dms.dm_usermaster
    GROUP BY empno
    ) b ,
    costmast c ,
    dms.dm_deskmaster d
  WHERE a.empno = b.empno(+)
  AND b.deskid  = d.deskid(+)
  AND a.parent  = c.costcode
  AND A.Status  = 1
  AND A.Emptype = 'C'
  )
;
