using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DeskBooking;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public class AttendanceDateDataTableListRepository : ViewTcmPLRepository<AttendanceDateDataTableList>, IAttendanceDateDataTableListRepository
    {
        public AttendanceDateDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<AttendanceDateDataTableList>> AttendanceDateDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_autobook_preferences_qry.fn_db_autobook_4_calendar_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
