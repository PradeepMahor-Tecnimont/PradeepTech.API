--------------------------------------------------------
--  DDL for Function CHG_TMAGRP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."CHG_TMAGRP" 
(
 param_projno in varchar2,
 param_phase in varchar2,
 param_tmagrp in varchar2,
 param_empno in varchar2
) return number as 
    V_RETURN NUMBER(5);
    v_projno varchar2(5);
    v_phase varchar2(2);
    v_tmagrp varchar2(4);
    VCOUNT NUMBER(3);
begin
-- Returns 1 when successful
-- Returns - 1 when Closing date is null so no reopening
-- Returns -2 when Job not available in system

  
    select projno, phase_select,tmagrp into v_projno ,v_phase ,v_tmagrp from job_proj_phase where projno = param_projno and phase_select = param_phase;
     -- If v_projno = param_projno Then
          if v_projno is null   OR  v_phase is null  then
             v_return := -1;
             return V_RETURN;
          else
            --insert into jobmaster_history (projno,v_cdate,sysdate,'Job Reopened by system')
             IF v_tmagrp <> param_tmagrp then
                SELECT COUNT(*) INTO VCOUNT FROM JOB_TMAGROUP WHERE TMAGROUP = PARAM_TMAGRP;
                IF VCOUNT > 0 THEN
                   update job_proj_phase set tmagrp = param_tmagrp   where  projno = param_projno and phase_select = param_phase;
                   update projmast set newcostcode = param_tmagrp where  projno =  param_projno||param_phase;
                --insert into job_chg_history (projno,chg_date,empno,chgtyp) values (ltrim(rtrim(param_projno))||ltrim(rtrim(param_phase)),sysdate,param_empno,'TM');
                   insert into job_chg_history (projno,chg_date,empno,chgtyp,remarks) values (ltrim(rtrim(param_projno)),sysdate,param_empno,'TM','TMA Grp Changed for Phase '||v_phase|| ' from ' ||v_tmagrp || ' TO ' || param_tmagrp );
                   commit;
                    v_return := 1;
                   return V_RETURN;
                ELSE
                   V_RETURN := -3 ; 
                   return V_RETURN; --TMAGROP NOT FOUND IN TABLE
                END IF;
             else
                v_return := -2;
                return V_RETURN;
             end if;
          end if;
    --  else
     --    return -2;
    --  End if;
     return V_RETURN;
end Chg_TMAGrp;

/
