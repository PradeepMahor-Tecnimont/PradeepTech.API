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
using TCMPLApp.Domain.Models.Utilities;

namespace TCMPLApp.DataAccess.Repositories.Utilities
{
    public class CostcodeListDataTableListRepository : ViewTcmPLRepository<CostcodeListDataTableList>, ICostcodeListDataTableListRepository
    {
        public CostcodeListDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<CostcodeListDataTableList>> CostcodeListDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.hr_pkg_costmast_main.fn_costcode_list_4_utilities";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        
    }
}