using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class DMSAsset2HomeUpdateRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IDMSAsset2HomeUpdateRepository
    {
        public DMSAsset2HomeUpdateRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public virtual async Task<DBProcMessageOutput> Asset2HomeUpdate(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.iot_dms_ss.sp_update_asset_2home";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }        
    }
}
