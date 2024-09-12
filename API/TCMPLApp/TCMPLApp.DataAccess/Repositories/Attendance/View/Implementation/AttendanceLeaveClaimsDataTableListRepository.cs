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
    public class AttendanceLeaveClaimsDataTableListRepository : ViewTcmPLRepository<LeaveClaimsDataTableList>, IAttendanceLeaveClaimsDataTableListRepository
    {
        public AttendanceLeaveClaimsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }




        public async Task<IEnumerable<LeaveClaimsDataTableList>> AttendanceLeaveClaimsDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_leave_claims_qry.fn_leave_claims";


            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

    }
}
