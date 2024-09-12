Create Table "TCMPL_HR"."REGION_MASTER" (
    "REGION_CODE" Number
        Not Null Enable,
    "REGION_NAME" Varchar2(120 Byte)
        Not Null Enable,
    "MODIFIED_ON" Date Default sysdate
        Not Null Enable,
    "MODIFIED_BY" Varchar2(5 Byte)
        Not Null Enable,
    Constraint "REGION_MASTER_PK" Primary Key ( "REGION_CODE" )
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