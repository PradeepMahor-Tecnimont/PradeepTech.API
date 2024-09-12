--------------------------------------------------------
  --  DDL for Table SEC_MODULES
  --------------------------------------------------------

  Create Table tcmpl_app_config.sec_modules
   (module_id Char(3),
    module_name Varchar2(20),
    module_long_desc Varchar2(200),
    module_is_active Varchar2(2),
    module_schema_name Varchar2(30),
    func_to_check_user_access Varchar2(30),
    module_short_desc Varchar2(20)
   );