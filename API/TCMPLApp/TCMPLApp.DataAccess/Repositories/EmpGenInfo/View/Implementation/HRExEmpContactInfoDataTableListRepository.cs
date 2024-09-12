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
    public class HRExEmpContactInfoDataTableListRepository : ViewTcmPLRepository<HRExEmpContactInfoDataTableList>, IHRExEmpContactInfoDataTableListRepository
    {
        public HRExEmpContactInfoDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<HRExEmpContactInfoDataTableList>> HRExEmpContactInfoDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_gen_info_report_qry.fn_ex_emp_contact_info_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}