using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.HRMasters.View;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class HRUtilitiesRepository : Base.ExecRepository, IHRUtilitiesRepository
    {
        public HRUtilitiesRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {

        }

        public async Task<BulkHoDMngrUpdate> BulkHoDMngrEdit(BulkHoDMngrUpdate bulkHoDMngrUpdate)
        {
            var retval = await ExecuteProcAsync(bulkHoDMngrUpdate);
            return retval;
        }
    }
}
