Create Table "TCMPL_AFC"."BG_PPC_MAST"
   ("PPCID" Varchar2(8 Byte) Not Null Enable,
    "EMPNO" Varchar2(5 Byte) Not Null Enable,
    "PROJECTNO" Varchar2(5 Byte) Not Null Enable,
    "COMPID" Varchar2(4 Byte) Not Null Enable,
    "ISVISIBLE" Number(1, 0),
    "ISDELETED" Number(1, 0),
    "MODIFIEDBY" Varchar2(5 Byte),
    "MODIFIEDON" Date,
     Constraint "BG_PPC_MAST_PK" Primary Key ("PPCID")
  Using Index Pctfree 10 Initrans 2 Maxtrans 255 Compute Statistics
  Storage(Initial 65536 Next 1048576 Minextents 1 Maxextents 2147483645
  Pctincrease 0 Freelists 1 Freelist Groups 1
  Buffer_Pool Default Flash_Cache Default Cell_Flash_Cache Default)
  Tablespace "APPL_DATA"  Enable
   )