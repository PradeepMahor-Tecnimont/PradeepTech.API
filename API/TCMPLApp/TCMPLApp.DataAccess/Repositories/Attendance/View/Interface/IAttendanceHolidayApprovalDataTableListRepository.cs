using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Attendance;

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public interface IAttendanceHolidayApprovalDataTableListRepository
    {
        public Task<IEnumerable<HolidayAttendanceApprovalDataTableList>> AttendanceHolidayLeadApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<HolidayAttendanceApprovalDataTableList>> AttendanceHolidayHoDApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<HolidayAttendanceApprovalDataTableList>> AttendanceHolidayOnBehalfApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<HolidayAttendanceApprovalDataTableList>> AttendanceHolidayHRApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}