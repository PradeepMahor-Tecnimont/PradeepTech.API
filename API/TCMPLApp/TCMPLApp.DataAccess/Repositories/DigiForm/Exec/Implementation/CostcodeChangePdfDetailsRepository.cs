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
    public class CostcodeChangePdfDetailsRepository : ExecTcmPLRepository<ParameterSpTcmPL, CostcodeChangePdfDetails>, ICostcodeChangePdfDetailsRepository
    {
        public CostcodeChangePdfDetailsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<CostcodeChangePdfDetails> CostcodeChangePdfDetails(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.sp_Costcode_Change_Pdf_Details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}