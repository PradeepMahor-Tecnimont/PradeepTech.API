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
    public class ModuleActionsDataTableListRepository : ViewTcmPLRepository<ModuleActionsDataTableList>, IModuleActionsDataTableListRepository
    {
        public ModuleActionsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<ModuleActionsDataTableList>> ModuleActionsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_user_access_qry.fn_module_action_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}