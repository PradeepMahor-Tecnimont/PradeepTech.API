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
    public class SWPSmartWorkSpaceDataTableListRepository : ViewTcmPLRepository<SmartWorkSpaceDataTableList>, ISWPSmartWorkSpaceDataTableListRepository
    {
        public SWPSmartWorkSpaceDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<SmartWorkSpaceDataTableList>> SmartWorkSpaceDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            //CommandText = "selfservice.iot_swp_qry.fn_week_attend_planning";
            CommandText = "selfservice.IOT_SWP_SMART_WORKSPACE_QRY.fn_week_attend_planning";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<SmartWorkSpaceDataTableList>> SmartWorkSpaceAllDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            //CommandText = "selfservice.iot_swp_qry.fn_week_attend_planning";
            CommandText = "selfservice.IOT_SWP_SMART_WORKSPACE_QRY.fn_week_attend_planning_all";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }



        public async Task<IEnumerable<SmartWorkSpaceDataTableList>> SmartWorkSpaceEmpDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            //CommandText = "selfservice.iot_swp_qry.fn_week_attend_planning";
            CommandText = "selfservice.IOT_SWP_SMART_WORKSPACE_QRY.fn_emp_week_attend_planning";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}