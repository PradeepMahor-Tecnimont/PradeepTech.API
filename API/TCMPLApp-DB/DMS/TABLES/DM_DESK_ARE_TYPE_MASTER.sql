create table "DMS"."DM_DESK_ARE_TYPE_MASTER" (
   "TYPE_CODE"   varchar2(4 byte)
      not null enable,
   "DESCRIPTION" varchar2(50 byte),
   constraint "DM_DESK_ARE_TYPE_MASTER_PK" primary key ( "TYPE_CODE" )
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

insert into "DMS"."DM_DESK_ARE_TYPE_MASTER" (
   type_code,
   description
) values (
   'DT01',
   'DEPT'
);
insert into "DMS"."DM_DESK_ARE_TYPE_MASTER" (
   type_code,
   description
) values (
   'DT02',
   'Project'
);
insert into "DMS"."DM_DESK_ARE_TYPE_MASTER" (
   type_code,
   description
) values (
   'DT03',
   'Emp'
);
insert into "DMS"."DM_DESK_ARE_TYPE_MASTER" (
   type_code,
   description
) values (
   'DT04',
   'Open Area'
);
insert into "DMS"."DM_DESK_ARE_TYPE_MASTER" (
   type_code,
   description
) values (
   'DT05',
   'Semi Fixed Users'
);
insert into "DMS"."DM_DESK_ARE_TYPE_MASTER" (
   type_code,
   description
) values (
   'DT00',
   'Not for DeskBooking'
);