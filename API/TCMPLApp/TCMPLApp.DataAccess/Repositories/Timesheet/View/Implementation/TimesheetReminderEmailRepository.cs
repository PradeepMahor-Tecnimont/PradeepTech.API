using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public class TimesheetReminderEmailRepository : ViewTcmPLRepository<TSStatusReminderEmail>, ITimesheetReminderEmailRepository
    {
        public TimesheetReminderEmailRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<TSStatusReminderEmail> RemideremailDetails(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_status_qry.fn_get_reminder_mail_list";
            return await GetAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}