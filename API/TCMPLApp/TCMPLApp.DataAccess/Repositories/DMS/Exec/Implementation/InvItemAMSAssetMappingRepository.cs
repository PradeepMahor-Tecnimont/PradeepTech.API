using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class InvItemAMSAssetMappingRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IInvItemAMSAssetMappingRepository
    {
        public InvItemAMSAssetMappingRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> ItemAMSAssetMappingCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_item_ams_asset_mapping.sp_add_ams_asset_mapping";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> ItemAMSAssetMappingEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_item_ams_asset_mapping.sp_update_ams_asset_mapping";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> ItemAMSAssetMappingDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_item_ams_asset_mapping.sp_delete_ams_asset_mapping";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> ItemAMSAssetMappingActiveAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_item_ams_asset_mapping.sp_active_ams_asset_mapping";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}