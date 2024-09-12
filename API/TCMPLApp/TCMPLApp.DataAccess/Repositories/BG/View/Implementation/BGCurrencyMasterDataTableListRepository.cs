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
    public class BGCurrencyMasterDataTableListRepository : ViewTcmPLRepository<BGCurrencyMasterDataTableList>, IBGCurrencyMasterDataTableListRepository
    {
        public BGCurrencyMasterDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<BGCurrencyMasterDataTableList>> BGCurrencyMasterDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.pkg_bg_currency_mast_qry.fn_currency_mast";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}