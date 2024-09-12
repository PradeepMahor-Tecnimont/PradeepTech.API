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
    public class LoPForExcessLeaveDataTableListRepository : ViewTcmPLRepository<LoPForExcessLeaveDataTableList>, ILoPForExcessLeaveDataTableListRepository
    {
        public LoPForExcessLeaveDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<LoPForExcessLeaveDataTableList>> LoPForExcessLeaveDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_ss_absent_excess_leave_lop_qry.fn_absent_excess_leaves";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
