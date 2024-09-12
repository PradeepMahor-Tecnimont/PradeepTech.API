--------------------------------------------------------
--  DDL for Function CHG_COSTMAST_PO
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."CHG_COSTMAST_PO" 
(
 param_costcode in varchar2,
 param_po in varchar2,
 param_empno in varchar2
) return number as 
    V_RETURN NUMBER(5);
    v_costcode varchar2(4);
    v_po varchar2(10);
begin
-- Returns 1 when successful
-- Returns - 1 when Closing date is null so no reopening
-- Returns -2 when Job not available in system

  
    select costcode, po into v_costcode  ,v_po from costmast where costcode = param_costcode ;
     -- If v_projno = param_projno Then
          if v_costcode is null    then
             v_return := -1;
             return V_RETURN;
          else
            --insert into jobmaster_history (projno,v_cdate,sysdate,'Job Reopened by system')
             if param_po is not null then
                update costmast set po = param_po  where  costcode = param_costcode;
               insert into COSTMAST_HISTORY_PO (costcode,po_chg_from,po_chg_to,chg_date,chg_user) values (param_costcode,v_po,param_po,sysdate,param_empno  );
               commit;
               v_return := 1;
               return V_RETURN;
             else
                v_return := -2;
                return V_RETURN;
             end if;
          end if;
    --  else
     --    return -2;
    --  End if;
     return V_RETURN;
     exception
     when no_data_found then 
     v_return := -3;
     return v_return;
     
end Chg_CostMast_PO;

/
