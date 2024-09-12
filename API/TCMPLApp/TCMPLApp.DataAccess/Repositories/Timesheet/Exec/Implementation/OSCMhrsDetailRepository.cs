using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Timesheet;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.JOB;
using TCMPLApp.Domain.Models.Timesheet.View;

namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public class OSCMhrsDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, OSCMhrsDetail>, IOSCMhrsDetailRepository
    {       
        public OSCMhrsDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<OSCMhrsDetail> OSCMhrsDetailAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_osc_mhrs_qry.sp_osc_mhrs_detail";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
