using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class VoluntaryParentPolicyDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, VoluntaryParentPolicyDetail>, IVoluntaryParentPolicyDetailRepository
    {
        public VoluntaryParentPolicyDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        #region VoluntaryParentPolicy Detail

        public async Task<VoluntaryParentPolicyDetail> VoluntaryParentPolicyDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.vpp_user_qry.sp_vpp_detail";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }

        #endregion VoluntaryParentPolicy Detail
    }
}