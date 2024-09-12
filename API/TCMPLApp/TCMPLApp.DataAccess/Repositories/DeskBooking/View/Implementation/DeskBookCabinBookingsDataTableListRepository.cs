using DocumentFormat.OpenXml.Spreadsheet;
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
    public class DeskBookCabinBookingsDataTableListRepository : ViewTcmPLRepository<DeskBookCabinBookingDataTableList>, IDeskBookCabinBookingsDataTableListRepository
    {
        public DeskBookCabinBookingsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<DeskBookCabinBookingDataTableList>> CabinBookingsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_cabin_booking_qry.fn_emp_cabin_book_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<DeskBookCabinBookingDataTableList>> MyCabinBookingsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_cabin_booking_qry.fn_cabin_booking_list_for_hod";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<DeskBookCabinBookingDataTableList>> MyCabinBookingsXLDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_cabin_booking_qry.fn_cabin_booking_list_for_hod_xl";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<DeskBookCabinBookingDataTableList>> AllCabinBookingsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_cabin_booking_qry.fn_cabin_booking_list_for_admin";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<DeskBookCabinBookingDataTableList>> AllCabinBookingsXLDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_cabin_booking_qry.fn_cabin_booking_list_for_admin_xl";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
