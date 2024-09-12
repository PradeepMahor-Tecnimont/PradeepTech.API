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
    public class BGPayableMasterDataTableListRepository : ViewTcmPLRepository<BGPayableMasterDataTableList>, IBGPayableMasterDataTableListRepository
    {
        public BGPayableMasterDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<BGPayableMasterDataTableList>> BGPayableMasterDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.pkg_bg_payable_mast_qry.fn_payable_mast";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}