--------------------------------------------------------
--  DDL for Function GET_EMP_NAME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_EMP_NAME" (
    paramempno in varchar2
) return varchar2 as
    vretval   varchar2(60);
begin
    if paramempno = 'ALLSS' then
        return 'All Services';
    end if;
    select
        name
    into vretval
    from
        ss_emplmast
    where
        empno = trim(paramempno);

    return vretval;
exception
    when others then
        return '';
end get_emp_name;


/

  GRANT EXECUTE ON "SELFSERVICE"."GET_EMP_NAME" TO "TCMPL_APP_CONFIG";
