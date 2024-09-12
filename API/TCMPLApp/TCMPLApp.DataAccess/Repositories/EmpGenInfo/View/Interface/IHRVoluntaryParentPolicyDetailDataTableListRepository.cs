using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public interface IHRVoluntaryParentPolicyDetailDataTableListRepository
    {
        public Task<IEnumerable<HRVoluntaryParentPolicyDetailDataTableList>> HRVoluntaryParentPolicyDetailDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}