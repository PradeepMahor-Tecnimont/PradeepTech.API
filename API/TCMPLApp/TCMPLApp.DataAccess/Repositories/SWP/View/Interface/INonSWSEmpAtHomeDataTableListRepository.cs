using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.SWP;


namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public interface INonSWSEmpAtHomeDataTableListRepository
    {
        public Task<IEnumerable<NonSWSEmpAtHomeDataTableList>> NonSWSEmpAtHome4HodSecDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<NonSWSEmpAtHomeDataTableList>> NonSWSEmpAtHome4AdminDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}