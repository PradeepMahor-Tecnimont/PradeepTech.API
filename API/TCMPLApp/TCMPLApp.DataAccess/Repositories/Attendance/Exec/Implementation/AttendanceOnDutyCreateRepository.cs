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

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public class AttendanceOnDutyCreateRepository : ExecTcmPLRepository<ParameterSpTcmPL, LeaveCreateOnDutyOutput>, IAttendanceOnDutyCreateRepository
    {
        public AttendanceOnDutyCreateRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<LeaveCreateOnDutyOutput> CreateOnDutyPunchEntryAsync(
            BaseSpTcmPL baseSpTcmPL,
            ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_onduty.sp_add_punch_entry";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;
        }

        public async Task<LeaveCreateOnDutyOutput> CreateOnDutyDepuTourAsync(
          BaseSpTcmPL baseSpTcmPL,
          ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_onduty.sp_add_depu_tour";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;
        }

        public async Task<LeaveCreateOnDutyOutput> ExtendDeputationAsync(
          BaseSpTcmPL baseSpTcmPL,
          ParameterSpTcmPL parameterSpTcmPL
        )
        {
            CommandText = "selfservice.iot_onduty.sp_extend_depu";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;
        }

        public async Task<LeaveCreateOnDutyOutput> CheckEmpOndutySWAsync(
       BaseSpTcmPL baseSpTcmPL,
       ParameterSpTcmPL parameterSpTcmPL
     )
        {
            CommandText = "selfservice.iot_onduty.sp_check_emp_onduty_swp";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;
        }
    }
}