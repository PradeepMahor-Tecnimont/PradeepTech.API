using System;
using Microsoft.Extensions.Logging;
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
    public class LeaveCalendarDataTableListRepository : ViewTcmPLRepository<LeaveCalendarDataTableList>, ILeaveCalendarDataTableListRepository
    {
        public LeaveCalendarDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<LeaveCalendarDataTableList>> LeaveCalendarHRDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_leave_calendar_qry.fn_leave_hr_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<LeaveCalendarDataTableList>> LeaveCalendarHODDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_leave_calendar_qry.fn_leave_hod_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}