using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public interface ICabinBookingsDataTableListRepository
    {
        public Task<DataTable> CabinBookingList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
