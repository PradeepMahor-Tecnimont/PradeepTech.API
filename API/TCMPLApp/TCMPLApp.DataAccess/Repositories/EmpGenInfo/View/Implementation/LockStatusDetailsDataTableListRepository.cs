using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.CoreSettings;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.CoreSettings;
using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class LockStatusDetailsDataTableListRepository : ViewTcmPLRepository<EmpLockStatusDetailsDataTableList>, ILockStatusDetailsDataTableListRepository
    {
        public LockStatusDetailsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<EmpLockStatusDetailsDataTableList>> LockStatusDetailsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.emp_gen_info_hr_qry.fn_emp_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
