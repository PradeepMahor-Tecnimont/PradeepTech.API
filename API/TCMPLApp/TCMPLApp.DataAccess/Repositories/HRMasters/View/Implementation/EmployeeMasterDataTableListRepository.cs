using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class EmployeeMasterDataTableListViewRepository : ViewTcmPLRepository<EmployeeMasterMainDataTableList>, IEmployeeMasterDataTableListViewRepository
    {
        public EmployeeMasterDataTableListViewRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
            
        }
        public async Task<IEnumerable<EmployeeMasterMainDataTableList>> GetEmployeeMasterListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.hr_pkg_emplmast_main.fn_employee_master_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        
    }
}
