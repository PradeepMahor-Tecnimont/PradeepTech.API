using System;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;

namespace TCMPLApp.DataAccess.Base
{
    public interface IExecTcmPLRepository<Tin, Tout> : IDisposable
    {
        Task<Tout> ExecAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput);

        //Task<Tout> ExecCacheAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput, string[] tags);

        //Task<Tout> StorageValuedFunctionAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput);

        //Task<Tout> StorageValuedFunctionCacheAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput, string [] tags);
    }
}
