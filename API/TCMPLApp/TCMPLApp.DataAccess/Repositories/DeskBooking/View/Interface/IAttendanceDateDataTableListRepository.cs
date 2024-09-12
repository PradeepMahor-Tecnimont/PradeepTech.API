using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DeskBooking;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public interface IAttendanceDateDataTableListRepository
    {
        public Task<IEnumerable<AttendanceDateDataTableList>> AttendanceDateDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}
