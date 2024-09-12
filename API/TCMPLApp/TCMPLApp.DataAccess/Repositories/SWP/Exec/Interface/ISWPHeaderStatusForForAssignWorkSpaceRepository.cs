using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Attendance;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public interface ISWPHeaderStatusForPrimaryWorkSpaceRepository
    {
        public Task<SWPHeaderStatusForPrimaryWorkSpaceOutput> HeaderStatusForPrimaryWorkSpaceAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<SWPHeaderStatusForPrimaryWorkSpaceOutput> HeaderStatusForPrimaryWorkSpacePlanningAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}