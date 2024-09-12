using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.SWPVaccine;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public interface IHREmpPolicyManageRepository
    {
        public Task<IEnumerable<SwpVuEmpResponse>> GetPendingApprovalList(string userWinUid, string FilterBy, string FilterByDept);

        public IEnumerable<DataField> GetHRfilterListForDropDown();

        public Task<IEnumerable<DataField>> GetDeptListForDropDown();

        public Task<ProcedureResult> Reject(string empNo, string win_Hr_Uid);

        public Task<ProcedureResult> Approve(string jSon, string win_Hr_Uid);

        public Task<ProcedureResult> Reset(string empNo, string win_Hr_Uid);

        public dynamic GetdataTable(string userWinUid, string FilterBy, string FilterByDept);
    }
}