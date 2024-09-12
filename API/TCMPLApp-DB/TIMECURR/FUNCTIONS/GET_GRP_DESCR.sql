--------------------------------------------------------
--  DDL for Function GET_GRP_DESCR
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_GRP_DESCR" (p_costcode job_tmagroup.tmagroup%type) return varchar2 is
   p_cc JOB_TMAGROUP.TMAGROUPDESC%type;
begin
   select TMAGROUPDESC into p_cc from JOB_TMAGROUP where TMAGROUP = p_costcode;
   return p_cc;
exception   
   when no_data_found then
        p_cc := 'NOT Found';
        return p_cc;
end;

/
