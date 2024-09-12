using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.CoreSettings;

namespace TCMPLApp.DataAccess.Repositories.CoreSettings
{
    public interface IModuleRolesDetailRepository
    {
        public Task<ModuleRolesDetails> ModuleRolesDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
