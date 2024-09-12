using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Logbook;

namespace TCMPLApp.DataAccess.Repositories.Logbook
{
    public interface ILogbookReportDetailRepository
    {
        public Task<LogbookDetail> LogbookDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
