using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class DMSAsset2HomeDetailRepository : ViewTcmPLRepository<DMSAssetTakeHome>, IDMSAsset2HomeDetailRepository
    {
        public DMSAsset2HomeDetailRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public virtual async Task<IEnumerable<DMSAssetTakeHome>> AssetTakeHomeDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.iot_dms_ss_qry.get_2home_request_detail";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DMSAssetTakeHome>>GatepassDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.iot_dms_ss_qry.get_2home_gatepass_detail";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

    }
}
