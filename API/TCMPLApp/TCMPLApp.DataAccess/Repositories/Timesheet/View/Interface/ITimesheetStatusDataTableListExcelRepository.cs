using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public interface ITimesheetStatusDataTableListExcelRepository
    {
        public Task<IEnumerable<TSStatusDataTableListExcel>> EmployeeStatusDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<TSStatusDataTableListExcel>> EmployeeLockedDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<TSStatusDataTableListExcel>> EmployeeApprovedDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<TSStatusDataTableListExcel>> EmployeePostedDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<TSStatusDataTableListExcel>> EmployeeNotfilledDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
