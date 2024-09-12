using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;


namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public interface IAttendanceLeaveClaimCreateRepository
    {
        public Task<DBProcMessageOutput> CreateLeaveClaimAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);


    }
}
