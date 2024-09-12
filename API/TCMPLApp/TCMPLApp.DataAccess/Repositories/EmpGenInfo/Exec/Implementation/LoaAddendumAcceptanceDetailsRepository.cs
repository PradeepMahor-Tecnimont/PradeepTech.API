using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using Microsoft.Extensions.Logging;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class LoaAddendumAcceptanceDetailsRepository : ExecTcmPLRepository<ParameterSpTcmPL, LoaAddendumAcceptanceDetailOut>, ILoaAddendumAcceptanceDetailsRepository
    {
        public LoaAddendumAcceptanceDetailsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<LoaAddendumAcceptanceDetailOut> LoaAddendumAcceptanceDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_loa_addendum_acceptance_qry.sp_emp_loa_addendum_acceptance_widget";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
