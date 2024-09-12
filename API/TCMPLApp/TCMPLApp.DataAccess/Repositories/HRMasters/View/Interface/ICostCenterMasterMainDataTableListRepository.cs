using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.HRMasters.View;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public interface ICostCenterMasterMainDataTableListRepository
    {              
        public Task<IEnumerable<CostCenterMasterMainDataTableList>> CostCenterMasterMainDataTableListAsync(string p_EmpNo);

        public Task<IEnumerable<CostCenterMasterDownload>> GetCostcenterMasterDownload();

    }
}
