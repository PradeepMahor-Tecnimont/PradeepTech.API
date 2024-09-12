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
    public class AttendanceExtraHoursDataTableListRepository : ViewTcmPLRepository<ExtraHoursClaimsDataTableList>, IAttendanceExtraHoursDataTableListRepository
    {
        public AttendanceExtraHoursDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }

        public async Task<IEnumerable<ExtraHoursClaimsDataTableList>> AttendanceExtraHoursClaimsDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            if (string.IsNullOrEmpty(parameterSpTcmPL.PEmpno))
                CommandText = "selfservice.iot_extrahours_qry.fn_extra_hrs_claims_4_self";
            else
                CommandText = "selfservice.iot_extrahours_qry.fn_extra_hrs_claims_4_other";


            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

    }
}
