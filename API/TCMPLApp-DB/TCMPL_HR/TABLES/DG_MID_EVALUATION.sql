create table "TCMPL_HR"."DG_MID_EVALUATION" (
    "KEY_ID"            char(8 byte)
        not null enable,
    "EMPNO"             char(5 byte)
        not null enable,
    "DESGCODE"          varchar2(20 byte)
        not null enable,
    "PARENT"            char(4 byte)
        not null enable,
    "ATTENDANCE"        varchar2(50 byte)
        not null enable,
    "LOCATION"          varchar2(3 byte),
    "SKILL_1"           varchar2(50 byte),
    "SKILL_1_RATING"    number(1, 0),
    "SKILL_1_REMARK"    varchar2(100 byte),
    "SKILL_2"           varchar2(50 byte),
    "SKILL_2_RATING"    number(1, 0),
    "SKILL_2_REMARK"    varchar2(100 byte),
    "SKILL_3"           varchar2(50 byte),
    "SKILL_3_RATING"    number(1, 0),
    "SKILL_3_REMARK"    varchar2(100 byte),
    "SKILL_4"           varchar2(50 byte),
    "SKILL_4_RATING"    number(1, 0),
    "SKILL_4_REMARK"    varchar2(100 byte),
    "SKILL_5"           varchar2(50 byte),
    "SKILL_5_RATING"    number(1, 0),
    "SKILL_5_REMARK"    varchar2(100 byte),
    "QUE_2_RATING"      number(1, 0)
        not null enable,
    "QUE_2_REMARK"      varchar2(100 byte)
        not null enable,
    "QUE_3_RATING"      number(1, 0)
        not null enable,
    "QUE_3_REMARK"      varchar2(100 byte)
        not null enable,
    "QUE_4_RATING"      number(1, 0)
        not null enable,
    "QUE_4_REMARK"      varchar2(100 byte)
        not null enable,
    "QUE_5_RATING"      number(1, 0)
        not null enable,
    "QUE_5_REMARK"      varchar2(100 byte)
        not null enable,
    "QUE_6_RATING"      number(1, 0)
        not null enable,
    "QUE_6_REMARK"      varchar2(100 byte)
        not null enable,
    "OBSERVATIONS"      varchar2(400 byte),
    "CREATED_BY"        char(5 byte),
    "CREATED_ON"        date,
    "MODIFIED_BY"       char(5 byte),
    "MODIFIED_ON"       date,
    "ISDELETED"         number(1, 0) default 0,
    "HOD_APPROVAL"      varchar2(2 byte),
    "HOD_APPROVAL_DATE" date,
    constraint "DG_MID_EVALUATION_PK" primary key ( "KEY_ID" )
        using index pctfree 10 initrans 2 maxtrans 255 compute statistics
            storage ( initial 65536 next 1048576 minextents 1 maxextents 2147483645 pctincrease 0 freelists 1 freelist groups
            1 buffer_pool default flash_cache default cell_flash_cache default )
        tablespace "APPL_DATA"
    enable,
    constraint "DG_MID_EVALUATION_UK" unique ( "EMPNO" )
        using index pctfree 10 initrans 2 maxtrans 255 compute statistics
            storage ( initial 65536 next 1048576 minextents 1 maxextents 2147483645 pctincrease 0 freelists 1 freelist groups
            1 buffer_pool default flash_cache default cell_flash_cache default )
        tablespace "APPL_DATA"
    enable
)
segment creation immediate
pctfree 10 pctused 40 initrans 1 maxtrans 255 nocompress logging
    storage ( initial 65536 next 1048576 minextents 1 maxextents 2147483645 pctincrease 0 freelists 1 freelist groups 1 buffer_pool
    default flash_cache default cell_flash_cache default )
tablespace "APPL_DATA";