using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.HSE;
using Microsoft.Extensions.Logging;

namespace TCMPLApp.DataAccess.Repositories.HSE
{
    public class HSEQuizDetailsRepository : ExecTcmPLRepository<ParameterSpTcmPL, HSEQuizDetailOut>, IHSEQuizDetailsRepository
    {
        public HSEQuizDetailsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<HSEQuizDetailOut> HSEQuizDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_hse_quiz_user_qry.sp_hse_quiz_detail";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
