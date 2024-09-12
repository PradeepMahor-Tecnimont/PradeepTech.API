using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.SWPVaccine;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public interface IHoDEmpPolicyManageRepository
    {
        public Task<IEnumerable<SwpVuEmpResponse>> GetPendingApprovalList(string userWinUid, string FilterBy);

        public IEnumerable<DataField> GetHodfilterListForDropDown();

        public Task<ProcedureResult> Reject(string empNo, string Win_Hod_Uid);

        public Task<ProcedureResult> Approve(string jSon, string Win_Hod_Uid);
    }
}