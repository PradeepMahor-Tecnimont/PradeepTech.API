using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class InvItemAsgmtTypesDataTableListRepository : ViewTcmPLRepository<InvItemAsgmtTypesDataTableList>, IInvItemAsgmtTypesDataTableListRepository
    {
        public InvItemAsgmtTypesDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<InvItemAsgmtTypesDataTableList>> InvItemAsgmtTypesDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_item_asgmt_types_qry.fn_item_asgmt_types";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<InvItemAsgmtTypesDataTableList>> InvItemAsgmtTypesDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_item_asgmt_types_qry.fn_xl_item_asgmt_types";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}