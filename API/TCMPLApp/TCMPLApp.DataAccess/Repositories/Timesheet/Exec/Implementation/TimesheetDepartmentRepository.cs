using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public class TimesheetDepartmentRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, ITimesheetDepartmentRepository
    {       
        public TimesheetDepartmentRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<DBProcMessageOutput> DepartmentBulkActionAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_status.sp_timesheet_bulk_action_update";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
