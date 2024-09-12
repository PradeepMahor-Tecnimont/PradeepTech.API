using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.JOB;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.CoreSettings;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.CoreSettings
{
    public class ActionsDataTableListRepository : ViewTcmPLRepository<ActionsDataTableList>, IActionsDataTableListRepository
    {
        public ActionsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<ActionsDataTableList>> ActionsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_user_access_qry.fn_action_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}