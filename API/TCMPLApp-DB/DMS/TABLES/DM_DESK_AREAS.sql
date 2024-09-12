Create Table "DMS"."DM_DESK_AREAS" (
    "AREA_KEY_ID"    Char(3 Byte)
        Not Null Enable,
    "AREA_DESC"      Varchar2(60 Byte)
        Not Null Enable,
    "AREA_CATG_CODE" Char(4 Byte)
        Not Null Enable,
    "AREA_INFO"      Varchar2(20 Byte),
    "DESK_AREA_TYPE" Varchar2(4 Byte),
    "IS_RESTRICTED"  Number Default 0
        Not Null Enable,
    "IS_ACTIVE"      Number Default 1
        Not Null Enable,
    Constraint "DM_DESK_AREAS_UK1" Unique ( "AREA_DESC" )
        Using Index Pctfree 10 Initrans 2 Maxtrans 255 Compute Statistics
            Storage ( Initial 65536 Next 1048576 Minextents 1 Maxextents 2147483645 Pctincrease 0 Freelists 1 Freelist Groups
            1 Buffer_Pool Default Flash_Cache Default Cell_Flash_Cache Default )
        Tablespace "APPL_DATA"
    Enable,
    Constraint "DM_DESK_AREA_MASTER_PK" Primary Key ( "AREA_KEY_ID" )
        Using Index Pctfree 10 Initrans 2 Maxtrans 255 Compute Statistics
            Storage ( Initial 65536 Next 1048576 Minextents 1 Maxextents 2147483645 Pctincrease 0 Freelists 1 Freelist Groups
            1 Buffer_Pool Default Flash_Cache Default Cell_Flash_Cache Default )
        Tablespace "APPL_DATA"
    Enable,
    Constraint "DM_DESK_AREAS_FK1" Foreign Key ( "AREA_CATG_CODE" )
        References "DMS"."DM_DESK_AREA_CATEGORIES" ( "AREA_CATG_CODE" )
    Enable
)
Segment Creation Immediate
Pctfree 10 Pctused 40 Initrans 1 Maxtrans 255 Nocompress Logging
    Storage ( Initial 65536 Next 1048576 Minextents 1 Maxextents 2147483645 Pctincrease 0 Freelists 1 Freelist Groups 1 Buffer_Pool
    Default Flash_Cache Default Cell_Flash_Cache Default )
Tablespace "APPL_DATA";


Grant Select On "DMS"."DM_DESK_AREAS" To "SELFSERVICE";
Grant Select On "DMS"."DM_DESK_AREAS" To "DESK_BOOK";