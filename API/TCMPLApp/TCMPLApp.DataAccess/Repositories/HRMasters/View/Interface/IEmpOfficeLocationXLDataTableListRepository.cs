using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DMS;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public interface IEmpOfficeLocationXLDataTableListRepository
    {
        public Task<IEnumerable<EmpOfficeLocationXLDataTableList>> EmpOfficeLocationDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}
