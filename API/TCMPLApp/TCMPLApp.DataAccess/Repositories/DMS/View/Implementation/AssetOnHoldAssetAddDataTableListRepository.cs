using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class AssetOnHoldAssetAddDataTableListRepository : ViewTcmPLRepository<AssetOnHoldAssetAddDataTableList>, IAssetOnHoldAssetAddDataTableListRepository
    {
        public AssetOnHoldAssetAddDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<AssetOnHoldAssetAddDataTableList>> AssetOnHoldAssetAddDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_asset_on_hold_qry.fn_dm_assetadd";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<AssetOnHoldAssetAddDataTableList>> AssetOnHoldAssetAddXLDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_asset_on_hold_qry.fn_xl_dm_assetadd";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}