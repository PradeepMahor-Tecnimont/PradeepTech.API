using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public class TimesheetFreezeStatusRepository : ExecTcmPLRepository<ParameterSpTcmPL, TSFreezeStatus>, ITimesheetFreezeStatusRepository
    {
        public TimesheetFreezeStatusRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<TSFreezeStatus> FreezeStatusAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_status.sp_timesheet_freeze_status";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;


        }
    }
}