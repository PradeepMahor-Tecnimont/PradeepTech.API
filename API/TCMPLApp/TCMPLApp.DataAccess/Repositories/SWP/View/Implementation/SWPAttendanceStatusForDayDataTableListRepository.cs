using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class SWPAttendanceStatusForDayDataTableListRepository : ViewTcmPLRepository<AttendanceStatusForDayDataTableList>, ISWPAttendanceStatusForDayDataTableListRepository
    {
        public SWPAttendanceStatusForDayDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<AttendanceStatusForDayDataTableList>> SWPAttendanceStatusForDayDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_attendance_qry.fn_attendance_for_day";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<AttendanceStatusForDayDataTableList>> SWPAttendanceStatusForPrevWorkDayDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_attendance_qry.fn_attendance_for_prev_day";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}