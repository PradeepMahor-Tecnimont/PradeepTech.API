using System.Data;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.RapReporting.Exec;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public interface ITSShiftProjectManhoursReportRepository
    {
        public Task<TSShiftProjectManhoursExcel> TSShiftProjectManhoursReport(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
