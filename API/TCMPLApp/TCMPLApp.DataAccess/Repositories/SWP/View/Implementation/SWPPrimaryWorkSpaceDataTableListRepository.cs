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
    public class SWPPrimaryWorkSpaceDataTableListRepository : ViewTcmPLRepository<PrimaryWorkSpaceDataTableList>, ISWPPrimaryWorkSpaceDataTableListRepository
    {
        public SWPPrimaryWorkSpaceDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<PrimaryWorkSpaceDataTableList>> PrimaryWorkSpaceDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace_qry.fn_emp_pws_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<PrimaryWorkSpaceDataTableList>> PrimaryWorkSpace4AdminDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace_qry.fn_emp_pws_admin_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<PrimaryWorkSpaceDataTableList>> PrimaryWorkSpacePlanning4AdminDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace_qry.fn_emp_pws_admin_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }


        public async Task<IEnumerable<PrimaryWorkSpaceDataTableList>> PrimaryWorkSpacePlanningDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace_qry.fn_emp_pws_plan_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<PrimaryWorkSpaceDataTableList>> GetPrimaryWorkSpaceCurrentDownload(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace_qry.fn_emp_pws_excel";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<PrimaryWorkSpaceDataTableList>> GetPrimaryWorkSpacePlanningDownload(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace_qry.fn_emp_pws_plan_excel";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}