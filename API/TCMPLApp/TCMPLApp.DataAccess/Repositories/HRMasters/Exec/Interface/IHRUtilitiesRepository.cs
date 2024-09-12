using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.HRMasters.View;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public interface IHRUtilitiesRepository
    {        
        public Task<BulkHoDMngrUpdate> BulkHoDMngrEdit(BulkHoDMngrUpdate bulkHoDMngrUpdate);
    }
}
