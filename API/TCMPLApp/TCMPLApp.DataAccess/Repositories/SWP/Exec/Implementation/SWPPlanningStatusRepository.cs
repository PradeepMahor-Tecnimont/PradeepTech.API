﻿using Microsoft.Extensions.Logging;
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
    public class SWPPlanningStatusRepository : ExecTcmPLRepository<ParameterSpTcmPL, WeekPlanningStatusOutPut>, ISWPPlanningStatusRepository
    {
        public SWPPlanningStatusRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<WeekPlanningStatusOutPut> GetPlanningWeekDetails(
        BaseSpTcmPL baseSpTcmPL,
        ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_common.get_planning_week_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        //public async Task<WeekPlanningStatusOutPut> GetPrimaryWorkspaceSummary(
        //BaseSpTcmPL baseSpTcmPL,
        //ParameterSpTcmPL parameterSpTcmPL)
        //{
        //    CommandText = "selfservice.iot_swp_common.get_planning_week_details";

        //    var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

        //    return response;
        //}

        //public async Task<WeekPlanningStatusOutPut> GetPrimaryWorkspacePlanningSummary(
        //BaseSpTcmPL baseSpTcmPL,
        //ParameterSpTcmPL parameterSpTcmPL)
        //{
        //    CommandText = "selfservice.iot_swp_common.get_planning_week_details";

        //    var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

        //    return response;
        //}




    }
}