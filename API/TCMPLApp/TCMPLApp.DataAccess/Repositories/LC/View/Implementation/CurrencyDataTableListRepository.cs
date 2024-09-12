using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.LC;

namespace TCMPLApp.DataAccess.Repositories.LC
{
    public class CurrencyDataTableListRepository : ViewTcmPLRepository<CurrencyDataTableList>, ICurrencyDataTableListRepository
    {
        public CurrencyDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<CurrencyDataTableList>> CurrencyDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.lc_masters_qry.fn_currency";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}