using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class DMSOrphanAssetDataTableListRepository : ViewTcmPLRepository<DMSOrphanAssetDataTableList>, IDMSOrphanAssetDataTableListRepository
    {
        public DMSOrphanAssetDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }
       
        public virtual async Task<IEnumerable<DMSOrphanAssetDataTableList>> OrphanAssetDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.iot_dms_ss_qry.get_orphan_request_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }


    }
}
