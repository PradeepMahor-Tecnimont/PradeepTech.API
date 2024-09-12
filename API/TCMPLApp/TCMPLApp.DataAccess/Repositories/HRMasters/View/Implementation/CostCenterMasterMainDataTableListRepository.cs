using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.HRMasters.View;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class CostCenterMasterMainDataTableListRepository : Base.ExecRepository, ICostCenterMasterMainDataTableListRepository
    {
        public CostCenterMasterMainDataTableListRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {

        }

        public async Task<IEnumerable<CostCenterMasterMainDataTableList>> CostCenterMasterMainDataTableListAsync(string p_EmpNo)
        {
            return await QueryAsync<CostCenterMasterMainDataTableList>(HRMastersQueries.CostCenterMasterMainDataTableList, new {p_EmpNo = p_EmpNo});
        }

        public async Task<IEnumerable<CostCenterMasterDownload>> GetCostcenterMasterDownload()
        {
            return await QueryAsync<CostCenterMasterDownload>(HRMastersQueries.CostCenterMasterDownload);
        }
    }
}
