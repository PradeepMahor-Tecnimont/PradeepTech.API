using System.Data;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;

namespace TCMPLApp.DataAccess.Repositories.ReportSiteMap
{
    public interface IRepSiteMapDataTableListRepository
    {
        public Task<DataTable> RepSiteMapDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}
