create table "TCMPL_HR"."DG_ANNU_EVALUATION" (
   "KEY_ID"            char(8 byte)
      not null enable,
   "EMPNO"             char(5 byte)
      not null enable,
   "DESGCODE"          varchar2(20 byte)
      not null enable,
   "PARENT"            char(4 byte)
      not null enable,
   "ATTENDANCE"        number
      not null enable,
   "LOCATION"          varchar2(3 byte),
   "TRAINING_1"        varchar2(800 byte),
   "TRAINING_2"        varchar2(800 byte),
   "TRAINING_3"        varchar2(800 byte),
   "TRAINING_4"        varchar2(800 byte)
      not null enable,
   "TRAINING_5"        varchar2(800 byte),
   "FEEDBACK_1"        varchar2(800 byte),
   "FEEDBACK_2"        varchar2(800 byte),
   "FEEDBACK_3"        varchar2(800 byte),
   "FEEDBACK_4"        varchar2(800 byte),
   "FEEDBACK_5"        varchar2(800 byte),
   "FEEDBACK_6"        varchar2(800 byte),
   "COMMENTS_OF_HR"    varchar2(400 byte),
   "CREATED_BY"        char(5 byte),
   "CREATED_ON"        date,
   "MODIFIED_BY"       char(5 byte),
   "MODIFIED_ON"       date,
   "ISDELETED"         number(1, 0) default 0,
   "HOD_APPROVAL"      varchar2(2 byte),
   "HOD_APPROVAL_DATE" date,
   "HR_APPROVAL"       varchar2(2 byte) default 'KO',
   "HR_APPROVAL_DATE"  date default null,
   "HR_APPROVE_BY"     varchar2(5 byte),
   constraint "DG_ANNU_EVALUATION_PK" primary key ( "KEY_ID" )
      using index pctfree 10 initrans 2 maxtrans 255 compute statistics
         storage ( initial 65536 next 1048576 minextents 1 maxextents 2147483645 pctincrease 0 freelists 1 freelist groups 1 buffer_pool
         default flash_cache default cell_flash_cache default )
      tablespace "APPL_DATA"
   enable,
   constraint "DG_ANNU_EVALUATION_UK" unique ( "EMPNO" )
      using index pctfree 10 initrans 2 maxtrans 255 compute statistics
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