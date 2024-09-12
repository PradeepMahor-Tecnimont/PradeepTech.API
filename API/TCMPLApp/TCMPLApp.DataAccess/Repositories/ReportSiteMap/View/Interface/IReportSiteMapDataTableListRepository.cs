using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.ReportSiteMap;

namespace TCMPLApp.DataAccess.Repositories.ReportSiteMap
{
    public interface IReportSiteMapDataTableListRepository
    {
        public Task<IEnumerable<ReportSiteMapDataTableList>> ReportSiteMapDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);        
    }
}
