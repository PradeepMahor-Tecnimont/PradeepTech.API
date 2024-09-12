--------------------------------------------------------
--  DDL for Function REVOKE_JOB_CMD_APPROVAL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."REVOKE_JOB_CMD_APPROVAL" 
(
  P_projno IN VARCHAR2  
) RETURN VARCHAR2 AS 
BEGIN
  if p_projno is not null then
        update jobmaster set APPROVED_DIROP = 0 , appdt_dirop = '', dirop_empno = ''   where projno = p_projno;
   --  insert into job_changes () values (p_projno,:old_APPROVED_DIROP,:old_appdt_dirop ,:old_dirop_empno,sysdate,'Job_CMD_Approval Revoked')
    insert into job_chg_history (projno,chg_date,chgtyp) values (p_projno,sysdate,'CR');
     commit;
  end if; 
  RETURN NULL;
END REVOKE_JOB_CMD_APPROVAL;

/
