using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public interface ITimesheetStatusPartialDataTableListRepository
    {
        public Task<IEnumerable<TSStatusPartialDataTableList>> FilledStatusDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<TSStatusPartialDataTableList>> LockedStatusDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<TSStatusPartialDataTableList>> ApprovedStatusDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<TSStatusPartialDataTableList>> PostedStatusDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<TSStatusPartialDataTableList>> ProjectTimesheetStatusDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
