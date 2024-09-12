using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Attendance;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class SWPEmployeeWorkspaceRepository : ExecTcmPLRepository<ParameterSpTcmPL, EmployeeOfficeWorkspaceOutput>, ISWPEmployeeWorkspaceRepository
    {
        public SWPEmployeeWorkspaceRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<EmployeeOfficeWorkspaceOutput> GetEmployeePrimaryWorkspace(
        BaseSpTcmPL baseSpTcmPL,
        ParameterSpTcmPL parameterSpTcmPL)
        {
            //CommandText = "selfservice.iot_swp_common.sp_primary_workspace";
            CommandText = "selfservice.iot_swp_common.sp_get_emp_workspace_details";
            
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}