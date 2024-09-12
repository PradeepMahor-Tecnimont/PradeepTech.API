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
    public class AttendanceLeaveLedgerDataTableListRepository : ViewTcmPLRepository<LeaveLedgerDataTableList>, IAttendanceLeaveLedgerDataTableListRepository
    {
        public AttendanceLeaveLedgerDataTableListRepository(ViewTcmPLContext context,ILogger<ViewTcmPLContext> logger) : base(context,  logger)
        {

        }
         
        public async Task<IEnumerable<LeaveLedgerDataTableList>> AttendanceLeaveLedgerDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            if (string.IsNullOrEmpty(parameterSpTcmPL.PEmpno))
                CommandText = "selfservice.iot_leave_qry.fn_leave_ledger_4_self";
            else
                CommandText = "selfservice.iot_leave_qry.fn_leave_ledger_4_other";


            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

    }
}
