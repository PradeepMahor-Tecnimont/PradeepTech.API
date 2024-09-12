using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public interface ITimesheetFreezeStatusRepository
    {
        public Task<TSFreezeStatus> FreezeStatusAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

       
    }
}