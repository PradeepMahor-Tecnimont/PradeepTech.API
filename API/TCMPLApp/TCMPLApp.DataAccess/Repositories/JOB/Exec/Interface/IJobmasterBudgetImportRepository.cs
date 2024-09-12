using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public interface IJobmasterBudgetImportRepository
    {
        #region Job Budget Import        

        public Task<JobBudgetImportOutput> ImportJobBudgetAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        #endregion Job Budget Import  
    }
}
