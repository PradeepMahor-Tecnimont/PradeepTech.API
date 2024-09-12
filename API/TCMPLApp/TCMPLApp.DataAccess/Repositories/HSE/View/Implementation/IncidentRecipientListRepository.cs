using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.HSE;

namespace TCMPLApp.DataAccess.Repositories.HSE
{
    public class IncidentRecipientListRepository : ViewTcmPLRepository<IncidentMailsendList>, IIncidentRecipientListRepository
    {

        public IncidentRecipientListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<IncidentMailsendList>> IncidentRecipientList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_hse_qry.fn_email_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
