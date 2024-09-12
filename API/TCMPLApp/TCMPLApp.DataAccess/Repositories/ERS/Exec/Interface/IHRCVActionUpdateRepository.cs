using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.ERS
{
    public interface IHRCVActionUpdateRepository
    {
        #region CV action update
        public Task<DBProcMessageOutput> CVActionUpdate(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        #endregion CV action update

    }
}
