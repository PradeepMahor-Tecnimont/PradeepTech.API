using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.EmpGenInfo;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class ProspectiveEmployeesDataTableListRepository : ViewTcmPLRepository<ProspectiveEmployeesDataTableList>, IProspectiveEmployeesDataTableListRepository
    {
        public ProspectiveEmployeesDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<ProspectiveEmployeesDataTableList>> ProspectiveEmployeesDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_prospective_emp_qry.fn_all_emp_list_hr";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
