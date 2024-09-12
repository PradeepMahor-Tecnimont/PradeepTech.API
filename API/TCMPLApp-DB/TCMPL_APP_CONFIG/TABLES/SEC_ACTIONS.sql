--------------------------------------------------------
  --  DDL for Table SEC_ACTIONS
  --------------------------------------------------------

  Create Table tcmpl_app_config.sec_actions
   (module_id Char(3),
    action_id Char(4),
    action_name Varchar2(20),
    action_desc Varchar2(200),
    action_is_active Varchar2(2),
    module_action_key_id Char(7)
   );