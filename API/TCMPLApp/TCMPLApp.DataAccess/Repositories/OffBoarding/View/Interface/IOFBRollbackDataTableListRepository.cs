using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.OffBoarding;

namespace TCMPLApp.DataAccess.Repositories.OffBoarding
{
    public interface IOFBRollbackDataTableListRepository
    {
        public Task<IEnumerable<OFBRollbackDataTableList>> RollbackPendingDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<OFBRollbackDataTableList>> RollbackHistoryDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<OFBRollbackDataTableList>> RollbackXLPendingDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<OFBRollbackDataTableList>> RollbackXLHistoryDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}