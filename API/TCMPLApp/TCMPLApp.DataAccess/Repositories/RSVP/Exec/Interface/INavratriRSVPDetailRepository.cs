using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.DataAccess.Repositories
{
    public interface INavratriRSVPDetailRepository
    {        
        public Task<NavratriRSVPDetailOutput> NavratriRSVPDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);    

    }
}
