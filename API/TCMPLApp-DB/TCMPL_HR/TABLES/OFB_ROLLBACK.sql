create table "TCMPL_HR"."OFB_ROLLBACK" (
    "EMPNO"        char(5)
        not null enable,
    "STATUS"       number default 0,
    "REMARKS"      varchar2(250),
    "REQUESTED_BY" char(5),
    "REQUESTED_ON" date,
    "APPROVED_BY"  char(5),
    "APPROVED_ON"  date
);