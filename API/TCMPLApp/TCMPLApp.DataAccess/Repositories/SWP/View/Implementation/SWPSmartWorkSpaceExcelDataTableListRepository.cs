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
    public class SWPSmartWorkSpaceExcelDataTableListRepository : ViewTcmPLRepository<SmartWorkSpaceExcelDataTableList>, ISWPSmartWorkSpaceExcelDataTableListRepository
    {
        public SWPSmartWorkSpaceExcelDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<SmartWorkSpaceExcelDataTableList>> SmartWorkSpacePlanningExcelDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.IOT_SWP_SMART_WORKSPACE_QRY.fn_future_planning_xl";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);

        }


        public async Task<IEnumerable<SmartWorkSpaceExcelDataTableList>> SmartWorkSpaceCurrentExcelDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.IOT_SWP_SMART_WORKSPACE_QRY.fn_current_planning_xl";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);

        }


        public async Task<IEnumerable<SmartWorkSpaceExcelDataTableList>> SmartWorkSpaceAllExcelDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            //CommandText = "selfservice.iot_swp_qry.fn_week_attend_planning";
            CommandText = "selfservice.IOT_SWP_SMART_WORKSPACE_QRY.fn_all_current_planning_xl";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }


    }
}
