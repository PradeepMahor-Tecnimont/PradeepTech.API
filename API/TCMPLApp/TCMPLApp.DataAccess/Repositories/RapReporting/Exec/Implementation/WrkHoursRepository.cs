using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public class WrkHoursRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IWrkHoursRepository
    {
        public WrkHoursRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> CreateWrkHoursAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_wrk_hours.sp_add_wrk_hour";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }

        public async Task<DBProcMessageOutput> UpdateWrkHoursAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_wrk_hours.sp_update_wrk_hour";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
