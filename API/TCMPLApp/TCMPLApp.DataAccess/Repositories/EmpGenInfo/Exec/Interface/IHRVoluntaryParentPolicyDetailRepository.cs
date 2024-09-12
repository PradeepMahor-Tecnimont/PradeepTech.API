using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public interface IHRVoluntaryParentPolicyDetailRepository
    {
        #region VoluntaryParentPolicy Detail

        public Task<HRVoluntaryParentPolicyDetail> HRVoluntaryParentPolicyDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        #endregion VoluntaryParentPolicy Detail
    }
}