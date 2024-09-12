--------------------------------------------------------
--  DDL for Function CLOSEJOB
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."CLOSEJOB" 
(
 param_projno in varchar2
) return number as 
    v_count number;
    v_projno varchar2(5);
    v_cdate date;
begin
-- Returns 1 when successful  Closing date = sysdate
-- Returns - 1 when Closing date is not null 
-- Returns -2 when Job not available in system

  
    select projno, actual_closing_date into v_projno ,v_cdate from jobmaster where projno = param_projno;
      If v_projno = param_projno Then
          if v_cdate is not null  then
             update jobmaster set form_mode = 'C'  where  projno = param_projno;
             update projmast set cdate = v_cdate, active = 0 where  proj_no =  param_projno;
             return -1;
          else
             update jobmaster set actual_closing_date = sysdate , form_mode = 'C'  where  projno = param_projno;
             --appdt_dirop , appdt_vpdir , appdt_amfi
             --  APPROVED_DIROP = 0 , appdt_dirop = '', dirop_empno = ''
             -- approved_vpdir = 0 , appdt_vpdir = '', dirvp_empno = '' 
             -- APPROVED_AMFI = 0,APPDT_AMFI = '',amfi_empno = ''
             update projmast set cdate = sysdate, active = 0 where  proj_no =  param_projno;
             return 1;
          end if;
           commit;
      else
         return -2;
      End if;
    
end CloseJob;

/
