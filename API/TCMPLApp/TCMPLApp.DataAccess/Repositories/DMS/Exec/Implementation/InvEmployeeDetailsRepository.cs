using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class InvEmployeeDetailsRepository : ExecTcmPLRepository<ParameterSpTcmPL, InvEmployeeDetails>, IInvEmployeeDetailsRepository
    {
        public InvEmployeeDetailsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<InvEmployeeDetails> EmployeeDetails(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_transactions_qry.sp_employee_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}