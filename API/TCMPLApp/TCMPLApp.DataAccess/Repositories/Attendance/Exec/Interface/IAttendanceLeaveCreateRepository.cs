using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Attendance;


namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public interface IAttendanceLeaveCreateRepository
    {
        public Task<LeaveCreateLeaveOutput> CreateLeaveAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<LeaveCreateLeaveOutput> ReviseLeavePLAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}
