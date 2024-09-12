using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public interface IDeskBookingAttendanceRepository
    {
        public Task<DBProcMessageOutput> AttendanceReleaseDeskAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
