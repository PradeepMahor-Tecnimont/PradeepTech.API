using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DigiForm;

namespace TCMPLApp.DataAccess.Repositories.DigiForm
{
    public class AnnualEvaluationGetKeyIdRepository : ExecTcmPLRepository<ParameterSpTcmPL, AnnualEvaluationGetKeyId>, IAnnualEvaluationGetKeyIdRepository
    {
        public AnnualEvaluationGetKeyIdRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<AnnualEvaluationGetKeyId> AnnualEvaluationGetKeyId(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_annu_evaluation_qry.sp_dg_annu_evaluation_get_key_id";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
