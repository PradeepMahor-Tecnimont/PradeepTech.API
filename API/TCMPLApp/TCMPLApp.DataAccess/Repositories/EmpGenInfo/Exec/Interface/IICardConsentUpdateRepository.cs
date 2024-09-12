using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public interface IICardConsentUpdateRepository
    {
        public Task<DBProcMessageOutput> IcardConsentUpdateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}