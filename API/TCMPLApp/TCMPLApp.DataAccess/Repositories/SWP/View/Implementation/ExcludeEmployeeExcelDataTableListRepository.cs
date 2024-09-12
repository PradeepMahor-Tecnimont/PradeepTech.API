using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class ExcludeEmployeeExcelDataTableListRepository : ViewTcmPLRepository<ExcludeEmployeeExcelDataTableList>, IExcludeEmployeeExcelDataTableListRepository
    {
        public ExcludeEmployeeExcelDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<ExcludeEmployeeExcelDataTableList>> ExcludeEmployeeExcelDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_exclude_emp_qry.fn_Swp_Exclude_Emp_excel";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}