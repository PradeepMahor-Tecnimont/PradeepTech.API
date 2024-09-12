using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public interface IInvItemGroupDetailRepository
    {
        public Task<InvItemGroupDetail> ItemGroupDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}