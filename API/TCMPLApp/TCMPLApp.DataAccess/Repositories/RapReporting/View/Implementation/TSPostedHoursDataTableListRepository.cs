using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public class TSPostedHoursDataTableListRepository : ViewTcmPLRepository<TSPostedHoursDataTableList>, ITSPostedHoursDataTableListRepository
    {
        public TSPostedHoursDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<TSPostedHoursDataTableList>> TSPostedHoursDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_posted_hours_qry.sp_get_hours";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
