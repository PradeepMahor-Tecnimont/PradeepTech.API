create table "DMS"."DM_AREA_TYPE" (
   "KEY_ID"      varchar2(4 byte)
      not null enable,
   "SHORT_DESC"  varchar2(50 byte)
      not null enable,
   "DESCRIPTION" varchar2(150 byte)
      not null enable,
   "IS_ACTIVE"   number
      not null enable,
   "AREA_TYPE"   varchar2(4 byte)
      not null enable,
   "MODIFIED_ON" date
      not null enable,
   "MODIFIED_BY" varchar2(5 byte)
      not null enable,
   constraint "DM_AREA_TYPE_PK" primary key ( "KEY_ID" )
      using index pctfree 10 initrans 2 maxtrans 255
         storage ( initial 65536 next 1048576 minextents 1 maxextents 2147483645 pctincrease 0 freelists 1 freelist groups 1 buffer_pool
         default flash_cache default cell_flash_cache default )
      tablespace "APPL_DATA"
   enable
)
segment creation immediate
pctfree 10 pctused 40 initrans 1 maxtrans 255 nocompress logging
   storage ( initial 65536 next 1048576 minextents 1 maxextents 2147483645 pctincrease 0 freelists 1 freelist groups 1 buffer_pool
   default flash_cache default cell_flash_cache default )
tablespace "APPL_DATA";