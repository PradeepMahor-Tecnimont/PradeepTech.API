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
    public class ExpectedJobsDataTableListRepository : ViewTcmPLRepository<ExpectedJobsDataTableList>, IExpectedJobsDataTableListRepository
    {
        public ExpectedJobsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<ExpectedJobsDataTableList>> ExpectedJobsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_expctjobs_qry.fn_expected_Jobs";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}