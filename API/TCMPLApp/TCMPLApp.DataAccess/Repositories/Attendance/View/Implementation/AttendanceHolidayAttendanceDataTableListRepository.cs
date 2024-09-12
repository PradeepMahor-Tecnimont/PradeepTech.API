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
    public class AttendanceHolidayAttendanceDataTableListRepository : ViewTcmPLRepository<HolidayAttendanceDataTableList>, IAttendanceHolidayAttendanceDataTableListRepository
    {
        public AttendanceHolidayAttendanceDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<HolidayAttendanceDataTableList>> AttendanceHolidayAttendanceDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_holiday_qry.fn_holiday_attendance";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}