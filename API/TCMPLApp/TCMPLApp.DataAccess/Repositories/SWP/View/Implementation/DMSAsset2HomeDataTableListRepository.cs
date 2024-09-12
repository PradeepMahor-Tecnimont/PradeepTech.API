using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class DMSAsset2HomeDataTableListRepository : ViewTcmPLRepository<DMSAssetTakeHomeDataTableList>, IDMSAsset2HomeDataTableListRepository
    {
        public DMSAsset2HomeDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public virtual async Task<IEnumerable<DMSAssetTakeHomeDataTableList>> AssetTakeHomeDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {           
            CommandText = "dms.iot_dms_ss_qry.get_2home_request_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DMSAssetTakeHomeDataTableList>> GatePassDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.iot_dms_ss_qry.get_2home_gatepass_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

    }
}
