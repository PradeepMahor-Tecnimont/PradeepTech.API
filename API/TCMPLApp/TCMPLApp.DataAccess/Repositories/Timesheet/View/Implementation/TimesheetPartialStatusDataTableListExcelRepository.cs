using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public class TimesheetPartialStatusDataTableListExcelRepository : ViewTcmPLRepository<TSPartialStatusDataTableListExcel>, ITimesheetPartialStatusDataTableListExcelRepository
    {
        public TimesheetPartialStatusDataTableListExcelRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }
        public async Task<IEnumerable<TSPartialStatusDataTableListExcel>> TimesheetPartialFilledDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_status_qry.fn_filled_partial_status_excel";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<TSPartialStatusDataTableListExcel>> TimesheetPartialLockedDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_status_qry.fn_locked_partial_status_excel";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<TSPartialStatusDataTableListExcel>> TimesheetPartialApprovedDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_status_qry.fn_approved_partial_status_excel";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<TSPartialStatusDataTableListExcel>> TimesheetPartialPostedDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_status_qry.fn_posted_partial_status_excel";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<TSPartialStatusDataTableListExcel>> TimesheetProjectDetailPartialDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_status_qry.fn_project_timesheet_status_excel";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
