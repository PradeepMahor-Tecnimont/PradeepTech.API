using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.BG;

namespace TCMPLApp.DataAccess.Repositories.BG
{
    public interface IBGVendorMasterDetailRepository
    {
        public Task<BGVendorMasterDetail> BGVendorMasterDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}