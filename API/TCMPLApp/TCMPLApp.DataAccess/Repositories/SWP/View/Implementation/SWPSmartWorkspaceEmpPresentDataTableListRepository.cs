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
    public class SWPSmartWorkspaceEmpPresentDataTableListRepository : ViewTcmPLRepository<SWSEmployeePresentDataTableList>, ISWPSmartWorkspaceEmpPresentDataTableListRepository
    {
        public SWPSmartWorkspaceEmpPresentDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<SWSEmployeePresentDataTableList>> SWSAdminEmpPresentList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_attendance.fn_sws_attendance_all";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<SWSEmployeePresentDataTableList>> SWSEmpPresentList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_attendance.fn_sws_attendance";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}