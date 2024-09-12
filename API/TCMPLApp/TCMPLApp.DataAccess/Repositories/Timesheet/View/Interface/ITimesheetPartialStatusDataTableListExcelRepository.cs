using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public interface ITimesheetPartialStatusDataTableListExcelRepository
    {
        public Task<IEnumerable<TSPartialStatusDataTableListExcel>> TimesheetPartialFilledDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<TSPartialStatusDataTableListExcel>> TimesheetPartialLockedDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
                
        public Task<IEnumerable<TSPartialStatusDataTableListExcel>> TimesheetPartialApprovedDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<TSPartialStatusDataTableListExcel>> TimesheetPartialPostedDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<TSPartialStatusDataTableListExcel>> TimesheetProjectDetailPartialDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}
