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
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class ExcludeDataTableListRepository : ViewTcmPLRepository<ExcludeDataTableList>, IExcludeDataTableListRepository
    {
        public ExcludeDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<ExcludeDataTableList>> ExcludeDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_exclude_from_moc5_qry.fn_exclude_emp_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
