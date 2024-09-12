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
    public class AttendanceLeaveApprovalDataTableListRepository : ViewTcmPLRepository<LeaveApprovalDataTableList>, IAttendanceLeaveApprovalDataTableListRepository
    {
        public AttendanceLeaveApprovalDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<LeaveApprovalDataTableList>> AttendanceLeaveLeadApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_Leave_qry.fn_pending_lead_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<LeaveApprovalDataTableList>> AttendanceLeaveHoDApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_Leave_qry.fn_pending_hod_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

         public async Task<IEnumerable<LeaveApprovalDataTableList>> AttendanceLeaveOnBehalfApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_Leave_qry.fn_pending_onBehalf_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<LeaveApprovalDataTableList>> AttendanceLeaveHRApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_Leave_qry.fn_pending_hr_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<LeaveApprovalDataTableList>> AttendanceSLLeaveLeadApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_Leave_qry.fn_sl_pend_lead_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<LeaveApprovalDataTableList>> AttendanceSLLeaveHoDApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_Leave_qry.fn_sl_pend_hod_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<LeaveApprovalDataTableList>> AttendanceSLLeaveOnBehalfApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_Leave_qry.fn_sl_pend_onBehalf_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }


        public async Task<IEnumerable<LeaveApprovalDataTableList>> AttendanceSLLeaveHRApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_Leave_qry.fn_sl_pend_HR_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }


    }
}