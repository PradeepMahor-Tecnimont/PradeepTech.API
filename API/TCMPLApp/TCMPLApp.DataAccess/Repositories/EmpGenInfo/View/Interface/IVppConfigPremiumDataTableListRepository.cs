using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public interface IVppConfigPremiumDataTableListRepository
    {
        public Task<IEnumerable<VppConfigPremiumDataTableList>> VppConfigPremiumDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}