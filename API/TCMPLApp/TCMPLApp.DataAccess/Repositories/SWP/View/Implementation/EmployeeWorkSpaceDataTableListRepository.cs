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
    public class EmployeeWorkSpaceDataTableListRepository : ViewTcmPLRepository<EmployeeWorkSpaceDataTableList>, IEmployeeWorkSpaceDataTableListRepository
    {
        public EmployeeWorkSpaceDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<EmployeeWorkSpaceDataTableList>> EmployeeWorkSpaceDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.IOT_SWP_COMMON.fn_employee_workspace";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}