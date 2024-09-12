using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.ERS
{
    public class HRCVActionUpdateRepository :ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IHRCVActionUpdateRepository
    {

        public HRCVActionUpdateRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
    {
        }

        #region CV action update  

        public async Task<DBProcMessageOutput> CVActionUpdate(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.ers.sp_cv_status_update";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }

        #endregion CV action update
    }
}
