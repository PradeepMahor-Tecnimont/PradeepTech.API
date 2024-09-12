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
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public class JobPmJsRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IJobPmJsRepository
    {       
        public JobPmJsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {

        }

        public async Task<DBProcMessageOutput> UpdatePmJsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs.sp_update_pm_js";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }



    }
}
