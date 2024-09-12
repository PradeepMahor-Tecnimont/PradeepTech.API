using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.BG;

namespace TCMPLApp.DataAccess.Repositories.BG
{
    public class BGProjectControlMasterDataTableListRepository : ViewTcmPLRepository<BGProjectControlMasterDataTableList>, IBGProjectControlMasterDataTableListRepository
    {
        public BGProjectControlMasterDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<BGProjectControlMasterDataTableList>> BGProjectControlMasterDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.pkg_bg_proj_contl_mast_qry.fn_proj_contl_mast";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}