using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class HRVoluntaryParentPolicyDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, HRVoluntaryParentPolicyDetail>, IHRVoluntaryParentPolicyDetailRepository
    {
        public HRVoluntaryParentPolicyDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        #region VoluntaryParentPolicy Detail

        public async Task<HRVoluntaryParentPolicyDetail> HRVoluntaryParentPolicyDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.vpp_hr_qry.sp_vpp_hr_detail";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }

        #endregion VoluntaryParentPolicy Detail
    }
}