create table "SELFSERVICE"."SS_EMP_FOR_ONDUTY_SWP"
   ("EMPNO" char(5 byte) not null enable,
    constraint "SS_EMP_FOR_ONDUTY_SWP_PK" primary key ("EMPNO")
  using index pctfree 10 initrans 2 maxtrans 255
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