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
    public class SWPOfficeWorkspaceEmpAbsentDataTableListRepository : ViewTcmPLRepository<OWSEmployeeAbsentDataTableList>, ISWPOfficeWorkspaceEmpAbsentDataTableListRepository
    {
        public SWPOfficeWorkspaceEmpAbsentDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<OWSEmployeeAbsentDataTableList>> OWSAdminEmpAbsentList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_attendance_exception.fn_admin_ows";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<OWSEmployeeAbsentDataTableList>> OWSEmpAbsentList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_attendance_exception.fn_ows";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

    }
}