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
    public class ProjactDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, ProjactDetails>, IProjactDetailRepository
    {
        public ProjactDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<ProjactDetails> ProjactDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_projact_mast.sp_projact_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
