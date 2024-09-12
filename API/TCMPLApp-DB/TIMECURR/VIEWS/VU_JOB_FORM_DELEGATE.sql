--------------------------------------------------------
--  DDL for View VU_JOB_FORM_DELEGATE
--------------------------------------------------------

Create Or Replace Force View "TIMECURR"."VU_JOB_FORM_DELEGATE" As
    Select
        "MODULE_ID", "PRINCIPAL_EMPNO", "ON_BEHALF_EMPNO", "MODIFIED_BY", "MODIFIED_ON"
    From
        tcmpl_app_config.sec_module_delegate
    Where
        module_id = 'M09';