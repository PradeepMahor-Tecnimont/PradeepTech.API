using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.JOB;
using TCMPLApp.Domain.Models.JOB.View;

namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public interface IJobApproverStatusDetailRepository
    {  
        public Task<JobApproverStatus> ApproverStatusDetailAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}
