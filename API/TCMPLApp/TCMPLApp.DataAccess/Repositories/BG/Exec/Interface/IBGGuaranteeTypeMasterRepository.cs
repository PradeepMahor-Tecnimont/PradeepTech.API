using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.BG
{
    public interface IBGGuaranteeTypeMasterRepository
    {
        public Task<DBProcMessageOutput> BGGuaranteeTypeMasterCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> BGGuaranteeTypeMasterEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> BGGuaranteeTypeMasterDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}