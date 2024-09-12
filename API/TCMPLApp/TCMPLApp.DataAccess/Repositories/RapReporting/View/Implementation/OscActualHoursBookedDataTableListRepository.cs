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
    public class OscActualHoursBookedDataTableListRepository : ViewTcmPLRepository<OscActualHoursBookedDataTableList>, IOscActualHoursBookedDataTableListRepository
    {
        public OscActualHoursBookedDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<OscActualHoursBookedDataTableList>> OscActualHoursBookedDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_rap_osc_actual_hrs_booked_qry.fn_actual_hrs_booked_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<OscActualHoursBookedDataTableList>> OscActualHoursBookedDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_rap_osc_actual_hrs_booked_qry.fn_xl_download_actual_hrs_booked_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}