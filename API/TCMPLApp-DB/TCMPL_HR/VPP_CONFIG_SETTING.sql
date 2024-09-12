-- Start create vpp_config table


Create Table vpp_config (
    key_id               Varchar2(8 Byte)
        Not Null Enable,
    start_date           Date,
    end_date             Date,
    is_display_premium   Number
        Not Null Enable,
    is_draft             Number
        Not Null Enable,
    emp_joining_date     Date,
    is_initiate_config   Number
        Not Null Enable,
    created_by           Varchar2(5 Byte)
        Not Null Enable,
    created_on           Date Default sysdate
        Not Null Enable,
    modified_by          Varchar2(5 Byte),
    modified_on          Date Default sysdate,
    is_applicable_to_all Number,
    Constraint vpp_config_pk Primary Key ( key_id ),
    Constraint vpp_config_uk1 Unique ( start_date )
);

Comment On Column "VPP_CONFIG"."IS_DISPLAY_PREMIUM" Is
    '1 - Yes , No - 0';
Comment On Column "VPP_CONFIG"."IS_DRAFT" Is
    '1 - Yes , No - 0';
Comment On Column "VPP_CONFIG"."IS_APPLICABLE_TO_ALL" Is
    '1 - Yes , No - 0';


Insert Into "TCMPL_HR"."VPP_CONFIG" (
    key_id,
    start_date,
    end_date,
    is_display_premium,
    is_draft,
    is_initiate_config,
    created_by,
    created_on,
    modified_on,
    is_applicable_to_all
) Values (
    'KOKRAD8R',
    To_Date('2023-04-01 14:47:18', 'YYYY-MM-DD HH24:MI:SS'),
    To_Date('2023-11-01 14:47:52', 'YYYY-MM-DD HH24:MI:SS'),
    1,
    0,
    0,
    '04170',
    sysdate,
    sysdate,
    1
);


Commit;

-- End create vpp_config table

-- Start Alter vpp_premium_master table

Alter Table vpp_premium_master Add (
    key_id Varchar2(10)
);


Alter Table vpp_premium_master Add (
    config_key_id Varchar2(8)
);

Alter Table vpp_premium_master Add (
    modified_on Date
);


Commit;

Update vpp_premium_master
   Set
    key_id = dbms_random.string(
        'X',
        10
    ),
    config_key_id = 'KOKRAD8R',
    modified_on = sysdate;


Commit;

Alter Table vpp_premium_master Add Constraint vpp_premium_master_pk Primary Key ( key_id ) Enable;

Commit;

Alter Table vpp_premium_master Modify (
    key_id Not Null
);

Commit;

-- End Alter vpp_premium_master table


-- ALTER VPP_VOLUNTARY_PARENT_POLICY

Alter Table vpp_voluntary_parent_policy Modify (
    config_key_id Varchar2(10 Byte)
);

Update vpp_voluntary_parent_policy
   Set
    config_key_id = 'KOKRAD8R';

Commit;


Alter Table vpp_voluntary_parent_policy Modify (
    config_key_id Not Null
);

Alter Table vpp_voluntary_parent_policy
    Add Constraint vpp_fk_config Foreign Key ( config_key_id )
        References vpp_config ( key_id )
    Enable;

-- End Alter vpp_premium_master table

--Alter vpp Main tables
Alter Table vpp_voluntary_parent_policy
Add (old_insured_sum_id Varchar2(3));

Alter Table
vpp_voluntary_parent_policy_d
Add (is_delete_allowed Number Default 0);
--End 