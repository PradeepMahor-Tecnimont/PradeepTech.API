using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DeskBooking;


namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public interface IDeskAreaUserMapHodDataTableListRepository
    {
        public Task<IEnumerable<DeskAreaUserMapHodDataTableList>> DeskAreaUserMapDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<DeskAreaUserMapHodDataTableList>> DeskAreaUserMapDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}