using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS

{
    public interface IAssetOnHoldAssetAddDataTableListRepository
    {
        public Task<IEnumerable<AssetOnHoldAssetAddDataTableList>> AssetOnHoldAssetAddDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<AssetOnHoldAssetAddDataTableList>> AssetOnHoldAssetAddXLDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}