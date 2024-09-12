Create Table "TIMECURR"."PROJECT_TYPE"
   ("CODE" Varchar2(2 Byte) Not Null Enable,
    "DESCRIPTION" Varchar2(100 Byte) Not Null Enable,
    "SHORT_DESCRIPTION" Varchar2(20 Byte) Not Null Enable,
     Constraint "PROJECT_TYPE_PK" Primary Key ("CODE")
  Using Index Pctfree 10 Initrans 2 Maxtrans 255 Compute Statistics
  Storage(Initial 65536 Next 1048576 Minextents 1 Maxextents 2147483645
  Pctincrease 0 Freelists 1 Freelist Groups 1
  Buffer_Pool Default Flash_Cache Default Cell_Flash_Cache Default)
  Tablespace "APPL_DATA"  Enable,
     Constraint "PROJECT_TYPE_UK1" Unique ("SHORT_DESCRIPTION")
  Using Index Pctfree 10 Initrans 2 Maxtrans 255 Compute Statistics
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