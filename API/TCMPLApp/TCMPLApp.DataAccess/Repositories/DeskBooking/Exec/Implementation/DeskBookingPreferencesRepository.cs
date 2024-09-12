using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;
using Microsoft.Extensions.Logging;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public class DeskBookingPreferencesRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IDeskBookingPreferencesRepository
    {
        public DeskBookingPreferencesRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> DeskBookingPreferencesCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_autobook_preferences.sp_add_db_autobook_preferences";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> DeskBookingPreferencesEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_autobook_preferences.sp_update_db_autobook_preferences";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
