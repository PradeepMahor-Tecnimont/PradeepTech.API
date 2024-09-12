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
    public class AttendanceExtrahoursClaimExistsRepository : ExecTcmPLRepository<ParameterSpTcmPL, ExtraHoursClaimExistsOutput>, IAttendanceExtrahoursClaimExistsRepository
    {

        public AttendanceExtrahoursClaimExistsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context,  logger)
        {
            
        }

        public async Task<ExtraHoursClaimExistsOutput> CheckClaimExistsAsync(
            BaseSpTcmPL baseSpTcmPL,
            ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_extrahours.sp_check_claim_exists";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;

        }


    }
}
