using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public class JobFormListReportExcelRepository : ViewTcmPLRepository<JobformListReportExcel>, IJobFormListReportExcelRepository
    {
        public JobFormListReportExcelRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<JobformListReportExcel>> JobFormListReportExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_reports.fn_jobs_list_report";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }        
    }
}
