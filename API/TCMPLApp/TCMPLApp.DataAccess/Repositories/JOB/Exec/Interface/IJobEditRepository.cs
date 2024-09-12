using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;


namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public interface IJobEditRepository
    {        
        public Task<DBProcMessageOutput> UpdateJobAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}
