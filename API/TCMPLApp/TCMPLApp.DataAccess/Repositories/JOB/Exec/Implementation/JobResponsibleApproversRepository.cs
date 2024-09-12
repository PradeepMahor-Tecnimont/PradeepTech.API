using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public class JobResponsibleApproversRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IJobResponsibleApproversRepository
    {       
        public JobResponsibleApproversRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {

        }               
        
        public async Task<DBProcMessageOutput> UpdateResponsibleApproversAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_responsible_roles.sp_update_responsible_roles";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
