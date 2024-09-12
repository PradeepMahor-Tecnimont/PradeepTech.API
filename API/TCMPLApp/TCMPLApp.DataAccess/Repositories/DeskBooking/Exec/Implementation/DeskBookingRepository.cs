using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public class DeskBookingRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IDeskBookingRepository
    {
        public DeskBookingRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }
        public async Task<DBProcMessageOutput> ReleaseDeskAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbooking.sp_delete";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
