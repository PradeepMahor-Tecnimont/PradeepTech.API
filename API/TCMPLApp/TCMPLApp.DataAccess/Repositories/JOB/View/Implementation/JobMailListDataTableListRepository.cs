using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public class JobMailListDataTableListRepository : ViewTcmPLRepository<JobMailListDataTableList>, IJobMailListDataTableListRepository
    {

        public JobMailListDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<JobMailListDataTableList>> JobMailListDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_mail_list_qry.fn_job_mail_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);                   
        }        
    }
}
