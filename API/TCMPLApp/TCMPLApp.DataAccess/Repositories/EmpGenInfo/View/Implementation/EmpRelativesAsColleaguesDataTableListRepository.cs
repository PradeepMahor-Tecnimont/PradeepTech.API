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

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class EmpRelativesAsColleaguesDataTableListRepository : ViewTcmPLRepository<EmpRelativesAsColleaguesDataTableList>, IEmpRelativesAsColleaguesDataTableListRepository
    {
        public EmpRelativesAsColleaguesDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<EmpRelativesAsColleaguesDataTableList>> EmpRelativesAsColleaguesDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_relatives_as_colleagues_qry.fn_emp_relatives_as_colleagues_list_widget";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
