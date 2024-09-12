using Microsoft.Extensions.Logging;
using System.Data;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public class AttendanceActionsExecuteReport : ViewTcmPLRepository<DataTable>, IAttendanceActionsExecuteReport
    {
        public AttendanceActionsExecuteReport(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DataTable> LeaveReportPenaltyLeave(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.analytical_reports.fn_penalty_leaves";
            return await GetDataTableAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<DataTable> LeaveReportLwpReport(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.analytical_reports.fn_lwp_report";
            return await GetDataTableAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<DataTable> HalfDayLeaveApplicationReport(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.analytical_reports.fn_halfday_leave_application_report";
            return await GetDataTableAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<DataTable> LeaveApplicationsPending(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.analytical_reports.fn_leave_application_pending";
            return await GetDataTableAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<DataTable> LeaveApplicationsApproved(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.analytical_reports.fn_leave_application_approved";
            return await GetDataTableAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<DataTable> LeaveReportExcessPLLapseReport(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.analytical_reports.fn_excess_pl_lapse_report";
            return await GetDataTableAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<DataTable> LeaveReportSickLeaveReport(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.analytical_reports.fn_sick_leave_report";
            return await GetDataTableAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
