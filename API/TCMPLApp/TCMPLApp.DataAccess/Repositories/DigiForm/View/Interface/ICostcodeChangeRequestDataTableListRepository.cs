using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DigiForm;

namespace TCMPLApp.DataAccess.Repositories.DigiForm
{
    public interface ICostcodeChangeRequestDataTableListRepository
    {
        public Task<IEnumerable<CostcodeChangeRequestDataTableList>> CostcodeChangeRequestDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<CostcodeChangeRequestDataTableList>> HodApprovalsRequestsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<CostcodeChangeRequestDataTableList>> HodHistoryApprovalsRequestsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<CostcodeChangeRequestDataTableList>> HrHistoryApprovalsRequestsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<CostcodeChangeRequestDataTableList>> HrApprovedApprovalsRequestsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<CostcodeChangeRequestDataTableList>> HRApprovalsRequestsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<CostcodeChangeRequestDataTableList>> TemporaryEmployeesDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<CostcodeChangeRequestDataTableList>> HodTransferEmployeesDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<CostcodeChangeRequestDataTableList>> HrTransferEmployeesDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<CostcodeChangeRequestDataTableList>> HrTransferCostcodeExcelDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}
