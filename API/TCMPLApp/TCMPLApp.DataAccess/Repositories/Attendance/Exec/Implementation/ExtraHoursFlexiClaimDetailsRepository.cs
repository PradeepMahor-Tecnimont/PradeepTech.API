using Microsoft.Extensions.Logging;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Attendance;

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public class ExtraHoursFlexiClaimDetailsRepository : ExecTcmPLRepository<ParameterSpTcmPL, ExtraHoursDetailsOut>, IExtraHoursFlexiClaimDetailsRepository
    {
        public ExtraHoursFlexiClaimDetailsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<ExtraHoursDetailsOut> ExtraHoursDetailsAsync(
            BaseSpTcmPL baseSpTcmPL,
            ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_extrahours.sp_extra_hrs_adjst_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;
        }
    }
}