using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DeskBooking;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public interface ICrossBookingSummaryXLListRepository
    {
        public Task<IEnumerable<CrossBookingSummaryDataTableListXL>> CrossBookingSummaryXLForDmsListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<CrossBookingSummaryDataTableListXL>> CrossBookingSummaryXLForHodListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}