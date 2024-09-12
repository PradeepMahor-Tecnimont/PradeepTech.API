Create Table "TCMPL_APP_CONFIG"."SEC_MODULE_DELEGATE_LOG"
   ("KEY_ID" Varchar2(10 Byte) Not Null Enable,
    "MODULE_ID" Char(3 Byte) Not Null Enable,
    "PRINCIPAL_EMPNO" Char(5 Byte) Not Null Enable,
    "ON_BEHALF_EMPNO" Char(5 Byte) Not Null Enable,

    "LOG_STATUS" Varchar2(10 Byte) Not Null Enable,
    "MODIFIED_BY" Char(5 Byte) Not Null Enable,
    "MODIFIED_ON" Date Not Null Enable,
     Constraint "SEC_MODULE_DELEGATE_LOG_PK" Primary Key ("KEY_ID"));

  Grant Select On "TCMPL_APP_CONFIG"."SEC_MODULE_DELEGATE_LOG" To "TIMECURR";