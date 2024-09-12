
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;


namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class SWPAttendanceStatusWeekNamesDataTableListRepository : ViewTcmPLRepository<AttendanceStatusWeekNamesDataTableList>, ISWPAttendanceStatusWeekNamesDataTableListRepository
    {
        public SWPAttendanceStatusWeekNamesDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }


        public async Task<IEnumerable<AttendanceStatusWeekNamesDataTableList>> WeekNamesOfMonthDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_attendance_qry.fn_week_number_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
