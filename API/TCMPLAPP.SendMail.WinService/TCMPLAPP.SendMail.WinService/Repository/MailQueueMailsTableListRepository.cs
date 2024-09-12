using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLAPP.SendMail.WinService.Models;

namespace TCMPLAPP.SendMail.WinService.Repository
{

    public class MailQueueMailsTableListRepository : Context.ViewTcmPLRepository<MailQueueModel>, IMailQueueMailsTableListRepository
    {
        public MailQueueMailsTableListRepository(ILogger<Context.ViewTcmPLContext> logger, IServiceScopeFactory scopeFactory) : base(logger, scopeFactory)
        {

        }
        public async Task<IEnumerable<MailQueueModel>> GetPendingMailsListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_app_mail_queue.fn_mails_pending";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }


}
