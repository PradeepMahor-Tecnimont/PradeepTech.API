using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DeskBooking;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public class DeskBookPlanningStatusRepository : ExecTcmPLRepository<ParameterSpTcmPL, DeskBookWeekPlanningStatusOutPut>, IDeskBookPlanningStatusRepository
    {
        public DeskBookPlanningStatusRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DeskBookWeekPlanningStatusOutPut> GetDeskBookPlanningWeekDetails(BaseSpTcmPL baseSpTcmPL,ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.iot_swp_common.get_planning_week_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
