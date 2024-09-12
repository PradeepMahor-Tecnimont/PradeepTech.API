--------------------------------------------------------
--  DDL for View SS_EMPLMAST_ALL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."SS_EMPLMAST_ALL" ("EMPNO", "NAME", "ABBR", "EMPTYPE", "EMAIL", "ASSIGN", "PARENT", "DESGCODE", "PASSWORD", "DOB", "DOJ", "DOL", "DOR", "COSTHEAD", "COSTDY", "PROJMNGR", "PROJDY", "DBA", "DIRECTOR", "STATUS", "SUBMIT", "OFFICE", "PROJNO", "DIROP", "AMFI_USER", "AMFI_AUTH", "SECRETARY", "DO", "INV_AUTH", "JOB_INCHARGE", "COSTOPR", "MNGR", "IPADD", "PWD_CHGD", "DOC", "GRADE", "PROC_OPR", "REPORTO", "COMPANY", "TRANS_OUT", "TRANS_IN", "HR_OPR", "SEX", "USER_DOMAIN", "WEB_ITDECL", "CATEGORY", "ESI_COVER", "EMP_HOD", "SEATREQ", "NEWEMP", "ONDEPUTATION", "OLDCO", "MARRIED", "JOBTITLE", "EOW", "EOW_DATE", "EOW_WEEK", "LASTNAME", "FIRSTNAME", "MIDDLENAME") AS 
  SELECT "EMPNO","NAME","ABBR","EMPTYPE","EMAIL","ASSIGN","PARENT","DESGCODE","PASSWORD","DOB","DOJ","DOL","DOR","COSTHEAD","COSTDY","PROJMNGR","PROJDY","DBA","DIRECTOR","STATUS","SUBMIT","OFFICE","PROJNO","DIROP","AMFI_USER","AMFI_AUTH","SECRETARY","DO","INV_AUTH","JOB_INCHARGE","COSTOPR","MNGR","IPADD","PWD_CHGD","DOC","GRADE","PROC_OPR","REPORTO","COMPANY","TRANS_OUT","TRANS_IN","HR_OPR","SEX","USER_DOMAIN","WEB_ITDECL","CATEGORY","ESI_COVER","EMP_HOD","SEATREQ","NEWEMP","ONDEPUTATION","OLDCO","MARRIED","JOBTITLE","EOW","EOW_DATE","EOW_WEEK","LASTNAME","FIRSTNAME","MIDDLENAME"
  FROM emplmast
;
