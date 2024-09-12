Create Table "TCMPL_APP_CONFIG"."SEC_MODULE_USER_ROLES_DELETE"
   ("KEY_ID" Varchar2(10 Byte) Not Null Enable,
    "MODULE_ID" Char(3 Byte) Not Null Enable,
    "ROLE_ID" Char(4 Byte) Not Null Enable,
    "EMPNO" Char(5 Byte) Not Null Enable,    
    "MODULE_ROLE_KEY_ID" Char(7 Byte) Not Null Enable,
    "MODIFIED_BY" Char(5 Byte) Not Null Enable,
    "MODIFIED_ON" Date Not Null Enable,
     Constraint "SEC_MODULE_USER_ROLES_DELETE_PK" Primary Key ("KEY_ID")
   );