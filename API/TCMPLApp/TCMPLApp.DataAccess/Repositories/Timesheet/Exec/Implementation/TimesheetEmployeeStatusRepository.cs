using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public class TimesheetEmployeeStatusRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, ITimesheetEmployeeStatusRepository
    {
        public TimesheetEmployeeStatusRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> TimeSheetStatusUpdateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_status.sp_timesheet_status_update";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;


        }
    }
}