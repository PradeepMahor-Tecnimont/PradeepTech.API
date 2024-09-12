Create Table tcmpl_hr.vpp_backup
(
  vpp_config Varchar2(8) Not Null,
  parent_key_id Varchar2(8) Not Null,
  application_id Varchar2(8) Not Null,
  empno Varchar2(5) Not Null,
  parents_name Varchar2(100) Not Null,
  relation_id Varchar2(3) Not Null,
  relation Varchar2(50) Not Null,
  dob Date Not Null,
  gender Varchar2(20) Not Null,
  insured_sum_id Varchar2(3) Not Null,
  insured_sum_words Varchar2(20) Not Null,
  modified_on Date Not Null,
  backup_on Date Default sysdate Not Null,
  Constraint vpp_backup_pk Primary Key
  (
    parent_key_id
  )
  Enable
);
	 
/*

Insert Into vpp_backup (vpp_config, parent_key_id, application_id, empno, parents_name, relation_id, relation, dob, gender, insured_sum_id,
    insured_sum_words, modified_on, backup_on)
(
    
Select
        vpp.config_key_id as vpp_config,
        vppd.key_id             As parent_key_id,
        vpp.key_id              As application_id,
        vpp.empno,
        vppd.name               As parents_name,
        rm.relation_id,
        rm.relation,
        vppd.dob                dob,
        vppd.gender,
        vpp.insured_sum_id,
        ism.insured_sum_words,
        trunc(vppd.modified_on) modified_on,
        sysdate
    From
        vpp_voluntary_parent_policy   vpp,
        vpp_voluntary_parent_policy_d vppd,
        vpp_insured_sum_master        ism,
        vpp_relation_master           rm,
        vpp_grade_group_master        ggm,
        vpp_vu_emplmast               ve
    Where
        vpp.key_id             = vppd.f_key_id
        And vpp.is_lock        = 1
        And vpp.insured_sum_id = ism.insured_sum_id
        And vppd.relation_id   = rm.relation_id
        And vpp.empno          = ve.empno
        And ve.status          = 1
        And ve.emptype In ('R', 'F')
        And ism.is_active      = 1
        And rm.is_active       = 1
        And ggm.grade_grp      = substr(ve.grade, 1, 1)
        and vppd.key_id not in (Select parent_key_id from vpp_backup)        
      );
*/