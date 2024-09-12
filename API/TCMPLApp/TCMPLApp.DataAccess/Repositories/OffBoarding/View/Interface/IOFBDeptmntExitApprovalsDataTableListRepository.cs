using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.OffBoarding;

namespace TCMPLApp.DataAccess.Repositories.OffBoarding
{
    public interface IOFBDeptmntExitApprovalsDataTableListRepository
    {
        public Task<IEnumerable<OffBoardingEmployeeExitApprovals>> DeptmntExitApprovalsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}