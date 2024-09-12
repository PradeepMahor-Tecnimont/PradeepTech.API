using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.SWP;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class EmpOfficeLocationHistoryDataTableListRepository : ViewTcmPLRepository<EmpOfficeLocationHistoryDataTableList>, IEmpOfficeLocationHistoryDataTableListRepository
    {
        public EmpOfficeLocationHistoryDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }
        public async Task<IEnumerable<EmpOfficeLocationHistoryDataTableList>> EmpOfficeLocationHistoryDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.eo_employee_office_qry.fn_employee_office_hist_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
