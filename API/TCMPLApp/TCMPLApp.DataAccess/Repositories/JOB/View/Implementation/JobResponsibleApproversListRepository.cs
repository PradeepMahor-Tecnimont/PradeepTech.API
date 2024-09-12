using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public class JobResponsibleApproversListRepository : ViewTcmPLRepository<JobResponsibleApproversList>, IJobResponsibleApproversListRepository
    {

        public JobResponsibleApproversListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<JobResponsibleApproversList>> JobResponsibleApproversList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_responsible_roles_qry.fn_job_responsible_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);                   
        }        
    }
}
