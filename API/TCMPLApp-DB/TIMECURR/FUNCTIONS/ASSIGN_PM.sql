--------------------------------------------------------
--  DDL for Function ASSIGN_PM
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."ASSIGN_PM" (
 param_empno in varchar2,
 param_hod in varchar2
) return number as 
    v_empno varchar2(5);
    v_parent varchar2(5);
    v_hod varchar2(5);
    v_costhod varchar2(5);
    v_status number(1);
    v_projmngr number(1);
    v_hodstatus number(1);
    v_hodparent varchar2(4);
    --v_dol date;
    --v_cdate date;
    --v_abbr varchar2(5);
    --v_pm_empno varchar2(5);
    --v_sponsor varchar2(5);
   -- mreturn number(1);
begin
    begin
    select empno,status,parent,nvl(projmngr,0) into v_empno ,v_status,v_parent,v_projmngr from emplmast where empno = param_empno and status = 1 and emptype in ('R','C','F');
    exception
    when no_data_found then
        --mreturn := -1;
        return -1;
    end;
    begin
    select empno,status,parent into v_hod ,v_hodstatus,v_hodparent from emplmast where empno = param_hod and status = 1 and emptype in ('R','C','F');
    exception
    when no_data_found then
        --mreturn := -2;
        return -2;
    end;
    
    BEGIN
    select hod into v_costhod from costmast where costcode = v_parent;
    exception
    when no_data_found then
        --mreturn := -3;
        return -3;
    end;
      if v_costhod  =  param_hod  then
         if v_projmngr = 0 then
            update emplmast set projmngr  = 1  where  empno = param_empno and nvl(projmngr,0) = 0;
            --insert into job_chg_history ( projno, pm_old ,pm_new ,sponsor_old ,sponsor_new,chg_date ,empno,CHGTYP) values (param_projno,v_pm_empno,param_empno,v_sponsor,v_sponsor,sysdate,param_user,'PM');
            insert into empl_chg_history (empno,modified_by,projmngr,modified_on,remarks) values (param_empno,param_hod,1,sysdate,'Assigned PM profile');
            commit;
            return 1;
         else
            return -5; -- 'Employee is already project manager
         end if;
      else
      --HOD does not match with user.
        return -4;
      end if;
end Assign_PM;

/
