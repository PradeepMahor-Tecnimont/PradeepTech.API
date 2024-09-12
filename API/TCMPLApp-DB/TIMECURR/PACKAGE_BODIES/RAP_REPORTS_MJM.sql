create or replace package body "TIMECURR"."RAP_REPORTS_MJM" as

   function fn_data(
      p_person_id   varchar2,
      p_meta_id     varchar2,

      p_Costcode in varchar2,
      P_Yyyymm   in varchar2

   ) return sys_refcursor as
      c sys_refcursor;
   begin

      open c for
         select *
           from (
                   select b.yymm,
                          b.assign,
                          c.name assign_name,
                          b.assign || ' - ' || c.name assign_detail,
                          b.projno,
                          a.name project_name,
                          b.projno || ' - ' || a.name project_detail,
                          b.EMPNO empno,
                          e.name employee_name,
                          b.EMPNO || ' - ' || e.name employee_detail,
                          b.ACTIVITY,
                          (
                             select distinct trim(act.name)
                               from ACT_MAST act
                              where act.activity = b.ACTIVITY
                                and act.COSTCODE = b.assign
                          ) ACTIVITY_name,
                          (
                             select distinct trim(act.activity) || ' - ' || trim(act.Name)
                               from ACT_MAST act
                              where act.activity = b.ACTIVITY
                                and act.COSTCODE = b.assign
                          ) ACTIVITY_Details,
                          b.WPCODE,
                          nvl(b.nhrs, 0) nhrs,
                          nvl(b.ohrs, 0) ohrs,
                          nvl(b.nhrs, 0) + nvl(b.ohrs, 0) totalhrs
                     from projmast a, jobwise_wp b, costmast c, emplmast e
                    where a.projno = b.projno
                      and b.empno = e.empno
                      and b.assign = c.costcode
                      and b.yymm = P_Yyyymm
                      and b.assign = p_Costcode
                    order by b.yymm asc, b.projno asc

                );
      return c;
   end fn_data;
 
end RAP_REPORTS_MJM;
/

grant execute on "TIMECURR"."RAP_REPORTS_MJM" to "TCMPL_APP_CONFIG";