using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.MailQueue;


namespace TCMPLApp.DataAccess.Repositories.MailQueue
{
    public interface IMailQueueMailsRepository
    {
        public Task<IEnumerable<MailQueueMails>> MailQueuePendingMailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
