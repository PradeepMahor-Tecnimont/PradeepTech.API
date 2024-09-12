using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public class TimesheetWrkHourCountRepository : ExecTcmPLRepository<ParameterSpTcmPL, TSWrkHourCount>, ITimesheetWrkHourCountRepository
    {
        public TimesheetWrkHourCountRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<TSWrkHourCount> MonthlyWrkHourCountAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_status.sp_timesheet_wrk_hour_count";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;


        }
    }
}