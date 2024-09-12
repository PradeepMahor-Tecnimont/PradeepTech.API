Create Table "TCMPL_APP_CONFIG"."SEC_MODULE_USER_ROLES_LOG"
   ("KEY_ID" Varchar2(10 Byte) Not Null Enable,
    "MODULE_ID" Char(3 Byte) Not Null Enable,
    "ROLE_ID" Char(4 Byte) Not Null Enable,
    "EMPNO" Char(5 Byte) Not Null Enable,
    "MODULE_ROLE_KEY_ID" Char(7 Byte) Not Null Enable,
    "MODIFIED_BY" Char(5 Byte) Not Null Enable,
    "MODIFIED_ON" Date Not Null Enable,
     Constraint "SEC_MODULE_USER_ROLES_LOG_PK" Primary Key ("KEY_ID")
  Using Index Pctfree 10 Initrans 2 Maxtrans 255
  Storage(Initial 65536 Next 1048576 Minextents 1 Maxextents 2147483645
  Pctincrease 0 Freelists 1 Freelist Groups 1
  Buffer_Pool Default Flash_Cache Default Cell_Flash_Cache Default)
  Tablespace "APPL_DATA"  Enable
   ) Segment Creation Immediate
  Pctfree 10 Pctused 40 Initrans 1 Maxtrans 255
 Nocompress Logging
  Storage(Initial 65536 Next 1048576 Minextents 1 Maxextents 2147483645
  Pctincrease 0 Freelists 1 Freelist Groups 1
  Buffer_Pool Default Flash_Cache Default Cell_Flash_Cache Default)
  Tablespace "APPL_DATA";