--------------------------------------------------------
--  DDL for Table SWP_PRIMARY_WORKSPACE
--------------------------------------------------------
Create Table "SELFSERVICE"."SWP_PRIMARY_WORKSPACE"
   ("KEY_ID" Varchar2(10 Byte) Not Null Enable,
    "EMPNO" Char(5 Byte) Not Null Enable,
    "PRIMARY_WORKSPACE" Number(1, 0),
    "START_DATE" Date Not Null Enable,
    "MODIFIED_ON" Date Not Null Enable,
    "MODIFIED_BY" Varchar2(5 Byte) Not Null Enable,
    "ACTIVE_CODE" Number(1, 0),
    "ASSIGN_CODE" Varchar2(4 Byte),
     Constraint "SWP_PRIMARY_WORKSPACE_PK" Primary Key ("EMPNO", "START_DATE")
  Using Index Pctfree 10 Initrans 2 Maxtrans 255 Compute Statistics
  Storage(Initial 65536 Next 1048576 Minextents 1 Maxextents 2147483645
  Pctincrease 0 Freelists 1 Freelist Groups 1
  Buffer_Pool Default Flash_Cache Default Cell_Flash_Cache Default)
  Tablespace "APPL_DATA"  Enable,
     Constraint "SWP_PRIMARY_WORKSPACE_FK1" Foreign Key ("PRIMARY_WORKSPACE")
      References "SELFSERVICE"."SWP_PRIMARY_WORKSPACE_TYPES" ("TYPE_CODE") Enable
   ) Segment Creation Immediate
  Pctfree 10 Pctused 40 Initrans 1 Maxtrans 255
 Nocompress Logging
  Storage(Initial 65536 Next 1048576 Minextents 1 Maxextents 2147483645
  Pctincrease 0 Freelists 1 Freelist Groups 1
  Buffer_Pool Default Flash_Cache Default Cell_Flash_Cache Default)
  Tablespace "APPL_DATA";

   Comment On Column "SELFSERVICE"."SWP_PRIMARY_WORKSPACE"."PRIMARY_WORKSPACE" Is '1(Office),2(SmartWork),3(Not in mumbai office)';
   Comment On Column "SELFSERVICE"."SWP_PRIMARY_WORKSPACE"."ACTIVE_CODE" Is '2(Current/Future), 1(Current), 0(Past)';