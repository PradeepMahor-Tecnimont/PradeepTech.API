using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public interface IFlexiToDMSRepository
    {
        public Task<DBProcMessageOutput> ImportFlexiDeskToDMSJSonAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> FlexiToDMSAddAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> FlexiToDMSRollbackAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        
    }
}