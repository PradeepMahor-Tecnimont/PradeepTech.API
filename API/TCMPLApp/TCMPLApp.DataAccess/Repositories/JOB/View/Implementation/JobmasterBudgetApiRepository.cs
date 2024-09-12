using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public class JobmasterBudgetApiRepository : ViewTcmPLRepository<JobmasterBudgetApi>, IJobmasterBudgetApiRepository
    {

        public JobmasterBudgetApiRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }

        #region Job Budget

        public async Task<IEnumerable<JobmasterBudgetApi>> JobmasterBudget(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_qry.fn_job_budget_api";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        #endregion Job Budget
    }
}
