using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.CoreSettings;

namespace TCMPLApp.DataAccess.Repositories.CoreSettings
{
    public class AppUserMasterDataTableListRepository : ViewTcmPLRepository<AppUserMasterDataTableList>, IAppUserMasterDataTableListRepository
    {
        public AppUserMasterDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<AppUserMasterDataTableList>> AppUserMasterDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_app_user_master_qry.fn_app_user_master_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
