using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.MailQueue;

namespace TCMPLApp.DataAccess.Repositories.MailQueue
{
    public class MailQueueMailsRepository : ViewTcmPLRepository<MailQueueMails>, IMailQueueMailsRepository
    {
        public MailQueueMailsRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }

        public async Task<IEnumerable<MailQueueMails>> MailQueuePendingMailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_app_mail_queue.fn_mails_pending";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);

        }

    }
}