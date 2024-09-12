Create Table sec_role_flag_master (
    key_id      Number Not Null,
    flag        Varchar2(100) Not Null,
    is_active   Varchar2(2 Byte) Default 0 Not Null,
    modified_on Date Default sysdate Not Null,
    modified_by Varchar2(5) Not Null,
    Constraint sec_role_flag_master_pk Primary Key ( key_id ) Enable
);

Insert Into "TCMPL_APP_CONFIG"."SEC_ROLE_FLAG_MASTER" (
    key_id,
    flag,
    is_active,
    modified_by
) Values (
    1,
    'Auto',
    'OK',
    '04170'
);

Insert Into "TCMPL_APP_CONFIG"."SEC_ROLE_FLAG_MASTER" (
    key_id,
    flag,
    is_active,
    modified_by
) Values (
    2,
    'Manual',
    'OK',
    '04170'
);

Insert Into "TCMPL_APP_CONFIG"."SEC_ROLE_FLAG_MASTER" (
    key_id,
    flag,
    is_active,
    modified_by
) Values (
    3,
    'CostCode',
    'OK',
    '04170'
);

Insert Into "TCMPL_APP_CONFIG"."SEC_ROLE_FLAG_MASTER" (
    key_id,
    flag,
    is_active,
    modified_by
) Values (
    4,
    'Project',
    'OK',
    '04170'
);

Insert Into "TCMPL_APP_CONFIG"."SEC_ROLE_FLAG_MASTER" (
    key_id,
    flag,
    is_active,
    modified_by
) Values (
    5,
    'Delegates',
    'OK',
    '04170'
);

-- SEC_ROLES
Alter Table sec_roles Add (
    role_flag Number
);

-- Auto Flag
Update "TCMPL_APP_CONFIG"."SEC_ROLES"
   Set
    role_flag = '1'
 Where
    role_id In ( 'R001', 'R002', 'R004', 'R045',
                 'R101', 'R103' );
-- End

-- Manual Flag
Update "TCMPL_APP_CONFIG"."SEC_ROLES"
   Set
    role_flag = '2'
 Where
    role_id Not In ( 'R001', 'R002', 'R004', 'R045',
                     'R101', 'R103', 'R003', 'R109',
                     'R038', 'R023' );
-- End

-- CostCode Flag
Update "TCMPL_APP_CONFIG"."SEC_ROLES"
   Set
    role_flag = '3'
 Where
    role_id In ( 'R003', 'R109', 'R038', 'R023' );
-- End
-- End SEC_ROLES

-- SEC_MODULES
Alter Table "TCMPL_APP_CONFIG"."SEC_MODULES" Add (
    delegation_is_active Varchar2(2) Default 'KO'
);

Update "TCMPL_APP_CONFIG"."SEC_MODULES"
   Set
    delegation_is_active = 'OK'
 Where
    module_id = 'M09';

Alter Table "TCMPL_APP_CONFIG"."SEC_MODULES" Modify (
    delegation_is_active Not Null
);
--End SEC_MODULES