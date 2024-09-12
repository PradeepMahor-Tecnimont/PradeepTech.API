using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public interface ISWPAttendanceStatusForDayDataTableListRepository
    {
        public Task<IEnumerable<AttendanceStatusForDayDataTableList>> SWPAttendanceStatusForDayDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<AttendanceStatusForDayDataTableList>> SWPAttendanceStatusForPrevWorkDayDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}