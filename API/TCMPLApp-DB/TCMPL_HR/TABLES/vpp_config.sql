Create Table "TCMPL_HR"."VPP_CONFIG" (
    "KEY_ID"               Varchar2(8 Byte)
        Not Null Enable,
    "START_DATE"           Date,
    "END_DATE"             Date,
    "IS_DISPLAY_PREMIUM"   Number
        Not Null Enable,
    "IS_DRAFT"             Number
        Not Null Enable,
    "EMP_JOINING_DATE"     Date,
    "IS_INITIATE_CONFIG"   Number
        Not Null Enable,
    "CREATED_BY"           Varchar2(5 Byte)
        Not Null Enable,
    "CREATED_ON"           Date Default sysdate
        Not Null Enable,
    "MODIFIED_BY"          Varchar2(5 Byte)
        Not Null Enable,
    "MODIFIED_ON"          Date Default sysdate
        Not Null Enable,
    "IS_APPLICABLE_TO_ALL" Number,
    Constraint "VPP_CONFIG_PK" Primary Key ( "KEY_ID" )
        Using Index Pctfree 10 Initrans 2 Maxtrans 255 Compute Statistics
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

Comment On Column "TCMPL_HR"."VPP_CONFIG"."IS_DISPLAY_PREMIUM" Is
    '1 - Yes , No - 0';
Comment On Column "TCMPL_HR"."VPP_CONFIG"."IS_DRAFT" Is
    '1 - Yes , No - 0';
Comment On Column "TCMPL_HR"."VPP_CONFIG"."IS_APPLICABLE_TO_ALL" Is
    '1 - Yes , No - 0';