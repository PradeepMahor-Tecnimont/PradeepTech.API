using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public interface IRapReportingReportsRepository
    {
        Task<BulkReport> BulkReportDetailAsync(string report, string yyyy, string yymm, string yearmode, string user);

        Task<int?> GetTimesheetNotFilledCount(string yymm);

        Task<int?> GetTimesheetNotPostedCount(string yymm);

    }

}
