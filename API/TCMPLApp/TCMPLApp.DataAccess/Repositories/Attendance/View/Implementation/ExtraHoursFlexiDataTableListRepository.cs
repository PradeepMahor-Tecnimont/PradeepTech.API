using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Attendance;

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public class ExtraHoursFlexiDataTableListRepository : ViewTcmPLRepository<ExtraHoursFlexiClaimsDataTableList>, IExtraHoursFlexiDataTableListRepository
    {
        public ExtraHoursFlexiDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<ExtraHoursFlexiClaimsDataTableList>> ExtraHoursFlexiClaimsDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            if (string.IsNullOrEmpty(parameterSpTcmPL.PEmpno))
                CommandText = "selfservice.iot_ExtraHours_qry.fn_extra_hrs_claims_4_self";
            else
                CommandText = "selfservice.iot_ExtraHours_qry.fn_extra_hrs_claims_4_other";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}