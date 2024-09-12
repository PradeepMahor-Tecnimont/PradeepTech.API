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
    public class AttendanceLeavesAvailedDataTableListRepository : ViewTcmPLRepository<LeaveAvailedDataTableList>, IAttendanceLeavesAvailedDataTableListRepository
    {
        public AttendanceLeavesAvailedDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }

        public async Task<IEnumerable<LeaveAvailedDataTableList>> LeavesAvailed(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_ss_xl_reports_qry.fn_leaves_availed";


            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

    }
}
