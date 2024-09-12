using System;
using System.Threading.Tasks;
using TCMPLAPP.SendMail.WinService.Models;

namespace TCMPLAPP.SendMail.WinService.Context
{
    public interface IExecTcmPLRepository<Tin, Tout> : IDisposable
    {
        Task<Tout> ExecAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput);

        //Task<Tout> ExecCacheAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput, string[] tags);

        //Task<Tout> StorageValuedFunctionAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput);

        //Task<Tout> StorageValuedFunctionCacheAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput, string [] tags);
    }
}
