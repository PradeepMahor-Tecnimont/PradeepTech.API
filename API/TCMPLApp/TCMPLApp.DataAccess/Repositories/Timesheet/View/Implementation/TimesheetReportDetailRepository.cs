using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Timesheet.View.Interface;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.DataAccess.Repositories.Timesheet.View.Implementation
{
    public class TimesheetReportDetailRepository : ViewTcmPLRepository<ReportDetail>, ITimesheetReportDetailRepository
    {
        public TimesheetReportDetailRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<ReportDetail> ReportDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.ts_report.fn_get_report_detail";
            return await GetAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}