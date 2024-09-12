using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;


namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class SWPAttendanceStatusDatesDataTableListRepository : ViewTcmPLRepository<AttendanceStatusDatesDataTableList>, ISWPAttendanceStatusDatesDataTableListRepository
    {
        public SWPAttendanceStatusDatesDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }


        public async Task<IEnumerable<AttendanceStatusDatesDataTableList>> SWPAttendanceDateDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_attendance_qry.fn_date_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
