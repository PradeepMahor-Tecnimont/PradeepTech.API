using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class EmployeeMasterDataTableListExcelViewRepository : ViewTcmPLRepository<EmployeeMasterMainDataTableListExcel>, IEmployeeMasterDataTableListExcelViewRepository
    {
        public EmployeeMasterDataTableListExcelViewRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
            
        }      

        public async Task<IEnumerable<EmployeeMasterMainDataTableListExcel>> GetEmployeeMasterForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.hr_pkg_emplmast_main.fn_employee_master_list_Excel";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
