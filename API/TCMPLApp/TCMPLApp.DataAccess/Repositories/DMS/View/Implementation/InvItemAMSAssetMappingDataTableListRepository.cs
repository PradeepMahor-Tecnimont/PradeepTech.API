using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class InvItemAMSAssetMappingDataTableListRepository : ViewTcmPLRepository<InvItemAMSAssetMappingDataTableList>, IInvItemAMSAssetMappingDataTableListRepository
    {
        public InvItemAMSAssetMappingDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<InvItemAMSAssetMappingDataTableList>> InvItemAMSAssetMappingDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_ams_asset_mapping_qry.fn_ams_asset_mapping";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<InvItemAMSAssetMappingDataTableList>> InvItemAMSAssetMappingDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_ams_asset_mapping_qry.fn_xl_ams_asset_mapping";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}