using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public interface IJobmasterDetailRepository
    {
        #region Job Master Detail
        public Task<JobmasterMainDetailOut> JobmasterDetailMain(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        #endregion Job Master Detail

    }
}
