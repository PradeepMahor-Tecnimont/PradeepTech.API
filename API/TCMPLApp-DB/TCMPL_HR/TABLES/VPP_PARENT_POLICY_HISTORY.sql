Create Table "TCMPL_HR"."VPP_PARENT_POLICY_HISTORY" (
    "KEY_ID"         Varchar2(8 Byte)   Not Null Enable,
    "POLICY_KEY_ID"  Varchar2(8 Byte)   Not Null Enable,
    "EMPNO"          Varchar2(5 Byte)   Not Null Enable,
    "INSURED_SUM_ID" Varchar2(3 Byte)   Not Null Enable,
    "MODIFIED_ON"    Date               Not Null Enable,
    "MODIFIED_BY"    Varchar2(5 Byte)   Not Null Enable,
    "IS_LOCK"        Number Default 0   Not Null Enable,
    "CONFIG_KEY_ID"  Varchar2(8 Byte),
    Constraint VPP_PARENT_POLICY_HISTORY_PK Primary Key ( "KEY_ID" ) 
);
  GRANT UPDATE ON "TCMPL_HR"."VPP_PARENT_POLICY_HISTORY" TO "TCMPL_APP_CONFIG";
  GRANT SELECT ON "TCMPL_HR"."VPP_PARENT_POLICY_HISTORY" TO "TCMPL_APP_CONFIG";
  GRANT INSERT ON "TCMPL_HR"."VPP_PARENT_POLICY_HISTORY" TO "TCMPL_APP_CONFIG";
  GRANT DELETE ON "TCMPL_HR"."VPP_PARENT_POLICY_HISTORY" TO "TCMPL_APP_CONFIG";
  
--If VPP_PARENT_POLICY_HISTORY is null
/*

insert into vpp_parent_policy_history Select
        dbms_random.string('X', 8),
        KEY_ID,
        empno,
        insured_sum_id,
        modified_on,
        modified_by,
        is_lock,
        config_key_id
      From
        vpp_voluntary_parent_policy;
        
*/ 
