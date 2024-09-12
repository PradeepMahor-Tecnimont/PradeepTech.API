Create Table dg_site_master (
    key_id        Varchar2(4) Not Null,
    site_name     Varchar2(20),
    site_location Varchar2(50),
    is_active     Number,
    modified_by   Varchar2(5),
    modified_on   Date,
    Constraint dg_site_master_pk Primary Key ( key_id ) Enable
);