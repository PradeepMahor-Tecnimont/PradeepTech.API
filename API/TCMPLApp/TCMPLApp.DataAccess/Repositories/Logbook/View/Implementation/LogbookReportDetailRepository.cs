using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Logbook;

namespace TCMPLApp.DataAccess.Repositories.Logbook
{
    public class LogbookReportDetailRepository : ViewTcmPLRepository<LogbookDetail>, ILogbookReportDetailRepository
    {
        public LogbookReportDetailRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<LogbookDetail> LogbookDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "logbook1.pkg_logbook_report.fn_get_report_detail";
            return await GetAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
