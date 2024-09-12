using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;


namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public interface IJobPmJsRepository
    {        
        public Task<DBProcMessageOutput> UpdatePmJsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}
