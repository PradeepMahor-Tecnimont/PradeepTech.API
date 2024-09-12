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
    public class AttendanceHolidayApprovalDataTableListRepository : ViewTcmPLRepository<HolidayAttendanceApprovalDataTableList>, IAttendanceHolidayApprovalDataTableListRepository
    {
        public AttendanceHolidayApprovalDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<HolidayAttendanceApprovalDataTableList>> AttendanceHolidayLeadApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_holiday_qry.fn_pending_lead_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<HolidayAttendanceApprovalDataTableList>> AttendanceHolidayHoDApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_holiday_qry.fn_pending_hod_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<HolidayAttendanceApprovalDataTableList>> AttendanceHolidayOnBehalfApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_holiday_qry.fn_pending_onbehalf_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<HolidayAttendanceApprovalDataTableList>> AttendanceHolidayHRApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_holiday_qry.fn_pending_hr_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}