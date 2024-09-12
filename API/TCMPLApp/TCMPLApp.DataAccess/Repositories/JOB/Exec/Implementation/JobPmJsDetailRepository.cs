using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public class JobPmJsDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, JobPmJsDetail>, IJobPmJsDetailRepository
    {       
        public JobPmJsDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<JobPmJsDetail> PmJsDetailAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs.sp_pm_js_detail";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
