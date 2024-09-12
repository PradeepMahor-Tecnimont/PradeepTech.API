Drop Table holidays_region;
Drop Table region_master;


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
);

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
    Enable,
    Constraint "HOLIDAYS_REGION_FK1" Foreign Key ( "REGION_CODE" )
        References "TCMPL_HR"."REGION_MASTER" ( "REGION_CODE" )
    Enable
);



Insert Into "TCMPL_HR"."REGION_MASTER" (
    region_code,
    region_name,
    modified_by
) Values (
    01,
    'Common',
    '04170'
);
Insert Into "TCMPL_HR"."REGION_MASTER" (
    region_code,
    region_name,
    modified_by
) Values (
    02,
    'Mumbai',
    '04170'
);
Insert Into "TCMPL_HR"."REGION_MASTER" (
    region_code,
    region_name,
    modified_by
) Values (
    03,
    'Gurugram',
    '04170'
);

Commit;

Alter Table mis_mast_office_location Add (
    region_code Number(2)
);

Alter Table mis_mast_office_location
    Add Constraint mis_mast_office_location_fk1 Foreign Key ( region_code )
        References region_master ( region_code )
    Enable;

Commit;


Update mis_mast_office_location b
   Set
    b.region_code = (
        Select
            Case
                When ( b.office_location_desc = 'Malad'
                    Or b.office_location_desc = 'Airoli' ) Then
                    2
                When ( b.office_location_desc = 'Gurugram' ) Then
                    3
                Else
                    1
            End As region_code
          From
            mis_mast_office_location a
         Where
            a.office_location_code = b.office_location_code
    );

Commit;

Insert Into holidays_region (
    holiday,
    region_code,
    yyyymm,
    weekday,
    description
)
    Select
        trunc(holiday) As holiday,
        1              As region_code,
        yyyymm,
        weekday,
        nvl(
            description,
            '-'
        )              As description
      From
        timecurr.holidays;