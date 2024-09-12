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
    public class AttendanceLeaveApplicationsDataTableListRepository : ViewTcmPLRepository<LeaveApplicationsDataTableList>, IAttendanceLeaveApplicationsDataTableListRepository
    {
        public AttendanceLeaveApplicationsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }




        public async Task<IEnumerable<LeaveApplicationsDataTableList>> AttendanceLeaveApplicationsDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            if (string.IsNullOrEmpty(parameterSpTcmPL.PEmpno))
                CommandText = "selfservice.iot_leave_qry.fn_leave_applications_4_self";
            else
                CommandText = "selfservice.iot_leave_qry.fn_leave_applications_4_other";


            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

    }
}
