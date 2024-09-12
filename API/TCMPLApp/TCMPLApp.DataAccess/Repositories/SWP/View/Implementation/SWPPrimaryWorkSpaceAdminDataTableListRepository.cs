using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class SWPPrimaryWorkSpaceAdminDataTableListRepository : ViewTcmPLRepository<PrimaryWorkSpaceForAdminDataTableList>, ISWPPrimaryWorkSpaceAdminDataTableListRepository
    {
        public SWPPrimaryWorkSpaceAdminDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<PrimaryWorkSpaceForAdminDataTableList>> PrimaryWorkSpaceForAdminDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace_qry.fn_emp_pws_hist_admin_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<PrimaryWorkSpaceForAdminDataTableList>> PrimaryWorkSpaceDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace_qry.fn_emp_pws_hist_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}