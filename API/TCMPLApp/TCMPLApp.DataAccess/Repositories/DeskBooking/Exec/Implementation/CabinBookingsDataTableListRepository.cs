using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Attendance;
using TCMPLApp.Domain.Context;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public class CabinBookingsDataTableListRepository : ViewTcmPLRepository<DataTable>, ICabinBookingsDataTableListRepository
    {
        public CabinBookingsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DataTable> CabinBookingList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_cabin_booking_qry.fn_cabin_book_calender";
            return await GetDataTableAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
