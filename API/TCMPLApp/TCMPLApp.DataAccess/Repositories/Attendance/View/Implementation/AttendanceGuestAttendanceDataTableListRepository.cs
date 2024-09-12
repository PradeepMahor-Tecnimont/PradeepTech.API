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
    public class AttendanceGuestAttendanceDataTableListRepository : ViewTcmPLRepository<GuestAttendanceDataTableList>, IAttendanceGuestAttendanceDataTableListRepository
    {
        public AttendanceGuestAttendanceDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<GuestAttendanceDataTableList>> AttendanceGuestAttendanceDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_guest_meet_qry.fn_guest_attendance";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<GuestAttendanceDataTableList>> AttendanceGuestAttendanceAdminDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_guest_meet_qry.fn_guest_attendance_admin";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}