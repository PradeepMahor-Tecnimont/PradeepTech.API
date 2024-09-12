using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.ReportSiteMap;

namespace TCMPLApp.DataAccess.Repositories.ReportSiteMap
{
    public interface IReportSiteMapFilterRepository
    {
        public Task<IEnumerable<ReportSiteMapFilter>> ReportSiteMapParameterAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
