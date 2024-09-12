using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.ProcessQueue.View.Interface;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.ProcessQueue;

namespace TCMPLApp.DataAccess.Repositories.ProcessQueue.View.Implementation
{
    public class ProcessQueueDataTableListRepository : ViewTcmPLRepository<ProcessQueueDataTableList>, IProcessQueueDataTableListRepository
    {
        public ProcessQueueDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<ProcessQueueDataTableList>> ProcessQueueDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_app_process_queue.fn_get_emp_process_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}