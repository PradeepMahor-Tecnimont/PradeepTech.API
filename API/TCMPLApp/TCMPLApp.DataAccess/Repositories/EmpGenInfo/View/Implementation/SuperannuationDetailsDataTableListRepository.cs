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
    public class SuperannuationDetailsDataTableListRepository : ViewTcmPLRepository<SuperannuationDetailsDataTableList>, ISuperannuationDetailsDataTableListRepository
    {
        public SuperannuationDetailsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<SuperannuationDetailsDataTableList>> SuperannuationDetailsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_sup_annuation_qry.fn_emp_sup_annuation_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<SuperannuationDetailsDataTableList>> HRSuperannuationDetailsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_sup_annuation_qry.fn_4hr_emp_sup_annuation_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}