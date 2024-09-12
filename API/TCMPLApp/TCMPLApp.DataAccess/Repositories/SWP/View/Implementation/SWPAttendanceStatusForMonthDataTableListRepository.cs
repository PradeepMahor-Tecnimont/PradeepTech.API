using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{



    public class SWPAttendanceStatusForMonthDataTableListRepository : ViewTcmPLRepository<AttendanceStatus4MonthDataTableList>, ISWPAttendanceStatusForMonthDataTableListRepository
    {
        public SWPAttendanceStatusForMonthDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<AttendanceStatus4MonthDataTableList>> AttendanceStatusForMonth(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_attendance_qry.fn_attendance_for_month";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }

}
