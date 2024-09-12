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
    public class EmpRelativesAsColleaguesDataTableListExcelViewRepository : ViewTcmPLRepository<EmpRelativesAsColleaguesDataTableListExcel>, IEmpRelativesAsColleaguesDataTableListExcelViewRepository
    {
        public EmpRelativesAsColleaguesDataTableListExcelViewRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<EmpRelativesAsColleaguesDataTableListExcel>> GetEmpRelativesAsColleaguesForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_relatives_as_colleagues_qry.fn_emp_relatives_as_colleagues_list_widget";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
