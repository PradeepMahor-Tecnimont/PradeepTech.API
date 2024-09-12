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
    public class AfcLcMainDataTableListRepository : ViewTcmPLRepository<AfcLcMainDataTableList>, IAfcLcMainDataTableListRepository
    {
        public AfcLcMainDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<AfcLcMainDataTableList>> AfcLcMainDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.lc_action_qry.fn_main";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}