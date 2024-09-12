using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;

namespace TCMPLApp.DataAccess.Repositories.ReportSiteMap
{
    public class RepSiteMapDataTableListRepository : ViewTcmPLRepository<DataTable>, IRepSiteMapDataTableListRepository
    {
        public RepSiteMapDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DataTable> RepSiteMapDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_site_map.fn_get_site_map";
            return await GetDataTableAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
