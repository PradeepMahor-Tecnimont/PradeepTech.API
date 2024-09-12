--------------------------------------------------------
--  DDL for Function CHG_CONTRACT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."CHG_CONTRACT_TYPE" 
(
 param_projno in varchar2,
 param_contract_type in varchar2,
 param_empno in varchar2
) return number as 
    V_RETURN NUMBER(5);
    v_projno varchar2(5);
    v_contract_type number(1);
begin
-- Returns 1 when successful
-- Returns - 1 when Closing date is null so no reopening
-- Returns -2 when Job not available in system
 
    select projno, CONTRACT_TYPE into v_projno  ,v_contract_type from jobmaster where projno = param_projno ;
     -- If v_projno = param_projno Then
          if v_projno is null    then
             v_return := -1;
             return V_RETURN;
          else
            --insert into jobmaster_history (projno,v_cdate,sysdate,'Job Reopened by system')
             if param_contract_type <> v_contract_type then
                update jobmaster set contract_type = param_contract_type   where  projno = param_projno ;
              -- update projmast set contract_type = param_contract_type where  proj_no =  param_projno;
                --insert into job_chg_history (projno,chg_date,empno,chgtyp) values (ltrim(rtrim(param_projno))||ltrim(rtrim(param_phase)),sysdate,param_empno,'TM');
                insert into job_chg_history (projno,chg_date,empno,chgtyp,remarks) values (param_projno,sysdate,param_empno,'05','Contract Type Changed to '||param_contract_type|| ' from ' ||v_contract_type  );
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
end CHG_CONTRACT_TYPE;

/
