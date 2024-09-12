using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public interface IEmployeeDeleteDataTableListRepository
    {       
        public Task<IEnumerable<EmployeeDeleteDataTableList>> GetEmployeeDeleteDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);                

    }
}
