using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public interface IManageRepository
    {
        public Task<DBProcMessageOutput> RePostAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> MoveMonthAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> UpdateEmployeeAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> LockRepostAndUpdateProcessingMonth(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> UnLockRepostAndUpdateProcessingMonth(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> MonthStatusAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}