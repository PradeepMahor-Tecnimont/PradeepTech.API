using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.Domain.Models.SWPVaccine;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class SWPCheckDetailsRepository : DataAccess.Base.ExecRepository ,  ISWPCheckDetailsRepository
    {
        public SWPCheckDetailsRepository(TCMPLApp.Domain.Context.ExecDBContext execDBContext ) : base(execDBContext)
        {
        }

        public async Task<SWPCheckDetails> CheckDetails(SWPCheckDetails swpCheckDetails)
        {
            return await ExecuteProcAsync(swpCheckDetails);
        }
    }
}
