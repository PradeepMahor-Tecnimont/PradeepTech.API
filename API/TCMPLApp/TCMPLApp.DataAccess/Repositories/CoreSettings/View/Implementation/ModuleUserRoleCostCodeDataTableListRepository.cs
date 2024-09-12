using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.CoreSettings;

namespace TCMPLApp.DataAccess.Repositories.CoreSettings
{
    public class ModuleUserRoleCostCodeDataTableListRepository : ViewTcmPLRepository<ModuleUserRoleCostCodeDataTableList>, IModuleUserRoleCostCodeDataTableListRepository
    {
        public ModuleUserRoleCostCodeDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<ModuleUserRoleCostCodeDataTableList>> ModuleUserRoleCostCodeDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_user_access_qry.fn_module_user_role_costcode";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
