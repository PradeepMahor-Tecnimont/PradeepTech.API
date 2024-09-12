--------------------------------------------------------
--  DDL for Function REOPENJOB
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."REOPENJOB" 
(
 param_projno in varchar2,
 param_user in varchar2
) return number as 
    v_count number;
    v_projno varchar2(5);
    v_cdate date;
    v_revision number(2);
begin
-- Returns 1 when successful
-- Returns - 1 when Closing date is null so no reopening
-- Returns -2 when Job not available in system

  
    begin
    select projno, actual_closing_date,revision into v_projno ,v_cdate,v_revision from jobmaster where projno = param_projno;
    exception
    when no_data_found then
       return -3; -- Project # not found
    end;
      If v_projno = param_projno Then
          if v_cdate is null then
             return -1; -- project is alrteady open - NO closing date
          else
            --insert into jobmaster_history (projno,v_cdate,sysdate,'Job Reopened by system')
             update jobmaster set actual_closing_date = null , form_mode = 'M'  where  projno = param_projno;
             update projmast set cdate = null, active = 1 where  proj_no =  param_projno;
             insert into job_chg_history (projno,chg_date,empno,actual_closing_date,chgtyp,revision,remarks) values (param_projno,sysdate,param_user,v_cdate,'RE',v_revision,'Job Reopened ');
       --      PROJNO
--PM_OLD
--PM_NEW
--SPONSOR_OLD
--SPONSOR_NEW
--CHG_DATE
--EMPNO
--ACTUAL_CLOSING_DATE
--CHGTYP
--REVISION
--REMARKS
             commit;
             return 1; -- successfully reopened
          end if;
      else
         return -2;  -- Project # not found
      End if;
     return v_count;
end ReOpenJob;

/
