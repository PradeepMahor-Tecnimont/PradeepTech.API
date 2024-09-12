--------------------------------------------------------
--  DDL for Function GET_EMP_HOURS_RQD
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_EMP_HOURS_RQD" 
(
 param_empno in varchar2
,  param_edate in date
) return number as 
    v_count number;
    v_doj date;
    v_dol date;
    v_holidays number;
    v_totdays number;
    v_days number;
    v_office varchar2(2);
begin

  
      select doj,dol ,OFFICE  into v_doj ,v_dol,v_office from emplmast where empno = param_empno;
      if v_doj <= PKG_TM.GETFINYEARSTART then
         v_doj :=  PKG_TM.GETFINYEARSTART;
      end if;
      
      if v_doj > PKG_TM.GETFINYEARend then
         v_doj :=  PKG_TM.GETFINYEARend;
      end if;
      
      
       if v_dol is not null then
          if v_dol <= PKG_TM.GETFINYEARSTART then
             v_dol :=  PKG_TM.GETFINYEARSTART;
          end if;
       ELSE
          v_dol :=  param_edate;
      end if;
      
      if v_dol is not null then
         if v_dol > PKG_TM.GETFINYEAREND then
            v_dol :=  PKG_TM.GETFINYEAREND ;
         end if;
      ELSE
         v_dol :=  param_edate;
      end if;
      
      
      
      
      select count(*) into v_holidays from holidays where holiday >= v_doj and holiday <= v_dol;
      
        select (param_edate - v_doj + 1) into v_totdays from dual;
        v_days := v_totdays-v_holidays;
        if v_office = 'BO' then
           v_count := v_days * 8 ;
        else
           v_count := v_days * 10 ;
        end if;
        
   --   select (param_edate - param_bdate + 1) into v_totdays from dual;
      
 --     select sum(nvl(hours,0)) into v_count from timetran where empno = param_empno
  --    and yymm >= param_byymm
   --     and  yymm <= param_eyymm ;
 
 
      --If v_count > 0 Then
       --   return -1;
     -- else
      --    return 1;
     -- End if;
     return v_count;
end get_emp_hours_rqd;

/
