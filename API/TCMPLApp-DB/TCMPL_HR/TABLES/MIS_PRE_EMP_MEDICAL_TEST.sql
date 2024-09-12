Create Table "TCMPL_HR"."MIS_PRE_EMP_MEDICAL_TEST"
   ("KEY_ID" Varchar2(5 Byte) Not Null Enable,
    "PRE_MEDICAL_TEST" Varchar2(20 Byte) Not Null Enable,
    "IS_ACTIVE" Number Default 1 Not Null Enable,
    "MODIFIED_BY" Varchar2(5 Byte) Not Null Enable,
    "MODIFIED_ON" Date Default sysdate Not Null Enable,
     Constraint "MIS_PRE_EMP_MEDICAL_TEST_PK" Primary Key ("KEY_ID")
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