using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public interface IFutureEmpComingToOfficeDataTableListRepository
    {
        public Task<IEnumerable<FutureEmpComingToOfficeDataTableList>> FutureEmpComingToOfficeDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}