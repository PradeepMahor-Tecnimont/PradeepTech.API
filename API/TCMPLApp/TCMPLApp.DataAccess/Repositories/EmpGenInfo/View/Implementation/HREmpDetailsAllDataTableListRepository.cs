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
    public class HREmpDetailsAllDataTableListRepository : ViewTcmPLRepository<HREmpDetailsAllDataTableList>, IHREmpDetailsAllDataTableListRepository
    {
        public HREmpDetailsAllDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<HREmpDetailsAllDataTableList>> HREmpDetailsAllDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_gen_info_report_qry.fn_emp_details_all_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}