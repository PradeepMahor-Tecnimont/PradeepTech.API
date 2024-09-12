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

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public class AttendanceExtraHoursApprovalRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IAttendanceExtraHoursApprovalRepository
    {
        public AttendanceExtraHoursApprovalRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> LeadExtraHoursApprovalAsync(
        BaseSpTcmPL baseSpTcmPL,
        ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_ExtraHours.sp_claim_approval_lead";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;
        }

        public async Task<DBProcMessageOutput> HoDExtraHoursApprovalAsync(
         BaseSpTcmPL baseSpTcmPL,
         ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_ExtraHours.sp_claim_approval_hod";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;
        }

        public async Task<DBProcMessageOutput> HRExtraHoursApprovalAsync(
            BaseSpTcmPL baseSpTcmPL,
            ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_ExtraHours.sp_claim_approval_hr";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;
        }
    }
}