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
    public class SWPPrimaryWorkSpaceExcelDataTableListRepository : ViewTcmPLRepository<PrimaryWorkSpaceDataTableList>, ISWPPrimaryWorkSpaceExcelDataTableListRepository
    {
        public SWPPrimaryWorkSpaceExcelDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }



        public async Task<IEnumerable<PrimaryWorkSpaceDataTableList>> PrimaryWorkSpacePlanningExcelDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace_qry.fn_emp_pws_plan_excel";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<PrimaryWorkSpaceDataTableList>> PrimaryWorkSpaceCurrentExcelDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_primary_workspace_qry.fn_emp_pws_excel";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }


    }
}