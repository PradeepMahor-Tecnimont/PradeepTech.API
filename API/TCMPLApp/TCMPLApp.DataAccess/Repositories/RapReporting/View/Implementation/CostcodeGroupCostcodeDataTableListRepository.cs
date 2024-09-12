using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public class CostcodeGroupCostcodeDataTableListRepository : ViewTcmPLRepository<CostcodeGroupCostcodeDataTableList>, ICostcodeGroupCostcodeDataTableListRepository
    {
        public CostcodeGroupCostcodeDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<CostcodeGroupCostcodeDataTableList>> CostcodeGroupCostcodeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_costcode_grp_costcode_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}