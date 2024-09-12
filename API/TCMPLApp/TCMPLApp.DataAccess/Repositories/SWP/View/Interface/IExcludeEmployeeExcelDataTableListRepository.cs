using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public interface IExcludeEmployeeExcelDataTableListRepository
    {
        public Task<IEnumerable<ExcludeEmployeeExcelDataTableList>> ExcludeEmployeeExcelDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}