using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class AssetOnHoldAssetAddDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, AssetOnHoldAssetAddDetails>, IAssetOnHoldAssetAddDetailRepository
    {
        public AssetOnHoldAssetAddDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<AssetOnHoldAssetAddDetails> DmAssetAddDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_asset_on_hold_qry.sp_dm_assetadd_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}