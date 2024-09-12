Create Table "TCMPL_AFC"."AFC_LC_MAIN_PO_SAP_INVOICE"
   ("KEY_ID" Char(8 Byte) Not Null Enable,
   "LC_KEY_ID" Char(8 Byte),
   "PO" Number(10, 5),
   "SAP" Number(10, 5),
   "INVOICE" Number(10, 5),
   "MODIFIED_ON" Date,
   "MODIFIED_BY" Varchar2(5 Byte),
    Constraint "AFC_Lc_Main_Po_Sap_Invoice_PK" Primary Key ("KEY_ID")
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