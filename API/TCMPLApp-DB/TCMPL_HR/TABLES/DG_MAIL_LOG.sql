Create Table "TCMPL_HR"."DG_MAIL_LOG" (
    "MAIL_TO"              Varchar2(2000 Byte),
    "MAIL_FROM"            Varchar2(2000 Byte),
    "MAIL_BCC"             Varchar2(2000 Byte),
    "MAIL_SUCCESS"         Varchar2(200 Byte),
    "MAIL_SUCCESS_MESSAGE" Varchar2(2000 Byte),
    "MAIL_DATE"            Date,
    "MAIL_CC"              Varchar2(2000 Byte)
)
Segment Creation Immediate
Pctfree 10 Pctused 40 Initrans 1 Maxtrans 255 Nocompress Logging
    Storage ( Initial 65536 Next 1048576 Minextents 1 Maxextents 2147483645 Pctincrease 0 Freelists 1 Freelist Groups 1 Buffer_Pool Default
    Flash_Cache Default Cell_Flash_Cache Default )
Tablespace "APPL_DATA" No Inmemory ( "MAIL_BCC" );

Grant Delete On "TCMPL_HR"."DG_MAIL_LOG" To "TCMPL_APP_CONFIG";

Grant Insert On "TCMPL_HR"."DG_MAIL_LOG" To "TCMPL_APP_CONFIG";

Grant Select On "TCMPL_HR"."DG_MAIL_LOG" To "TCMPL_APP_CONFIG";

Grant Update On "TCMPL_HR"."DG_MAIL_LOG" To "TCMPL_APP_CONFIG";