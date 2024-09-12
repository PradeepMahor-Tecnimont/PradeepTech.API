--------------------------------------------------------
--  DDL for Function CHG_TCMNO
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."CHG_TCMNO" 
(
 param_projno in varchar2,
 param_tcmno in varchar2,
 param_empno in varchar2
) return number as 
    V_RETURN NUMBER(5);
    v_projno varchar2(5);
    v_tcmno varchar2(6);
begin
-- Returns 1 when successful
-- Returns - 1 when Closing date is null so no reopening
-- Returns -2 when Job not available in system

  
    select projno, tcmno into v_projno  ,v_tcmno from jobmaster where projno = param_projno ;
     -- If v_projno = param_projno Then
          if v_projno is null    then
             v_return := -1; -- projno not found in database
             return V_RETURN;
          else
            --insert into jobmaster_history (projno,v_cdate,sysdate,'Job Reopened by system')
             if param_tcmno is not null then 
                update jobmaster set tcmno = param_tcmno   where  projno = param_projno ;
                update projmast set tcmno = param_tcmno where  proj_no =  param_projno;
                --insert into job_chg_history (projno,chg_date,empno,chgtyp) values (ltrim(rtrim(param_projno))||ltrim(rtrim(param_phase)),sysdate,param_empno,'TM');
                insert into job_chg_history (projno,chg_date,empno,chgtyp,remarks) values (param_projno,sysdate,param_empno,'TC','TCM Number Changed to '||param_tcmno|| ' from ' ||v_tcmno  );
                commit;
                v_return := 1;
                return V_RETURN;  
             else
                return 2; -- paramenter tcmno should not be null ,  but it is null
             end if;   
          end if;
    --  else
     --    return -2;
    --  End if;
     return V_RETURN;
end Chg_TCMNo;

/
