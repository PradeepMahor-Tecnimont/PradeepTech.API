using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.JOB;
using TCMPLApp.Domain.Models.JOB.View;

namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public class JobApproverStatusDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, JobApproverStatus>, IJobApproverStatusDetailRepository
    {       
        public JobApproverStatusDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<JobApproverStatus> ApproverStatusDetailAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs.sp_approver_status_detail";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
