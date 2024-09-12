using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DeskBooking;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public interface IDeskBookCabinBookingsDataTableListRepository
    {
        public Task<IEnumerable<DeskBookCabinBookingDataTableList>> CabinBookingsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<DeskBookCabinBookingDataTableList>> MyCabinBookingsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<DeskBookCabinBookingDataTableList>> MyCabinBookingsXLDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<DeskBookCabinBookingDataTableList>> AllCabinBookingsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<DeskBookCabinBookingDataTableList>> AllCabinBookingsXLDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
