﻿using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Attendance;

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public interface ILeaveCalendarHoDExcelDataTableListRepository
    {
        public Task<IEnumerable<LeaveCalendarHodExcelDataTableList>> LeaveCalendarHODExcelDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
