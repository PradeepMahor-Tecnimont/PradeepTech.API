using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.JOB;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.EmpGenInfo;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class GTLINominationSubmitStatusDataTableListRepository : ViewTcmPLRepository<EmpGTLINominationSubmitStatusDataTableList>, IGTLINominationSubmitStatusDataTableListRepository
    {
        public GTLINominationSubmitStatusDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<EmpGTLINominationSubmitStatusDataTableList>> GTLINominationSubmitStatusDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.emp_gen_info_hr_qry.fn_emp_gtli_status_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<EmpGTLINominationSubmitStatusDataTableList>> GTLINominationSubmitStatusDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.emp_gen_info_hr_qry.fn_emp_gtli_status_xl";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
