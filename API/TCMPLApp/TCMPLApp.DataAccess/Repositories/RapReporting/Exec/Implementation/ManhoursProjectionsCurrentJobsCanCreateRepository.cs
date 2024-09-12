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
    public class ManhoursProjectionsCurrentJobsCanCreateRepository : ExecTcmPLRepository<ParameterSpTcmPL, ManhoursProjectionsCanCreate>, IManhoursProjectionsCurrentJobsCanCreateRepository
        {
        public ManhoursProjectionsCurrentJobsCanCreateRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

            public async Task<ManhoursProjectionsCanCreate> ManhoursProjectionsCurrentJobsCanCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_mhrs_proj.get_creation_status_proc";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
    }
}