using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class InvItemTypesDataTableListRepository : ViewTcmPLRepository<InvItemTypesDataTableList>, IInvItemTypesDataTableListRepository
    {
        public InvItemTypesDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<InvItemTypesDataTableList>> InvItemTypesDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_item_types_qry.fn_item_types";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<InvItemTypesDataTableList>> InvItemTypesDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_item_types_qry.fn_xl_item_types";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}