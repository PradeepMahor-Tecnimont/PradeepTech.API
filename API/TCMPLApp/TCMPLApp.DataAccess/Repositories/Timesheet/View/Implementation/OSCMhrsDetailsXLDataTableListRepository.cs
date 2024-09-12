using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public class OSCMhrsDetailsXLDataTableListRepository : ViewTcmPLRepository<OSCMhrsDetailsXLDataTableList>, IOSCMhrsDetailsXLDataTableListRepository
    {
        public OSCMhrsDetailsXLDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        
        }
        public async Task<IEnumerable<OSCMhrsDetailsXLDataTableList>> OSCMhrsDetailsXLDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_osc_mhrs_qry.fn_osc_mhrs_detail_list_4_xl";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
