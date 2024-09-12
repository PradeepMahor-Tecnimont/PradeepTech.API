using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.CoreSettings;

namespace TCMPLApp.DataAccess.Repositories.CoreSettings
{
    public class ModuleUserRoleActionsDataTableListRepository : ViewTcmPLRepository<ModuleUserRoleActionsDataTableList>, IModuleUserRoleActionsDataTableListRepository
    {
        public ModuleUserRoleActionsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<ModuleUserRoleActionsDataTableList>> ModuleUserRoleActionsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_user_access_qry.fn_module_user_role_actions";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
