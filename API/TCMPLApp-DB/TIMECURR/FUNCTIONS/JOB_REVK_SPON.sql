--------------------------------------------------------
--  DDL for Function JOB_REVK_SPON
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."JOB_REVK_SPON" 
(
 param_projno in varchar2,
 param_user in varchar2
) return number as 
    v_count number;
    v_projno varchar2(5);
    v_dirvp_empno varchar2(5);
    v_APPROVED_VPDIR number(1);
begin
-- Returns 1 when successful
-- Returns - 1 when Closing date is null so no reopening
-- Returns -2 when Job not available in system

  
    select projno, dirvp_empno,nvl(APPROVED_VPDIR,0) into v_projno ,v_dirvp_empno,v_APPROVED_VPDIR from jobmaster where projno = param_projno;
      If v_projno = param_projno Then
          if v_dirvp_empno is null or  nvl(v_APPROVED_VPDIR,0) = 0 then
             return -1; -- Job Sponsor has not approved , hence cannot revoke
          else
            --insert into jobmaster_history (projno,v_cdate,sysdate,'Job Reopened by system')
             update jobmaster set approved_vpdir = 0 , appdt_vpdir = '', dirvp_empno = ''   where  projno = param_projno;
          --  update projmast set cdate = null, active = 1 where  proj_no =  param_projno;
             insert into job_chg_history (projno,chg_date,empno,chgtyp,remarks) values (param_projno,sysdate,param_user,'RS','Spn Apprl Cancelled');
              --insert into job_chg_history (projno, pm_old, pm_new,sponsor_old,sponsor_new,chg_date,EMPNO,chgtyp,revision,remarks) values   (p_projno,v_pm_empno,v_pm_empno,v_incharge,v_incharge,sysdate,p_empno,'SR',v_revision,'Spn Apprl Cancelled');
             
             commit;
             return 1;
          end if;
      else
         return -2; -- Projno Missing
      End if;
     return v_count;
end Job_RevK_Spon;

/
