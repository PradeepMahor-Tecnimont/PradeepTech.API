using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.DeskBooking;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DeskBooking;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.DataAccess.Repositories.Timesheet.Exec.Implementation
{
    public class EmployeeTimesheetDetailsRepository : ExecTcmPLRepository<ParameterSpTcmPL, TimesheetDetails>, IEmployeeTimesheetDetailsRepository
    {
        public EmployeeTimesheetDetailsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<TimesheetDetails> TimesheetDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_timesheet_qry.sp_get_timesheet";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
