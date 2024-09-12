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
    public class AttendanceExtraHoursClaimCreateRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IAttendanceExtraHoursClaimCreateRepository
    {
        public AttendanceExtraHoursClaimCreateRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> CreateExtraHoursClaimAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_extrahours.sp_create_claim";

            var response = await ExecBulkAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;

        }

    }
}

