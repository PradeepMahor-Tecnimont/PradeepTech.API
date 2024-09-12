using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.BG;

namespace TCMPLApp.DataAccess.Repositories.BG
{
    public class BGRecipientsDataTableListRepository : ViewTcmPLRepository<BGRecipientsDataTableList>, IBGRecipientsDataTableListRepository
    {
        public BGRecipientsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<BGRecipientsDataTableList>> BGRecipientsDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.pkg_bg_common.fn_bg_recipient_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}