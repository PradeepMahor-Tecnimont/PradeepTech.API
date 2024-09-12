using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public class JobmasterDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, JobmasterMainDetailOut>, IJobmasterDetailRepository
    {

        public JobmasterDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }


        #region Job Master Detail   

        public async Task<JobmasterMainDetailOut> JobmasterDetailMain(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_qry.sp_job_main_detail";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }

       
        #endregion Job Master Detail

    }
}
