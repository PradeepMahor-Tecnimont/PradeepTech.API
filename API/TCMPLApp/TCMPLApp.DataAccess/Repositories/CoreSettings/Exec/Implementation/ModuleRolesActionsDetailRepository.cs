using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.CoreSettings;


namespace TCMPLApp.DataAccess.Repositories.CoreSettings
{
    public class ModuleRolesActionsDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, ModuleRolesActionsDetails>, IModuleRolesActionsDetailRepository
    {
        public ModuleRolesActionsDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<ModuleRolesActionsDetails> ModuleRolesActionsDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_job_masters_qry.sp_job_tmagroup_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
