using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Attendance;

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public interface IAttendanceOnDutyApprovalRepository
    {
        public Task<AttendanceOnDutyApprovalOutput> LeadOnDutyApprovalAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<AttendanceOnDutyApprovalOutput> HoDOnDutyApprovalAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<AttendanceOnDutyApprovalOutput> HROnDutyApprovalAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}