using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.HRMasters.View;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public interface ICostCenterMasterMainRepository
    {              
        Task<CostCenterMasterMain> CostCenterMasterMainDetailAsync(string p_CostCodeId, string p_EmpNo);

        Task<CostCenterMasterHoD> CostCenterMasterHoDDetailAsync(string p_CostCodeId, string p_EmpNo);

        Task<CostCenterMasterCostControl> CostCenterMasterCostControlDetailAsync(string p_CostCodeId, string p_EmpNo);
        
        Task<CostCenterMasterAFC> CostCenterMasterAFCDetailAsync(string p_CostCodeId, string p_EmpNo);

    }
}
