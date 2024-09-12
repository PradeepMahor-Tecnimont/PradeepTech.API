using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLAPP.SendMail.WinService.Models;

namespace TCMPLAPP.SendMail.WinService.Repository
{
    public interface IMailQueueMailsRepository
    {

        public Task<DBProcMessageOutput> UpdateSuccess(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> UpdateFailure(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }


}
