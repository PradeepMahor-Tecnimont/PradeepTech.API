using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLAPP.SendMail.WinService.Models;

namespace TCMPLAPP.SendMail.WinService.Repository
{

    public interface IMailQueueMailsTableListRepository
    {
        public Task<IEnumerable<MailQueueModel>> GetPendingMailsListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}