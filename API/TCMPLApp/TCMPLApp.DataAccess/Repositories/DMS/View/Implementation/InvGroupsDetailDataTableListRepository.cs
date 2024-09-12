using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class InvItemGroupDetailDataTableListRepository : ViewTcmPLRepository<InvItemGroupDetailDataTableList>, IInvItemGroupDetailDataTableListRepository
    {
        public InvItemGroupDetailDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<InvItemGroupDetailDataTableList>> ItemGroupDetailDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_item_group_det_qry.fn_item_group_detail_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        //public async Task<IEnumerable<InvItemGroupDetailDataTableList>> ItemGroupDetailDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        //{
        //    CommandText = "dms.pkg_inv_item_group_det_qry.fn_groups_detail_excel_list";
        //    return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        //}
    }
}