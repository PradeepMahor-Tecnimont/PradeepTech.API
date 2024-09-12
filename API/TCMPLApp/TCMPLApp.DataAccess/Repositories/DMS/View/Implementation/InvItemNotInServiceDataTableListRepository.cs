using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DMS;
using TCMPLApp.Domain.Context;
using Microsoft.Extensions.Logging;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class InvItemNotInServiceDataTableListRepository : ViewTcmPLRepository<InvItemNotInServiceDataTableList>, IInvItemNotInServiceDataTableListRepository
    {
        public InvItemNotInServiceDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<InvItemNotInServiceDataTableList>> InvItemNotInServiceDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_item_exclude_qry.fn_item_exclude_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
