using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DeskBooking;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public interface IDeskBookingAttendanceStatusDataTableListRepository
    {
        public Task<IEnumerable<DeskBookingAttendanceStatusDataTableList>> DeskBookAttendanceStatusDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<DeskBookingAttendanceStatusDataTableList>> DeskBookAttendanceStatusHistoryDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<DeskBookingAttendanceStatusDataTableList>> DeskBookAttendanceStatusXLDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<DeskBookingAttendanceStatusDataTableList>> DeskBookAttendanceStatusHistoryXLDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}
