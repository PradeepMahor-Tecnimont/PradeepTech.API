using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public interface IAttendanceActionsExecuteReport
    {
        public Task<DataTable> LeaveReportPenaltyLeave(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DataTable> LeaveReportLwpReport(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DataTable> HalfDayLeaveApplicationReport(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DataTable> LeaveApplicationsPending(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DataTable> LeaveApplicationsApproved(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DataTable> LeaveReportExcessPLLapseReport(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DataTable> LeaveReportSickLeaveReport(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
