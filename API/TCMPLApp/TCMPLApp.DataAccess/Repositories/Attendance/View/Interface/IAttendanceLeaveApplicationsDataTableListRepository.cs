using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Attendance;


namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public interface IAttendanceLeaveApplicationsDataTableListRepository
    {
        public Task<IEnumerable<LeaveApplicationsDataTableList>> AttendanceLeaveApplicationsDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
