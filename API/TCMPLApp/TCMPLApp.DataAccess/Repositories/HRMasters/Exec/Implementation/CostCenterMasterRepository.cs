using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class CostCenterMasterRepository : Base.ExecRepository, ICostCenterMasterRepository
    {
        public CostCenterMasterRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {

        }    

        public async Task<CostCenterMasterMainCreate> CostCenterMasterMainCreate(CostCenterMasterMainCreate costCenterMasterMainCreate)
        {
            var retval = await ExecuteProcAsync(costCenterMasterMainCreate);
            return retval;
        }

        public async Task<CostCenterMasterMainUpdate> CostCenterMasterMainUpdate(CostCenterMasterMainUpdate costCenterMasterMainUpdate)
        {
            var retval = await ExecuteProcAsync(costCenterMasterMainUpdate);
            return retval;
        }

        public async Task<CostCenterMasterDeactivate> CostCenterMasterDeactivate(CostCenterMasterDeactivate costCenterMasterDeactivate)
        {
            return await ExecuteProcAsync(costCenterMasterDeactivate);
        }

        public async Task<CostCenterMasterHoDUpdate> CostCenterMasterHoDUpdate(CostCenterMasterHoDUpdate costCenterMasterHoDUpdate)
        {
            var retval = await ExecuteProcAsync(costCenterMasterHoDUpdate);
            return retval;
        }

        public async Task<CostCenterMasterCostControlUpdate> CostCenterMasterCostControlUpdate(CostCenterMasterCostControlUpdate costCenterMasterCostControlUpdate)
        {
            var retval = await ExecuteProcAsync(costCenterMasterCostControlUpdate);
            return retval;
        }

        public async Task<CostCenterMasterAFCUpdate> CostCenterMasterAFCUpdate(CostCenterMasterAFCUpdate costCenterMasterAFCUpdate)
        {
            var retval = await ExecuteProcAsync(costCenterMasterAFCUpdate);
            return retval;
        }
    }
}
