using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLAPP.SendMail.WinService.Models;

namespace TCMPLAPP.SendMail.WinService.Repository
{


    public class MailQueueMailsRepository : Context.ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IMailQueueMailsRepository
    {
        public MailQueueMailsRepository(ILogger<Context.ExecTcmPLContext> logger, IServiceScopeFactory scopeFactory) : base(logger, scopeFactory)
        {
        }

        public async Task<DBProcMessageOutput> UpdateSuccess(
        BaseSpTcmPL baseSpTcmPL,
        ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_app_mail_queue.sp_update_mail_status_success";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> UpdateFailure(
        BaseSpTcmPL baseSpTcmPL,
        ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_app_mail_queue.sp_update_mail_status_error";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
