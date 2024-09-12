create table "DMS"."DM_AREA_TYPE_PROJECT_MAPPING" (
   "KEY_ID"      varchar2(5 byte)
      not null enable,
   "AREA_ID"     varchar2(3 byte)
      not null enable,
   "PROJECT_NO"  varchar2(5 byte)
      not null enable,
   "MODIFIED_ON" date
      not null enable,
   "MODIFIED_BY" varchar2(5 byte)
      not null enable,
   constraint "DM_AREA_TYPE_PROJECT_MAPPING_UK1" unique ( "KEY_ID" )
      using index pctfree 10 initrans 2 maxtrans 255 compute statistics
         storage ( initial 65536 next 1048576 minextents 1 maxextents 2147483645 pctincrease 0 freelists 1 freelist groups 1 buffer_pool
         default flash_cache default cell_flash_cache default )
      tablespace "APPL_DATA"
   enable,
   constraint "DM_AREA_TYPE_PROJECT_MAPPING_PK" primary key ( "AREA_ID",
                                                              "PROJECT_NO" )
      using index pctfree 10 initrans 2 maxtrans 255 compute statistics
         storage ( initial 65536 next 1048576 minextents 1 maxextents 2147483645 pctincrease 0 freelists 1 freelist groups 1 buffer_pool
         default flash_cache default cell_flash_cache default )
      tablespace "APPL_DATA"
   enable
);