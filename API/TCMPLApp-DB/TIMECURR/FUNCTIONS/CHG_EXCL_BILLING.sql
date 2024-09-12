--------------------------------------------------------
--  DDL for Function CHG_EXCL_BILLING
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."CHG_EXCL_BILLING" 
(
 param_projno in varchar2,
 param_excl_billing in varchar2,
 param_empno in varchar2
) return number as 
    V_RETURN NUMBER(5);
    v_projno varchar2(5);
    v_excl_billing number(1);
begin
-- Returns 1 when successful
-- Returns - 1 when Closing date is null so no reopening
-- Returns -2 when Job not available in system

  
    select projno, nvl(excl_billing,0) into v_projno  ,v_excl_billing from jobmaster where projno = param_projno ;
     -- If v_projno = param_projno Then
          if v_projno is null    then
             v_return := -1;
             return V_RETURN;
          else
            --insert into jobmaster_history (projno,v_cdate,sysdate,'Job Reopened by system')
             if param_excl_billing <> v_excl_billing then
                update jobmaster set excl_billing = param_excl_billing   where  projno = param_projno ;
                update projmast set excl_billing = param_excl_billing where  proj_no =  param_projno;
                --insert into job_chg_history (projno,chg_date,empno,chgtyp) values (ltrim(rtrim(param_projno))||ltrim(rtrim(param_phase)),sysdate,param_empno,'TM');
                insert into job_chg_history (projno,chg_date,empno,chgtyp,remarks) values (param_projno,sysdate,param_empno,'03','EXCLude Billing Changed to '||param_excl_billing|| ' from ' ||v_excl_billing  );
                commit;
                v_return := 1;
                return V_RETURN;
             else
                 V_return := 2;
                 return V_RETURN; --Nothing to update
             end if;
          end if;
    --  else
     --    return -2;
    --  End if;
     return V_RETURN;
end Chg_EXCL_BILLING;

/
