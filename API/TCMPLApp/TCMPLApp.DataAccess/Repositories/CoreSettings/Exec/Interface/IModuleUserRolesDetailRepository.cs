using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.CoreSettings;

namespace TCMPLApp.DataAccess.Repositories.CoreSettings
{
    public interface IModuleUserRolesDetailRepository
    {
        public Task<ModuleUserRolesDetails> ModuleUserRolesDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
