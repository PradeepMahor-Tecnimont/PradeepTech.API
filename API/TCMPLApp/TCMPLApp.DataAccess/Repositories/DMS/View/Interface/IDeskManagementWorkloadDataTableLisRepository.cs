using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS

{
    public interface IDeskManagementWorkloadDataTableLisRepository
    {
        Task<IEnumerable<DeskManagementWorkloadDataTableList>> DeskManagementWorkloadDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        Task<IEnumerable<DeskManagementWorkloadDataTableList>> DeskManagementWorkloadDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}