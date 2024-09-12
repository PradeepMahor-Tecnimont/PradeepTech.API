Create Table "TCMPL_HR"."HOLIDAYS_REGION" (
    "HOLIDAY"     Date
        Not Null Enable,
    "REGION_CODE" Number(2, 0)
        Not Null Enable,
    "YYYYMM"      Varchar2(6 Byte)
        Not Null Enable,
    "WEEKDAY"     Varchar2(3 Byte)
        Not Null Enable,
    "DESCRIPTION" Varchar2(60 Byte)
        Not Null Enable,
    Constraint "HOLIDAYS_REGION_PK" Primary Key ( "HOLIDAY",
                                                  "REGION_CODE" )
        Using Index Pctfree 10 Initrans 2 Maxtrans 255
            Storage ( Initial 65536 Next 1048576 Minextents 1 Maxextents 2147483645 Pctincrease 0 Freelists 1 Freelist Groups
            1 Buffer_Pool Default Flash_Cache Default Cell_Flash_Cache Default )
        Tablespace "APPL_DATA"
    Enable
)
Segment Creation Immediate
Pctfree 10 Pctused 40 Initrans 1 Maxtrans 255 Nocompress Logging
    Storage ( Initial 65536 Next 1048576 Minextents 1 Maxextents 2147483645 Pctincrease 0 Freelists 1 Freelist Groups 1 Buffer_Pool
    Default Flash_Cache Default Cell_Flash_Cache Default )
Tablespace "APPL_DATA";