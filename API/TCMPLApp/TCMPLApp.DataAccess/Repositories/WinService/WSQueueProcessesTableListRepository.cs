using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.WinService;

namespace TCMPLApp.DataAccess.Repositories.WinService
{

    public class WSQueueProcessesTableListRepository : ViewTcmPLRepository<ProcessQueueModel>, IWSQueueProcessesTableListRepository
    {
        public WSQueueProcessesTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<ProcessQueueModel>> GetPendingProcessesListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_app_process_queue.fn_get_pending_process_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }


}
