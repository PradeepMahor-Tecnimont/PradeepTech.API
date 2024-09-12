using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Attendance;


namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public interface IAttendanceExtrahoursClaimExistsRepository
    {
        public Task<ExtraHoursClaimExistsOutput> CheckClaimExistsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);


    }
}
