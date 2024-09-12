using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public class ManhoursPrjcJobDetailsForExcelDataTableListRepository : ViewTcmPLRepository<ManhoursProjectionsCurrentJobsDetailForExcelDataTableList>, IManhoursPrjcJobDetailsForExcelDataTableListRepository
    {
        public ManhoursPrjcJobDetailsForExcelDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }
        public async Task<IEnumerable<ManhoursProjectionsCurrentJobsDetailForExcelDataTableList>> ManhoursPrjcJobDetailsForTemplateDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_prjc_mast.fn_prjc_details_list_for_excel_template";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
