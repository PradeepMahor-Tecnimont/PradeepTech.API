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
    public class SWPHeaderStatusForSmartWorkspaceRepository : ExecTcmPLRepository<ParameterSpTcmPL, SWPHeaderStatusForSmartWorkspaceOutput>, ISWPHeaderStatusForSmartWorkspaceRepository
    {
        public SWPHeaderStatusForSmartWorkspaceRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<SWPHeaderStatusForSmartWorkspaceOutput> HeaderStatusForSmartWorkSpaceAsync(
        BaseSpTcmPL baseSpTcmPL,
        ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_smart_workspace.sp_smart_ws_weekly_summary";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}