using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.RapReporting.Exec
{
    public class RapReportingReportsRepository : Base.ExecRepository, IRapReportingReportsRepository
    {
        public RapReportingReportsRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {

        }    

        
    }
}
