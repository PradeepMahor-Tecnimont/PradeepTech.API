--------------------------------------------------------
--  DDL for Function REVOKE_AFC_APPROVAL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."REVOKE_AFC_APPROVAL" 
(
  param_projno IN VARCHAR2  
) RETURN NUMBER AS 
v_count integer;
BEGIN
  if param_projno is not null then
      select COUNT(*) into v_COUNT  from jobmaster where projno = param_projno;
      If v_count > 0 Then
         update jobmaster set APPROVED_AMFI = 0,APPDT_AMFI = '',amfi_empno = ''   where projno = param_projno;
    --  insert into job_changes () values (p_projno,:old_approved_vpdir,:old_appdt_vpdir,:old_dirvp_empno,sysdate,'Job_Sponsor_Approval Revoked')
        insert into job_chg_history (projno, chg_date, chgtyp) values (param_projno,sysdate,'AR');
         --return 'Job updated Sucessfully';
         RETURN 1;
           commit;
      else
         --return 'Job Not Available';
         RETURN -1;
      end if; 
  end if;   
 -- RETURN 'Project Not available';
 RETURN -2;
END REVOKE_AFC_APPROVAL;

/
