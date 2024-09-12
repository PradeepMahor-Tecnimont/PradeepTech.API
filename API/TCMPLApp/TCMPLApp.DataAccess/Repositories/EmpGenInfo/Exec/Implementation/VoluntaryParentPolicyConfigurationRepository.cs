using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class VoluntaryParentPolicyConfigurationRepository : ExecTcmPLRepository<ParameterSpTcmPL, VoluntaryParentPolicyConfiguration>, IVoluntaryParentPolicyConfigurationRepository
    {
        public VoluntaryParentPolicyConfigurationRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<VoluntaryParentPolicyConfiguration> VoluntaryParentPolicyConfiguration(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_vpp_config.sp_vpp_config";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
    }
}