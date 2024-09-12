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
    public class SWPEmployeesDataTableListRepository : ViewTcmPLRepository<SWPEmployeesDataTableList>, ISWPEmployeesDataTableListRepository
    {
        public SWPEmployeesDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<SWPEmployeesDataTableList>> Employees(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_employees_qry.fn_swp_employees";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}