using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.EmpGenInfo;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DigiForm;
using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.DataAccess.Repositories.DigiForm
{
    public class CostcodeChangeRequestDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, CostcodeChangeRequestDetails>, ICostcodeChangeRequestDetailRepository
    {
        public CostcodeChangeRequestDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<CostcodeChangeRequestDetails> CostcodeChangeRequestDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.sp_dg_mid_transfer_costcode_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
