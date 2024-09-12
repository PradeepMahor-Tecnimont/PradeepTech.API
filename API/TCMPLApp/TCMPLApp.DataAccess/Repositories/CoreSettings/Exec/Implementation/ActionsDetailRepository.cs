using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.DMS;
using TCMPLApp.DataAccess.Repositories.JOB;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.CoreSettings;
using TCMPLApp.Domain.Models.DMS;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.CoreSettings
{
    public class ActionsDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, ActionsDetails>, IActionsDetailRepository
    {
        public ActionsDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<ActionsDetails> ActionDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_job_masters_qry.sp_job_tmagroup_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
