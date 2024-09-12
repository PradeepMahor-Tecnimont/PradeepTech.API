--------------------------------------------------------
  --  DDL for Table VPP_VOLUNTARY_PARENT_POLICY_BACKUP
  --------------------------------------------------------

  Create Table tcmpl_hr.vpp_voluntary_parent_policy_backup
   (key_id Varchar2(8 Byte),
    empno Varchar2(5 Byte),
    insured_sum_id Varchar2(3 Byte),
    modified_on Date,
    modified_by Varchar2(5 Byte),
    is_lock Number Default 0,
    config_key_id Varchar2(10 Byte),
    old_insured_sum_id Varchar2(3 Byte)
   );
--------------------------------------------------------
--  DDL for Table VPP_VOLUNTARY_PARENT_POLICY_D
--------------------------------------------------------

Create Table tcmpl_hr.vpp_voluntary_parent_policy_d_backup
   (key_id Varchar2(8 Byte),
    name Varchar2(50 Byte),
    relation_id Varchar2(3 Byte),
    dob Date,
    gender Varchar2(11 Byte),
    modified_on Date,
    modified_by Varchar2(5 Byte),
    f_key_id Varchar2(8 Byte),
    is_delete_allowed Number Default 0
   );
   
Insert into vpp_voluntary_parent_policy_backup
value (Select * from vpp_voluntary_parent_policy);

Insert into vpp_voluntary_parent_policy_d_backup
value (Select * from vpp_voluntary_parent_policy_d);
