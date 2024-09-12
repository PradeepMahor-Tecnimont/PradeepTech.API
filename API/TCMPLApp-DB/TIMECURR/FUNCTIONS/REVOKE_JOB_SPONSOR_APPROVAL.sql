--------------------------------------------------------
--  DDL for Function REVOKE_JOB_SPONSOR_APPROVAL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."REVOKE_JOB_SPONSOR_APPROVAL" 
(
  p_projno IN VARCHAR2  ,
  p_empno IN VARCHAR2
) RETURN NUMBER AS 
    v_pm_empno varchar2(5);
    v_incharge varchar2(5);
    v_projno varchar2(5);
    v_revision number(2);
BEGIN
  if p_projno is not null then
     begin
     select projno, pm_empno,incharge,revision into v_projno,v_pm_empno,v_incharge,v_revision from jobmaster where projno = p_projno ;
     exception
     when others then
        return -1 ; -- some exception occurred
     end;
     if v_projno = p_projno then
        update jobmaster set approved_vpdir = 0 , appdt_vpdir = '', dirvp_empno = ''   where projno = p_projno;
   --  insert into job_changes () values (p_projno,:old_approved_vpdir,:old_appdt_vpdir,:old_dirvp_empno,sysdate,'Job_Sponsor_Approval Revoked')
        insert into job_chg_history (projno, pm_old, pm_new,sponsor_old,sponsor_new,chg_date,EMPNO,chgtyp,revision,remarks) values   (p_projno,v_pm_empno,v_pm_empno,v_incharge,v_incharge,sysdate,p_empno,'SR',v_revision,'Spn Apprl Cancelled');
        commit;
        RETURN 1;
     else
        return -3 ; -- Project No Incorrect
    end if;
  else
     RETURN -2; --Empty Project #
  end if;   
END REVOKE_JOB_SPONSOR_APPROVAL;

/
