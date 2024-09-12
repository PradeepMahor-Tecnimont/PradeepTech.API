using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class AssetDistributionDataTableListRepository : ViewTcmPLRepository<AssetDistributionDataTableList>, IAssetDistributionDataTableListRepository
    {
        public AssetDistributionDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<AssetDistributionDataTableList>> AssetDistributionDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_asset_distribution_qry.fn_xl_asset_distribution";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}