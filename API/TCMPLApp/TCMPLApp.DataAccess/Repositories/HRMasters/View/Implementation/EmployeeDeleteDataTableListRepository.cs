using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class EmployeeDeleteDataTableListRepository : ViewTcmPLRepository<EmployeeDeleteDataTableList>, IEmployeeDeleteDataTableListRepository
    { 
        public EmployeeDeleteDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
            
        }
        public async Task<IEnumerable<EmployeeDeleteDataTableList>> GetEmployeeDeleteDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.hr_pkg_emplmast_delete.fn_delete_employee_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        
    }
}
