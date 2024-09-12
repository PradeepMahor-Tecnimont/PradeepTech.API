using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class DMSEmployeeRepository : ViewTcmPLRepository<DeskAssetTakeHomeDetail>, IDMSEmployeeRepository
    {
        public DMSEmployeeRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<DeskAssetTakeHomeDetail>> DeskAssetTakeHomeDetailList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.iot_dms_ss_qry.get_desk_asset_details";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}