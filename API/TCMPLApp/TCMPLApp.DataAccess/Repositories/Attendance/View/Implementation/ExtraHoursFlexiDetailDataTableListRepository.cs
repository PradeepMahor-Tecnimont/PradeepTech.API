using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Attendance;

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public class ExtraHoursFlexiDetailDataTableListRepository : ViewTcmPLRepository<ExtraHoursFlexiClaimDetailDataTable>, IExtraHoursFlexiDetailDataTableListRepository
    {
        public ExtraHoursFlexiDetailDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<ExtraHoursFlexiClaimDetailDataTable>> ExtraHoursFlexiClaimDetailDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_ExtraHoursFlexi_qry.fn_extra_hrs_claim_detail";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}