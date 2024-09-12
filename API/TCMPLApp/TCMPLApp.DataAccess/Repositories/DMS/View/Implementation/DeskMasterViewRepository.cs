using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class DeskMasterViewRepository : Base.ExecRepository, IDeskMasterViewRepository
    {
        public DeskMasterViewRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {
            
        }
        

    }
}
