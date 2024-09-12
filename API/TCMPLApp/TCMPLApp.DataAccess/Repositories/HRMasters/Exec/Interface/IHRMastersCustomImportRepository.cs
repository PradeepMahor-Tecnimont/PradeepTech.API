using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public interface IHRMastersCustomImportRepository
    {
        public Task<HRMastersCustomImportOutput> ImportHRMastersCustomAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        
    }
}
