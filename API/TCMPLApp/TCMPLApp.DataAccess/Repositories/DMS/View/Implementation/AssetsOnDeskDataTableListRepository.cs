using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class AssetsOnDeskDataTableListRepository : ViewTcmPLRepository<AssetsOnDeskDataTableList>, IAssetsOnDeskDataTableListRepository
    {
        public AssetsOnDeskDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<AssetsOnDeskDataTableList>> AssetsOnDeskDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_desk_asgmt_qry.fn_assets_on_desk";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<AssetsOnDeskDataTableList>> AssetsOnDeskForEnggDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_desk_asgmt_4engg_qry.fn_assets_on_desk";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}