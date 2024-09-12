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
    public class AttendanceExtraHoursDetailDataTableListRepository : ViewTcmPLRepository<ExtraHoursClaimDetailDataTable>, IAttendanceExtraHoursDetailDataTableListRepository
    {
        public AttendanceExtraHoursDetailDataTableListRepository(ViewTcmPLContext context,ILogger<ViewTcmPLContext> logger) : base(context,  logger)
        {

        }
         
        public async Task<IEnumerable<ExtraHoursClaimDetailDataTable>> AttendanceExtraHoursClaimDetailDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_extrahours_qry.fn_extra_hrs_claim_detail";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

    }
}
