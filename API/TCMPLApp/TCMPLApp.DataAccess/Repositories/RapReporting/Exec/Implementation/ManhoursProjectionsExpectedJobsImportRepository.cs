using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public class ManhoursProjectionsExpectedJobsImportRepository : ExecTcmPLRepository<ParameterSpTcmPL, ManhoursProjectionsOutput>, IManhoursProjectionsExpectedJobsImportRepository
    {

        public ManhoursProjectionsExpectedJobsImportRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context,  logger)
        {
            
        }

        public async Task<ManhoursProjectionsOutput> ImportProjectionsAsync(
            BaseSpTcmPL baseSpTcmPL,
            ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_excel.import_mhrs_proj_expected_jobs";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }


        public async Task<ManhoursProjectionsOutput> ImportProjectionsAllAsync(
            BaseSpTcmPL baseSpTcmPL,
            ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_excel.import_mhrs_proj_exp_job_proco";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
