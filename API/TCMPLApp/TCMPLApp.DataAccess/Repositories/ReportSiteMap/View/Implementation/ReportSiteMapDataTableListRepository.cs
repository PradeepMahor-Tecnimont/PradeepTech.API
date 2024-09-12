using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.ReportSiteMap;

namespace TCMPLApp.DataAccess.Repositories.ReportSiteMap
{
    public class ReportSiteMapDataTableListRepository : ViewTcmPLRepository<ReportSiteMapDataTableList>, IReportSiteMapDataTableListRepository
    {
        public ReportSiteMapDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<ReportSiteMapDataTableList>> ReportSiteMapDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_process_site_map.fn_get_site_map";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
