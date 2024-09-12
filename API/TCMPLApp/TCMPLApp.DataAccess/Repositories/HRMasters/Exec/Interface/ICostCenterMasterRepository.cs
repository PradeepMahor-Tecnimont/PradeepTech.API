using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public interface ICostCenterMasterRepository
    {             
        public Task<CostCenterMasterMainCreate> CostCenterMasterMainCreate(CostCenterMasterMainCreate costCenterMasterMainCreate);
       
        public Task<CostCenterMasterMainUpdate> CostCenterMasterMainUpdate(CostCenterMasterMainUpdate costCenterMasterMainUpdate);
        
        public Task<CostCenterMasterDeactivate> CostCenterMasterDeactivate(CostCenterMasterDeactivate costCenterMasterDeactivate);
        
        public Task<CostCenterMasterHoDUpdate> CostCenterMasterHoDUpdate(CostCenterMasterHoDUpdate costCenterMasterHoDUpdate);
        
        public Task<CostCenterMasterCostControlUpdate> CostCenterMasterCostControlUpdate(CostCenterMasterCostControlUpdate costCenterMasterCostControlUpdate);
        
        public Task<CostCenterMasterAFCUpdate> CostCenterMasterAFCUpdate(CostCenterMasterAFCUpdate costCenterMasterAFCUpdate);

    }
}
