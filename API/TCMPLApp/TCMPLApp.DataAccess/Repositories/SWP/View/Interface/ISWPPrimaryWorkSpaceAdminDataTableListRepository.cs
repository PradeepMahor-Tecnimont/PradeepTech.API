using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public interface ISWPPrimaryWorkSpaceAdminDataTableListRepository
    {
        public Task<IEnumerable<PrimaryWorkSpaceForAdminDataTableList>> PrimaryWorkSpaceForAdminDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<PrimaryWorkSpaceForAdminDataTableList>> PrimaryWorkSpaceDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}