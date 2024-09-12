using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.HRMasters.View;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class CostCenterMasterMainRepository : Base.ExecRepository, ICostCenterMasterMainRepository
    {
        public CostCenterMasterMainRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {

        }

        public async Task<CostCenterMasterMain> CostCenterMasterMainDetailAsync(string p_CostCodeId, string p_EmpNo)
        {
            return await QueryFirstOrDefaultAsync<CostCenterMasterMain>(HRMastersQueries.CostCenterMasterMainDetail, new { p_CostCodeId = p_CostCodeId, p_EmpNo = p_EmpNo } );
        }

        public async Task<CostCenterMasterHoD> CostCenterMasterHoDDetailAsync(string p_CostCodeId, string p_EmpNo)
        {
            return await QueryFirstOrDefaultAsync<CostCenterMasterHoD>(HRMastersQueries.CostCenterMasterHoDDetail, new { p_CostCodeId = p_CostCodeId, p_EmpNo = p_EmpNo });
        }

        public async Task<CostCenterMasterCostControl> CostCenterMasterCostControlDetailAsync(string p_CostCodeId, string p_EmpNo)
        {
            return await QueryFirstOrDefaultAsync<CostCenterMasterCostControl>(HRMastersQueries.CostCenterMasterCostControlDetail, new { p_CostCodeId = p_CostCodeId, p_EmpNo = p_EmpNo });
        }

        public async Task<CostCenterMasterAFC> CostCenterMasterAFCDetailAsync(string p_CostCodeId, string p_EmpNo)
        {
            return await QueryFirstOrDefaultAsync<CostCenterMasterAFC>(HRMastersQueries.CostCenterMasterAFCDetail, new { p_CostCodeId = p_CostCodeId, p_EmpNo = p_EmpNo });
        }
    }
}
