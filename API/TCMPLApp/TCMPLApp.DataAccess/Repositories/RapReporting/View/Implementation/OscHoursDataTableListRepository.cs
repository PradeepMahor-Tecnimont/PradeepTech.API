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
    public class OscHoursDataTableListRepository : ViewTcmPLRepository<OscHoursDataTableList>, IOscHoursDataTableListRepository
    {
        public OscHoursDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<OscHoursDataTableList>> OscHoursDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_rap_osc_hours_qry.fn_yyyymm_hours_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}