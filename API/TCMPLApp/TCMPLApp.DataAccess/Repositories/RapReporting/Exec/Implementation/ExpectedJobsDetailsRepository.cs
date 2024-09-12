using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public class ExpectedJobsDetailsRepository : ExecTcmPLRepository<ParameterSpTcmPL, ExpectedJobsDetailsOut>, IExpectedJobsDetailsRepository
    {
        public ExpectedJobsDetailsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<ExpectedJobsDetailsOut> ExpectedJobsDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_expctjobs_qry.sp_expectedjobs_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;
        }
    }
}