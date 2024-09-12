using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public static class RapReportingQueries
    {
        public static string BulkReportList
        {
            get => @"SELECT 
                        keyid || '.zip' filename, 
                        CASE iscomplete
                        WHEN 0 THEN 'Generating...please wait'
                        WHEN 1 THEN 'Complete'
                        ELSE 'Error'
                        END Status,
                        reportid,
                        yyyy,
                        yymm,
                        yearmode,
                        sdate,
                        iscomplete
                    FROM 
                        (SELECT 
                            keyid, 
                            iscomplete,
                            reportid,
                            yyyy,
                            yymm,
                            yearmode,
                            sdate
                        FROM 
                            timecurr.rap_rpt_process 
                        WHERE 
                                reportid = TRIM(:pReport) 
                            AND yyyy = TRIM(:pYyyy) 
                            AND yymm = TRIM(:pYymm)
                            AND yearmode = TRIM(:pYearmode)
                            AND userid = TRIM(:pUser) 
                        ORDER BY 
                            sdate DESC) 
                    WHERE ROWNUM = 1";
        }

        public static string GetTimesheetNotFilledCount
        {
            get => @"select 
                        count(*) cnt 
                    from 
                        timecurr.tsnotfilled 
                    where 
                        yymm = trim(:pYyyy) and desc1 like '%Filled%'";
        }

        public static string GetTimesheetNotPostedCount
        {
            get => @"select 
                        count(*) cnt 
                    from 
                        timecurr.tsnotfilled 
                    where 
                        yymm = trim(:pYyyy) and desc1 like '%Posted%'";
        }

        #region Roles & Actions Query
        public static string RAPUserRolesActions
        {
            get => @" select role_id, action_id from tcmpl_app_config.vu_module_user_role_actions where Empno = :pEmpno  and module_id = :pModuleId";
        }
        #endregion
    }

}
