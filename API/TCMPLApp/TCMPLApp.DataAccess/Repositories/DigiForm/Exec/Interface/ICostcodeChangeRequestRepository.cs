using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.DigiForm
{
    public interface ICostcodeChangeRequestRepository
    {
        public Task<DBProcMessageOutput> CostcodeChangeRequestCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DBProcMessageOutput> CostcodeChangeRequestEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DBProcMessageOutput> CostcodeChangeRequestReturnAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DBProcMessageOutput> CostcodeChangeRequestHoDApprovalAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DBProcMessageOutput> CostcodeChangeRequestHRApprovalAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DBProcMessageOutput> CostcodeChangeRequestHODPostApprovalAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
