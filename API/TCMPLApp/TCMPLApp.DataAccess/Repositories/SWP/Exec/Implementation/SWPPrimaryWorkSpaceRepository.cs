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
    public class SWPPrimaryWorkSpaceRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, ISWPPrimaryWorkSpaceRepository
    {
        public SWPPrimaryWorkSpaceRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> HoDAssignPrimaryWorkSpaceAsync(
        BaseSpTcmPL baseSpTcmPL,
        ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace.sp_hod_assign_work_space";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> HRAssignPrimaryWorkSpaceAsync(
        BaseSpTcmPL baseSpTcmPL,
        ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace.sp_hr_assign_work_space";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> AdminAssignPrimaryWorkSpaceAsync(
       BaseSpTcmPL baseSpTcmPL,
       ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace.sp_admin_assign_work_space";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> AdminDeletePrimaryWorkSpaceAsync(
      BaseSpTcmPL baseSpTcmPL,
      ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace.sp_admin_delete_work_space";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> WeeklyAttendanceAddAsync(
        BaseSpTcmPL baseSpTcmPL,
        ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_smart_workspace.sp_add_weekly_attendance";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> WeeklyAttendanceDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_smart_workspace.sp_delete_weekly_attendance";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> OfficeWorkSpaceAsync(
        BaseSpTcmPL baseSpTcmPL,
        ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_office_workspace.sp_add_office_ws_desk";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> AssignPrimaryWorkSpaceEmpAsync(
        BaseSpTcmPL baseSpTcmPL,
        ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace.sp_assign_pws_emp";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}