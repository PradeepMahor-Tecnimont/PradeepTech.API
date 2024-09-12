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
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public class MovemastForExcelTemplateDataTableListRepository : ViewTcmPLRepository<MovemastForExcelDataTableList>, IMovemastForExcelTemplateDataTableListRepository
    {
        public MovemastForExcelTemplateDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<MovemastForExcelDataTableList>> MovemastForExcelTemplateDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_movemast.fn_movemast_list_for_template";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
