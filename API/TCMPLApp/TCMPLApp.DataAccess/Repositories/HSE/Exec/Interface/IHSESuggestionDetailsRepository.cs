using System.Threading.Tasks;

using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.HSE;

namespace TCMPLApp.DataAccess.Repositories.HSE
{
    public interface IHSESuggestionDetailsRepository
    {
        public Task<HSESuggestionDetailsOut> HSESuggestionDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}