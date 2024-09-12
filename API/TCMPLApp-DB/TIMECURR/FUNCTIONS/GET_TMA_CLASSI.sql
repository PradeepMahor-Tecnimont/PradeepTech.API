--------------------------------------------------------
--  DDL for Function GET_TMA_CLASSI
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_TMA_CLASSI" (p_costcode job_CLASSI.JOB_CLASS %type) return varchar2 is
   p_cc JOB_CLASSI.JOB_CLASSDESC %type;
begin
   select JOB_CLASSDESC into p_cc from JOB_classi where JOB_CLASS = p_costcode ;
   return p_cc;
exception   
   when no_data_found then
        p_cc := 'NOT Found';
        return p_cc;
end;

/
