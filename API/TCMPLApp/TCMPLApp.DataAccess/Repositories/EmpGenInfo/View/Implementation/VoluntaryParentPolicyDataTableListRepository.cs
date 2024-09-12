using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class VoluntaryParentPolicyDataTableListRepository : ViewTcmPLRepository<VoluntaryParentPolicyDataTableList>, IVoluntaryParentPolicyDataTableListRepository
    {
        public VoluntaryParentPolicyDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<VoluntaryParentPolicyDataTableList>> VoluntaryParentPolicyDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.vpp_user_qry.fn_vpp_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}