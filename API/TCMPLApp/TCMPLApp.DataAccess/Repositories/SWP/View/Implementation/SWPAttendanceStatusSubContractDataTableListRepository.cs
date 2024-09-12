using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;


namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class SWPAttendanceStatusSubContractDataTableListRepository : ViewTcmPLRepository<AttendanceStatusSubContractDataTableList>, ISWPAttendanceStatusSubContractDataTableListRepository
    {
        public SWPAttendanceStatusSubContractDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }


        public async Task<IEnumerable<AttendanceStatusSubContractDataTableList>> SWPAttendanceSubContractDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_ss_xl_reports_qry.fn_subcont_attend_for_10days";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
