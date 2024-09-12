--------------------------------------------------------
--  DDL for View TO_BE_DELETED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TCMPL_HR"."TO_BE_DELETED" ("KEY_ID", "EMPNO", "EMPLOYEE_NAME", "UPLOAD_BY_GROUP", "UPLOAD_BY_EMPNO", "UPLOAD_BY_EMPLOYEE_NAME", "CLIENT_FILE_NAME", "SERVER_FILE_NAME", "UPLOAD_DATE") AS 
  Select
    key_id,
    empno,
    ofb_user.get_name_from_empno(p_empno => empno)                  employee_name,
    upload_by_group,
    upload_by_empno,
    ofb_user.get_name_from_empno(p_empno => upload_by_empno)        upload_by_employee_name,
    client_file_name,
    server_file_name,
    upload_date
From
    ofb_files
;
  GRANT SELECT ON "TCMPL_HR"."TO_BE_DELETED" TO "TCMPL_APP_CONFIG";
