using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class FutureEmpComingToOfficeRepository : ExecTcmPLRepository<ParameterSpTcmPL, FutureEmpComingToOfficeOutPut>, IFutureEmpComingToOfficeRepository
    {
        public FutureEmpComingToOfficeRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<FutureEmpComingToOfficeOutPut> FutureEmpComingToOfficeBulkCreateAsync(
        BaseSpTcmPL baseSpTcmPL,
        ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_emp_to_office.sp_assign_temp_desk";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}