using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public class ManhoursProjectionsCurrentJobsImportRepository : ExecTcmPLRepository<ParameterSpTcmPL, ManhoursProjectionsOutput>, IManhoursProjectionsCurrentJobsImportRepository
    {

        public ManhoursProjectionsCurrentJobsImportRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context,  logger)
        {
            
        }

        public async Task<ManhoursProjectionsOutput> ImportProjectionsAsync(
            BaseSpTcmPL baseSpTcmPL,
            ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_excel.import_mhrs_proj_current_jobs";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
