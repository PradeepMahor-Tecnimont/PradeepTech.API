using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class AssetOnHoldActionTransDataTableListRepository : ViewTcmPLRepository<AssetOnHoldActionTransDataTableList>, IAssetOnHoldActionTransDataTableListRepository
    {
        public AssetOnHoldActionTransDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<AssetOnHoldActionTransDataTableList>> AssetOnHoldActionTransDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_asset_on_hold_qry.fn_dm_action_trans";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}