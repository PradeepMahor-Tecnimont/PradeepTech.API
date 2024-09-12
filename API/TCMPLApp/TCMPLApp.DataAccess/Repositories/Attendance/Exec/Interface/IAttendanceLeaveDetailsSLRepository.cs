using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Attendance;


namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public interface IAttendanceLeaveDetailsSLRepository
    {
        public Task<LeaveSLLeaveDetailsOut> LeaveDetailsSLHoDAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<LeaveSLLeaveDetailsOut> LeaveDetailsSLHRAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<LeaveSLLeaveDetailsOut> LeaveDetailsSLLeadAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<LeaveSLLeaveDetailsOut> LeaveDetailsSLOnBehalfAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
