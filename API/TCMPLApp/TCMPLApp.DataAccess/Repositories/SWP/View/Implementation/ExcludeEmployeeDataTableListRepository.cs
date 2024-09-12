using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class ExcludeEmployeeDataTableListRepository : ViewTcmPLRepository<ExcludeEmployeeDataTableList>, IExcludeEmployeeDataTableListRepository
    {
        public ExcludeEmployeeDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<ExcludeEmployeeDataTableList>> ExcludeEmployeeDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_exclude_emp_qry.fn_Swp_Exclude_Emp_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}