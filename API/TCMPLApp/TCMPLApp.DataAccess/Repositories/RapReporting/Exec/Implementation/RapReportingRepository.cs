using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public class RapReportingRepository : ExecTcmPLRepository<ParameterSpTcmPL, Projmast>, IRapReportingRepository
    {
        public RapReportingRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<Projmast> ProjmastNameAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_reports_gen.get_proj_name_proc";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }

        public async Task<Projmast> ExpectedProjmastNameAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_reports_gen.get_expt_proj_name_proc";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }

        public async Task<Projmast> CostcodeNameAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_reports_gen.get_costcode_name_proc";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
    }
}
