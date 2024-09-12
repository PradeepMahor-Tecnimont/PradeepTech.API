using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.RapReporting;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Attendance;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class RapReportingReportsRepository : Base.ExecRepository, IRapReportingReportsRepository
    {
        public RapReportingReportsRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {

        }

        public async Task<BulkReport> BulkReportDetailAsync(string report, string yyyy, string yymm, string yearmode, string user)
        {
            return await QueryFirstOrDefaultAsync<BulkReport>(RapReportingQueries.BulkReportList, new { pReport = report, pYyyy = yyyy, pYymm = yymm, pYearmode = yearmode, pUser = user });
        }

        public async Task<int?> GetTimesheetNotFilledCount(string yymm)
        {
            return (await QueryAsync<int?>(RapReportingQueries.GetTimesheetNotFilledCount, new { pYyyy = yymm })).FirstOrDefault();
        }

        public async Task<int?> GetTimesheetNotPostedCount(string yymm)
        {
            return (await QueryAsync<int?>(RapReportingQueries.GetTimesheetNotPostedCount, new { pYyyy = yymm })).FirstOrDefault();
        }

    }
}
