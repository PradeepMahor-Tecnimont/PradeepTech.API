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
    public class JobmasterDataTableListRepository : ViewTcmPLRepository<JobmasterDataTableList>, IJobmasterDataTableListRepository
    {

        public JobmasterDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<JobmasterDataTableList>> JobmasterDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_qry.fn_jobs_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);                   
        }

        public async Task<IEnumerable<JobmasterDataTableList>> PendingApprovalsCMDDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_approvals_qry.fn_get_cmd_approvals_pending";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<JobmasterDataTableList>> PendingApprovalsAFCDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_approvals_qry.fn_get_afc_approvals_pending";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<JobmasterDataTableList>> PendingApprovalsJSDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_approvals_qry.fn_get_js_approvals_pending";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}