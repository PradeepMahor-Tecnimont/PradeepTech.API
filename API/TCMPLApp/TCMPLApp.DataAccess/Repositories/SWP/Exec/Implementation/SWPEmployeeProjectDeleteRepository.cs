using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class SWPEmployeeProjectDeleteRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, ISWPEmployeeProjectDeleteRepository
    {
        public SWPEmployeeProjectDeleteRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> DeleteEmployeeProjectAsync(
        BaseSpTcmPL baseSpTcmPL,
        ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.IOT_SWP_EMP_PROJ_MAP.sp_delete_emp_proj";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
         
    }
}