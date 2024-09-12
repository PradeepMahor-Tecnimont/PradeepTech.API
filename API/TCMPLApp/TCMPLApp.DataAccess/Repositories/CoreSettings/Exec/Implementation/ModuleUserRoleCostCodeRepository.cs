using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.CoreSettings
{
    public class ModuleUserRoleCostCodeRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IModuleUserRoleCostCodeRepository
    {
        public ModuleUserRoleCostCodeRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }
        public async Task<DBProcMessageOutput> ModuleUserRoleCostCodeCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_user_access.sp_add_module_user_role_costcode";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
        
        public async Task<DBProcMessageOutput> ModuleUserRoleCostCodeDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_user_access.sp_delete_module_user_role_costcode";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
