--------------------------------------------------------
--  DDL for Function SEC_TO_CHAR
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."SEC_TO_CHAR" (param_sec number) return varchar2 is
        v_ret_val varchar2(20);
    begin
        v_ret_val := To_Char(trunc(param_sec/3600),'FM00') || ':' || to_char(trunc(mod(param_sec,3600)/60),'FM00') || ':' || to_char(mod(mod(param_sec,3600),60),'FM00');
        return v_ret_val;
END SEC_TO_CHAR;


/
