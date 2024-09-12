using DocumentFormat.OpenXml.Spreadsheet;
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
    public class EmpPensionFundDetailsDataTableListRepository : ViewTcmPLRepository<EmpPensionFundDetailsDataTableList>, IEmpPensionFundDetailsDataTableListRepository
    {
        public EmpPensionFundDetailsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<EmpPensionFundDetailsDataTableList>> EmpPensionFundDetailsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_eps_4_all_qry.fn_emp_eps_4_all_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<EmpPensionFundDetailsDataTableList>> HREmpPensionFundDetailsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_eps_4_all_qry.fn_4hr_emp_eps_4_all_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}