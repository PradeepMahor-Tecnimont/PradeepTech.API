using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.BG;

namespace TCMPLApp.DataAccess.Repositories.BG
{
    public interface IBGBankMasterDetailRepository
    {
        public Task<BGBankMasterDetail> BGBankMasterDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}