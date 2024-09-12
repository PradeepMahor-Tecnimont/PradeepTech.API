using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class InvItemAMSAssetMappingDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, InvItemAMSAssetMappingDetails>, IInvItemAMSAssetMappingDetailRepository
    {
        public InvItemAMSAssetMappingDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<InvItemAMSAssetMappingDetails> ItemAMSAssetMappingDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_ams_asset_mapping_qry.sp_ams_asset_mapping_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}