using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.BG;

namespace TCMPLApp.DataAccess.Repositories.BG
{
    public interface IBGCurrencyMasterDataTableListRepository
    {
        public Task<IEnumerable<BGCurrencyMasterDataTableList>> BGCurrencyMasterDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}