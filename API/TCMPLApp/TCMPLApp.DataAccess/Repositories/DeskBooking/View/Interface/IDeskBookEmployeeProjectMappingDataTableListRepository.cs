using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DeskBooking;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public interface IDeskBookEmployeeProjectMappingDataTableListRepository
    {
        public Task<IEnumerable<DeskBookEmployeeProjectMappingDataTableList>> DeskBookEmployeeProjectMappingDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}
