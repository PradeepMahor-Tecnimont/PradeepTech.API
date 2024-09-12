using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public interface ISWPOfficeWorkspaceEmpAbsentDataTableListRepository
    {
        public Task<IEnumerable<OWSEmployeeAbsentDataTableList>> OWSAdminEmpAbsentList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<OWSEmployeeAbsentDataTableList>> OWSEmpAbsentList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}
