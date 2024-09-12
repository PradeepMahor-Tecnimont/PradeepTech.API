Create Table "DMS"."REMOVE_AIROLI_EMP_FRM_DM_USERMASTER" (
    "KEY_ID"      Varchar2(10 Byte)
        Not Null Enable,
    "EMPNO"       Varchar2(5 Byte)
        Not Null Enable,
    "DESKID"      Varchar2(5 Byte)
        Not Null Enable,
    "COSTCODE"    Varchar2(5 Byte)
        Not Null Enable,
    "DEP_FLAG"    Varchar2(2 Byte),
    "MODIFIED_ON" Date Default sysdate
        Not Null Enable,
    "MODIFIED_BY" Varchar2(5 Byte)
        Not Null Enable,
    Constraint "REMOVE_AIROLI_EMP_FRM_DM_USERMASTER_PK" Primary Key ( "KEY_ID" )
        Using Index Pctfree 10 Initrans 2 Maxtrans 255
            Storage ( Initial 65536 Next 1048576 Minextents 1 Maxextents 2147483645 Pctincrease 0 Freelists 1 Freelist Groups 1 Buffer_Pool
            Default Flash_Cache Default Cell_Flash_Cache Default )
        Tablespace "APPL_DATA"
    Enable
)
Segment Creation Immediate
Pctfree 10 Pctused 40 Initrans 1 Maxtrans 255 Nocompress Logging
    Storage ( Initial 65536 Next 1048576 Minextents 1 Maxextents 2147483645 Pctincrease 0 Freelists 1 Freelist Groups 1 Buffer_Pool Default
    Flash_Cache Default Cell_Flash_Cache Default )
Tablespace "APPL_DATA";