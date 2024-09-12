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
    public class LeaveCalendarHoDExcelDataTableListRepository : ViewTcmPLRepository<LeaveCalendarHodExcelDataTableList>, ILeaveCalendarHoDExcelDataTableListRepository
    {
        public LeaveCalendarHoDExcelDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }
        public async Task<IEnumerable<LeaveCalendarHodExcelDataTableList>> LeaveCalendarHODExcelDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_leave_calendar_qry.fn_leave_hod_list_for_excel";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
