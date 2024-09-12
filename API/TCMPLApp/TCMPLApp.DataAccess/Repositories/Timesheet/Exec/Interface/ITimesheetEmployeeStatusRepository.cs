using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public interface ITimesheetEmployeeStatusRepository
    {
        public Task<DBProcMessageOutput> TimeSheetStatusUpdateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

       
    }
}