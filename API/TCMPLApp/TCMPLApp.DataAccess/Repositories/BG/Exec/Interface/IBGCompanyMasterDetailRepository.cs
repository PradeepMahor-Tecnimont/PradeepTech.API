using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.BG;

namespace TCMPLApp.DataAccess.Repositories.BG
{
    public interface IBGCompanyMasterDetailRepository
    {
        public Task<BGCompanyMasterDetail> BGCompanyMasterDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}