using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class DeemedEmpLoaAcceptanceRepository : ExecTcmPLRepository<ParameterSpTcmPL, DeemedEmpLoaAcceptance>, IDeemedEmpLoaAcceptanceRepository
    {
        public DeemedEmpLoaAcceptanceRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DeemedEmpLoaAcceptance> GetDeemedEmpLoaAcceptanceAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_loa_addendum_acceptance.sp_deemed_emp_loa_acceptance";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}