--------------------------------------------------------
--  DDL for View TOBEDELETED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TOBEDELETED" ("COSTCODEID", "COSTCODE", "TM01ID", "TM01", "TM01GRP", "TMAID", "TMA", "TMAGRP", "ACTIVITY", "GROUP_CHART", "ITALIAN_NAME", "CHANGED_NEMPS", "CMID", "COMPREPORT", "COMPREPORTNAME", "PHASE", "PHASENAME") AS 
  Select 
                        cmcc.CostCodeId, 
                        cmm.CostCode, 
                        cmcc.tm01id,
                        timecurr.hr_pkg_common.get_tm01_grp(cmcc.tm01id) TM01,
                        timecurr.hr_pkg_common.get_tm01_grp_name(cmcc.tm01id) TM01Grp,
                        cmcc.tmaid,
                        timecurr.hr_pkg_common.get_tma_grp(cmcc.tmaid) TMA,
                        timecurr.hr_pkg_common.get_tma_grp_name(cmcc.tmaid) TMAGrp,
                        cmcc.activity,
                        cmcc.group_chart,
                        cmcc.italian_name,
                        cmcc.changed_nemps,
                        cmcc.cmid,
                        timecurr.hr_pkg_common.get_comp_report(cmcc.cmid) CompReport,
                        timecurr.hr_pkg_common.get_comp_report_name(cmcc.cmid) CompReportName,
                        cmcc.phase Phase,
                        timecurr.hr_pkg_common.get_job_phases_name(cmcc.phase) PhaseName
                     From 
                        timecurr.hr_costmast_costcontrol cmcc,
                        timecurr.hr_costmast_main cmm                        
                     Where 
                         cmm.CostCodeId = cmcc.CostCodeId
                        And cmm.Active = 1
                     Order By 
                        cmm.costcode
;
