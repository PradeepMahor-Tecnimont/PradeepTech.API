using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class AssetWithITPoolDataTableListRepository : ViewTcmPLRepository<DataTable>, IAssetWithITPoolDataTableListRepository
    {
        public AssetWithITPoolDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DataTable> AssetWithITPoolDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_reports.fn_asset_with_itpool_list";
            return await GetDataTableAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}