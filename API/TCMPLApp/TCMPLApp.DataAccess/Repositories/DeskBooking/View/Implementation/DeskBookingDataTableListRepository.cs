using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DeskBooking;
namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public class DeskBookingDataTableListRepository : ViewTcmPLRepository<DeskBookingDataTableList>, IDeskBookingDataTableListRepository
    {
        public DeskBookingDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<DeskBookingDataTableList>> DeskBookingDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbooking_qry.fn_emp_desk_book_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
