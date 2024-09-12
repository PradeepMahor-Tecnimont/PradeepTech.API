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
    public class AttendanceExtraHoursApprovalDataTableListRepository : ViewTcmPLRepository<ExtraHoursClaimApprovalDataTableList>, IAttendanceExtraHoursApprovalDataTableListRepository
    {
        public AttendanceExtraHoursApprovalDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<ExtraHoursClaimApprovalDataTableList>> AttendanceExtraHoursLeadApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_extrahours_qry.fn_pending_lead_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<ExtraHoursClaimApprovalDataTableList>> AttendanceExtraHoursHoDApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_extrahours_qry.fn_pending_hod_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<ExtraHoursClaimApprovalDataTableList>> AttendanceExtraHoursHoDOnBehalfApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_extrahours_qry.fn_pending_onbehalf_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<ExtraHoursClaimApprovalDataTableList>> AttendanceExtraHoursHRApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_extrahours_qry.fn_pending_hr_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}