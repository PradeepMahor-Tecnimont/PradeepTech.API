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
    public class HRVoluntaryParentPolicyDetailDataTableListRepository : ViewTcmPLRepository<HRVoluntaryParentPolicyDetailDataTableList>, IHRVoluntaryParentPolicyDetailDataTableListRepository
    {
        public HRVoluntaryParentPolicyDetailDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<HRVoluntaryParentPolicyDetailDataTableList>> HRVoluntaryParentPolicyDetailDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.vpp_hr_qry.fn_vpp_hr_detail_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}