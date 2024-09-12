using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.DataAccess.Repositories
{
    public interface IRSVPViewRepository
    {        
        public Task<IEnumerable<NavratriRSVPExcelList>> GetNavratriRSVPExcelListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        
    }
}
