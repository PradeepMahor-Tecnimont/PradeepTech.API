using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class SWPAssignCostCodesDataTableListRepository : ViewTcmPLRepository<AssignCostCodesDataTableList>, ISWPAssignCostCodesDataTableListRepository
    {
        public SWPAssignCostCodesDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<AssignCostCodesDataTableList>> AssignCostCodesDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_costmast_qry.fn_assign_costcode_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}

