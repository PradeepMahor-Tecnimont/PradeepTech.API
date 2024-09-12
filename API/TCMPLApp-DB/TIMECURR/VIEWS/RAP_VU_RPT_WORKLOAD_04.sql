--------------------------------------------------------
--  DDL for View RAP_VU_RPT_WORKLOAD_04
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."RAP_VU_RPT_WORKLOAD_04" ("YYMM", "PROJNO", "COSTCODE", "NAME", "PROJ_TYPE", "HRS") AS 
  select yymm, null projno, costcode, 'a' as Name, null proj_type,
(rap_reports.getWorkingHrs(yymm) * rap_reports_gen.get_empcount(costcode) ) hrs from rap_tab_movemast
union
select yymm, null projno, costcode, 'b' category, null proj_type, (nvl(movetosite,0) * rap_reports.getWorkingHrs(yymm)) + 
(nvl(movetoothers,0) * rap_reports.getWorkingHrs(yymm)) hrs from rap_tab_movemast
union
select yymm, null projno, costcode, 'c' category, null proj_type, (nvl(movetotcm,0) * rap_reports.getWorkingHrs(yymm)) + 
(nvl(int_dept,0) * rap_reports.getWorkingHrs(yymm)) hrs from rap_tab_movemast
union
select yymm, null projno, costcode, 'd' category, null proj_type, (nvl(ext_subcontract,0) * rap_reports.getWorkingHrs(yymm)) + 
(nvl(rap_reports.getCummFutRecruit(costcode, rap_reports_gen.get_yymm_begin(yymm,'A'), yymm),0) * 
rap_reports.getWorkingHrs(yymm)) hrs from rap_tab_movemast
union
select "YYMM","PROJNO","COSTCODE","CATEGORY","PROJ_TYPE","HRS" from
  (select a.yymm, a.projno, a.costcode, 'f' category, null proj_type, sum(nvl(a.hours,0)) as hrs from prjcmast a, projmast b
   where a.projno = b.projno and b.active > 0 					
   group by a.projno, a.costcode, 'f', a.yymm 
   union 
  select p.yymm, p.projno, p.costcode, 'f' category, q.proj_type, sum(nvl(p.hours,0)) as hrs from exptprjc p, exptjobs q
   where p.projno = q.projno and q.activefuture > 0 and q.active <= 0 	
   group by p.projno, p.costcode, 'f', q.proj_type, p.yymm
union
select x.yymm, null projno, x.costcode, 'g' category, null proj_type, sum(nvl(x.hours,0)) as hrs from exptprjc x, exptjobs y
 where x.projno = y.projno and y.active > 0 and y.activefuture <= 0 
 group by x.yymm, x.costcode, 'g', x.yymm)
order by yymm
;
