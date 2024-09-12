using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class VppConfigPremiumDataTableListRepository : ViewTcmPLRepository<VppConfigPremiumDataTableList>, IVppConfigPremiumDataTableListRepository
    {
        public VppConfigPremiumDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<VppConfigPremiumDataTableList>> VppConfigPremiumDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_vpp_config_qry.fn_vpp_config_premium_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}