using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class DMSOrphanAssetUpdateRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IDMSOrphanAssetUpdateRepository
    {
        public DMSOrphanAssetUpdateRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public virtual async Task<DBProcMessageOutput> OrphanAssetUpdate(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.iot_dms_ss.sp_update_orphan_asset";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }        
    }
}
