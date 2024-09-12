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
    public class SWPHeaderStatusForPrimaryWorkSpaceRepository : ExecTcmPLRepository<ParameterSpTcmPL, SWPHeaderStatusForPrimaryWorkSpaceOutput>, ISWPHeaderStatusForPrimaryWorkSpaceRepository
    {
        public SWPHeaderStatusForPrimaryWorkSpaceRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<SWPHeaderStatusForPrimaryWorkSpaceOutput> HeaderStatusForPrimaryWorkSpaceAsync(
        BaseSpTcmPL baseSpTcmPL,
        ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace.sp_workspace_summary";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<SWPHeaderStatusForPrimaryWorkSpaceOutput> HeaderStatusForPrimaryWorkSpacePlanningAsync(
        BaseSpTcmPL baseSpTcmPL,
        ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace.sp_workspace_plan_summary";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

    }
}