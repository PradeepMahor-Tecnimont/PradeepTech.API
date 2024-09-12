using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.WinService;

namespace TCMPLApp.DataAccess.Repositories.WinService
{

    public interface IWSQueueProcessesTableListRepository
    {
        public Task<IEnumerable<ProcessQueueModel>> GetPendingProcessesListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}