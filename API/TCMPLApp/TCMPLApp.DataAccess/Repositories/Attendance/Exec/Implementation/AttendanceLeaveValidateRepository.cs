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
    public class AttendanceLeaveValidateRepository : ExecTcmPLRepository<ParameterSpTcmPL, LeaveValidateLeaveOutput>, IAttendanceLeaveValidateRepository
    {
 
        public AttendanceLeaveValidateRepository(ExecTcmPLContext context,   ILogger<ExecTcmPLContext> logger) : base(context,   logger)
        {
           // _redisContext = redisContext;
        }

        public async Task<LeaveValidateLeaveOutput> ValidateNewLeave(
            BaseSpTcmPL baseSpTcmPL,
            ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_leave.sp_validate_new_leave";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            var tags = new string[] {
                $"USER/{ baseSpTcmPL.UIUserId }"
            };
            // await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;

        }

        public async Task<LeaveValidateLeaveOutput> ValidatePLRevision(
            BaseSpTcmPL baseSpTcmPL,
            ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_leave.sp_validate_pl_revision";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            var tags = new string[] {
                $"USER/{ baseSpTcmPL.UIUserId }"
            };
            // await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;

        }

    }
}
