--------------------------------------------------------
--  DDL for Function GET_TMATYPE_DESC
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_TMATYPE_DESC" (p_costcode jobmaster.company %type) return varchar2 is
   p_cc JOB_TMAGROUP.subgroup %type;
begin
   select JOB_CLASS into p_cc from JOB_TMAGROUP where substr(TMAGROUP,1,3) = p_costcode ;
   return p_cc;
exception   
   when no_data_found then
        p_cc := 'NOT Found';
        return p_cc;
end;

/
