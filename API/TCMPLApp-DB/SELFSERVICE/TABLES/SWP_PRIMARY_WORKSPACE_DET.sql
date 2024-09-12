create table "SELFSERVICE"."SWP_PRIMARY_WORKSPACE_DET"
   ("KEY_ID" varchar2(10 byte) not null enable,
   "EMPNO" varchar2(5 byte) not null enable,
   "PRIMARY_WORKSPACE" number not null enable,
   "START_DATE" date not null enable,
   "SOURCE_MODIFIEDON" date not null enable,
   "SOURCE_MODIFIEDBY" varchar2(5 byte) not null enable,
   "DELETED_ON" date not null enable,
   "DELETED_BY" varchar2(5 byte) not null enable,
    constraint "SWP_PRIMARY_WORKSPACE_DET_PK" primary key ("KEY_ID")
  using index pctfree 10 initrans 2 maxtrans 255 compute statistics
  storage(initial 65536 next 1048576 minextents 1 maxextents 2147483645
  pctincrease 0 freelists 1 freelist groups 1
  buffer_pool default flash_cache default cell_flash_cache default)
  tablespace "APPL_DATA"  enable
   ) segment creation immediate
  pctfree 10 pctused 40 initrans 1 maxtrans 255
 nocompress logging
  storage(initial 65536 next 1048576 minextents 1 maxextents 2147483645
  pctincrease 0 freelists 1 freelist groups 1
  buffer_pool default flash_cache default cell_flash_cache default)
  tablespace "APPL_DATA";