using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.HSE;

namespace TCMPLApp.DataAccess.Repositories.HSE
{
    public class HSEQuizCounterDetailsRepository : ExecTcmPLRepository<ParameterSpTcmPL, HSEQuizCountDetailsOut>, IHSEQuizCounterDetailsRepository
    {
        public HSEQuizCounterDetailsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<HSEQuizCountDetailsOut> HSEQuizCounterDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_hse_quiz_hse_qry.sp_hse_quiz_submit_count";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
