using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public interface IDeskAreaDepartmentMapDataTableListRepository
    {
        public Task<IEnumerable<DeskAreaDepartmentMapDataTableList>> DeskAreaDepartmentMapDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<DeskAreaDepartmentMapDataTableList>> DeskAreaDeptMapDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<DeskAreaDepartmentMapDataTableList>> DeskAreaDepartmentMapDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
