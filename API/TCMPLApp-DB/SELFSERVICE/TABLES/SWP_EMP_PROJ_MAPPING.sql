Create Table "SELFSERVICE"."SWP_EMP_PROJ_MAPPING"
   ("KYE_ID" Varchar2(20 Byte) Not Null Enable,
   "EMPNO" Char(5 Byte),
   "PROJNO" Varchar2(20 Byte),
   "MODIFIED_ON" Date,
   "MODIFIED_BY" Char(5 Byte),
    Constraint "SWP_EMP_PROJ_MAPPING_PK" Primary Key ("KYE_ID")
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