using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public class TimesheetProjectDataTableExcelRepository : ViewTcmPLRepository<TSProjectDataTableExcel>, ITimesheetProjectDataTableExcelRepository
    {
        public TimesheetProjectDataTableExcelRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<TSProjectDataTableExcel>> ProjectwiseTimesheetDataTableExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_status_qry.fn_project_hours_excel";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
                
    }
}
