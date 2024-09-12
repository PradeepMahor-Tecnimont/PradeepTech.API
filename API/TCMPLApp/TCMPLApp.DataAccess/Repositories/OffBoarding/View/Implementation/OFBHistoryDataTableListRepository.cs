using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.OffBoarding;

namespace TCMPLApp.DataAccess.Repositories.OffBoarding
{
    public class OFBHistoryDataTableListRepository : ViewTcmPLRepository<OFBInitDataTableList>, IOFBHistoryDataTableListRepository
    {
        public OFBHistoryDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<OFBInitDataTableList>> OFBAllApprovalsHistoryDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_ofb_historical_list.fn_ofb_historical_all_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<OFBInitDataTableList>> OFBPendingApprovalsHistoryDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_ofb_historical_list.fn_ofb_historical_pending_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<OFBInitDataTableList>> OFBApproveApprovalsHistoryDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_ofb_historical_list.fn_ofb_historical_approved_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
