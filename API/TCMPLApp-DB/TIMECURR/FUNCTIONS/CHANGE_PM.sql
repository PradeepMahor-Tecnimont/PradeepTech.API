--------------------------------------------------------
--  DDL for Function CHANGE_PM
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."CHANGE_PM" (
 param_projno in varchar2,
 param_empno in varchar2,
 param_user in varchar2
) return number as 
    v_empno varchar2(5);
    v_projno varchar2(5);
    v_dol date;
    v_cdate date;
    v_abbr varchar2(5);
    v_pm_empno varchar2(5);
    v_sponsor varchar2(5);
begin
-- Returns 1 when successful  Closing date = sysdate
-- Returns - 1 when Closing date is not null 
-- Returns -2 when Job not available in system
    select projno,actual_closing_date,pm_empno,incharge into v_projno ,v_cdate,v_pm_empno, v_sponsor from jobmaster where projno = param_projno;
      if v_pm_empno <>  param_empno then
          If v_projno = param_projno Then
             if v_cdate is  null  then
                select empno,dol ,abbr into v_empno,v_dol,v_abbr from emplmast where empno = param_empno;
                if v_empno = param_empno then
                   if v_dol is null then 
                      update jobmaster set pm_empno = param_empno  where  projno = param_projno;
                      update projmast set prjmngr = param_empno,abbr = v_abbr  where  proj_no =  param_projno;
                      insert into job_chg_history ( projno, pm_old ,pm_new ,sponsor_old ,sponsor_new,chg_date ,empno,CHGTYP) values (param_projno,v_pm_empno,param_empno,v_sponsor,v_sponsor,sysdate,param_user,'PM');
                      commit;
                      return 1;
                   else
                  --msg New Projectmanager left the organisaton
                     return -4;
                  end if;  
                else
               -- MSG EMPNO NOT MATCHING
                  return -1;
                end if;
             else
             --update jobmaster set actual_closing_date = sysdate , form_mode = 'C'  where  projno = param_projno;
             --appdt_dirop , appdt_vpdir , appdt_amfi
             --  APPROVED_DIROP = 0 , appdt_dirop = '', dirop_empno = ''
             -- approved_vpdir = 0 , appdt_vpdir = '', dirvp_empno = '' 
             -- APPROVED_AMFI = 0,APPDT_AMFI = '',amfi_empno = ''
             --update projmast set cdate = sysdate, active = 0 where  proj_no =  param_projno;
             --MSG jOB IS CLOSED 
               return -2;
            end if;
         else
         -- MSG PROJNO NOT MATCHING
           return -3;
         End if;
      else
      --msg pm to change already same.
        return -5;
      end if;
end Change_PM;

/
