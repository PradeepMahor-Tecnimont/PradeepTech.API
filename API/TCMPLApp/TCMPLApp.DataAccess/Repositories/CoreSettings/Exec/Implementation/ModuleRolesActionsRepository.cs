using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.CoreSettings
{
    public class ModuleRolesActionsRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IModuleRolesActionsRepository
    {
        public ModuleRolesActionsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }
        public async Task<DBProcMessageOutput> ModuleRolesActionsCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_user_access.sp_add_module_roles_actions";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
        public async Task<DBProcMessageOutput> ModuleRolesActionsEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_job_masters.sp_update_job_tmagroup";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> ModuleRolesActionsDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_user_access.sp_delete_module_roles_actions";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
