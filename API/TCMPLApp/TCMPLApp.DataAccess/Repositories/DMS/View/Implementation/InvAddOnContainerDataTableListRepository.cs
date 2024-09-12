using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class InvAddOnContainerDataTableListRepository : ViewTcmPLRepository<InvAddOnContainerDataTableList>, IInvAddOnContainerDataTableListRepository
    {
        public InvAddOnContainerDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<InvAddOnContainerDataTableList>> InvAddOnContainerDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_addon_container_qry.fn_addon_container_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<InvAddOnContainerDataTableList>> InvAddOnContainerDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_addon_container_qry.fn_addon_container_excel";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
