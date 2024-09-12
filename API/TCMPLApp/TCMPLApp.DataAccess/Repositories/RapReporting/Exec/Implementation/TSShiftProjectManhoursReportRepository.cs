using Microsoft.Extensions.Logging;
using System.Data;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.RapReporting.Exec;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public class TSShiftProjectManhoursReportRepository : ExecTcmPLRepository<ParameterSpTcmPL,TSShiftProjectManhoursExcel>, ITSShiftProjectManhoursReportRepository
    {
        public TSShiftProjectManhoursReportRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<TSShiftProjectManhoursExcel> TSShiftProjectManhoursReport(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_mhrs_adj_qry.sp_get_shift_hrs_excel";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
    }
}
