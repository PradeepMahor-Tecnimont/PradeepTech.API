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
    public class HREmpDetailsNotFilledDataTableListRepository : ViewTcmPLRepository<HREmpDetailsNotFilledDataTableList>, IHREmpDetailsNotFilledDataTableListRepository
    {
        public HREmpDetailsNotFilledDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<HREmpDetailsNotFilledDataTableList>> HREmpDetailsNotFilledDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_gen_info_report_qry.fn_emp_details_not_filled_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}