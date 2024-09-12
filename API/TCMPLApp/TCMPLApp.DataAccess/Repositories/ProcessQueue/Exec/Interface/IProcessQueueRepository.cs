using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.ProcessQueue
{
    public interface IProcessQueueRepository
    {
        public Task<DBProcMessageOutput> AddProcessQueue(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        
        public Task<DBProcMessageOutput> StartProcessQueue(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        
        public Task<DBProcMessageOutput> SuccessProcessQueue(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        
        public Task<DBProcMessageOutput> ErrorProcessQueue(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}