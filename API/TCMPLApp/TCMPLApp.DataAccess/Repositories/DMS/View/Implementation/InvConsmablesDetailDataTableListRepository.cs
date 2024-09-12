using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class InvConsumablesDetailDataTableListRepository : ViewTcmPLRepository<InvConsumablesDetailDataTableList>, IInvConsumablesDetailDataTableListRepository
    {
        public InvConsumablesDetailDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<InvConsumablesDetailDataTableList>> ConsumablesDetailDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_consumables_det_qry.fn_consumables_detail_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<InvConsumablesDetailDataTableList>> ConsumablesDetailDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_consumables_det_qry.fn_consumables_detail_excel_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}