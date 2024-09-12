--------------------------------------------------------
--  DDL for View SS_EMP_PRINT_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_EMP_PRINT_LOG" ("EMPNO", "PRINT_DATE", "TIME", "PRINT_SERVER", "QUE_NAME", "USERID", "USERID2", "PC_NAME", "FILE_NAME", "PAGES", "NOT_KNOWN", "COPIES", "COLUMN12", "PRINT_TYPE", "COLOR", "PAGE_SIZE", "FIELD_1", "FIELD_2", "FIELD_3", "FIELD_4", "FIELD_5", "FIELD_6") AS 
  SELECT b.EMPNO,
  a."PRINT_DATE",a."TIME",a."PRINT_SERVER",a."QUE_NAME",a."USERID",a."USERID2",a."PC_NAME",a."FILE_NAME",a."PAGES",a."NOT_KNOWN",a."COPIES",a."COLUMN12",a."PRINT_TYPE",a."COLOR",a."PAGE_SIZE",a."FIELD_1",a."FIELD_2",a."FIELD_3",a."FIELD_4",a."FIELD_5",a."FIELD_6"
FROM ss_print_log a,
  userids b
WHERE upper(a.USERID) = upper(b.USERID)
AND b.DOMAIN          = 'TICB'
;
