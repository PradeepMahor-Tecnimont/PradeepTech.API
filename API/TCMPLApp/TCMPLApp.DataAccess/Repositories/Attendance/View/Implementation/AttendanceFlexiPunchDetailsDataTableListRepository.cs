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
    public class AttendanceFlexiPunchDetailsDataTableListRepository : ViewTcmPLRepository<FlexiPunchDetailsDataTableList>, IAttendanceFlexiPunchDetailsDataTableListRepository
    {
        public AttendanceFlexiPunchDetailsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<FlexiPunchDetailsDataTableList>> AttendanceFlexiPunchDetailsDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_flexi_punch_details.fn_punch_details_qry";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

    }
}
