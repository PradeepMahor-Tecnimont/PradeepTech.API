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
    public class AttendanceOnDutyApprovalDataTableListRepository : ViewTcmPLRepository<LeaveOnDutyApprovalDataTableList>, IAttendanceOnDutyApprovalDataTableListRepository
    {
        public AttendanceOnDutyApprovalDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<LeaveOnDutyApprovalDataTableList>> AttendanceOnDutyLeadApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_onduty_qry.fn_pending_lead_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<LeaveOnDutyApprovalDataTableList>> AttendanceOnDutyHoDApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_onduty_qry.fn_pending_hod_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<LeaveOnDutyApprovalDataTableList>> AttendanceOnDutyOnBehalfApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_onduty_qry.fn_pending_onbehalf_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<LeaveOnDutyApprovalDataTableList>> AttendanceOnDutyHRApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_onduty_qry.fn_pending_hr_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<LeaveOnDutyApprovalDataTableList>> AttendanceForgettingCardHRApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_onduty_qry.fn_pending_hr_forget_card";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}