using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.ProcessQueue;

namespace TCMPLApp.DataAccess.Repositories.ProcessQueue.View.Interface
{
    public interface IProcessQueueDataTableListRepository
    {
        public Task<IEnumerable<ProcessQueueDataTableList>> ProcessQueueDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}