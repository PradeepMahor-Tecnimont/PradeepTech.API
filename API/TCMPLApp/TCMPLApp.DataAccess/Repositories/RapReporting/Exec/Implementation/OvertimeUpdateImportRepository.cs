using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public class OvertimeUpdateImportRepository : ExecTcmPLRepository<ParameterSpTcmPL, OvertimeUpdateOutput>, IOvertimeUpdateImportRepository
    {

        public OvertimeUpdateImportRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context,  logger)
        {
            
        }

        public async Task<OvertimeUpdateOutput> ImportOvertimeUpdateAsync(
            BaseSpTcmPL baseSpTcmPL,
            ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_excel.import_overtime_update";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
