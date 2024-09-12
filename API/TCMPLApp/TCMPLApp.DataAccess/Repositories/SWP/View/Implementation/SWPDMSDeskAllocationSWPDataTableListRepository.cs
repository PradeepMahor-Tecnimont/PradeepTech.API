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

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class SWPDMSDeskAllocationSWPDataTableListRepository : ViewTcmPLRepository<DeskAllocationSWPDataTableList>, ISWPDMSDeskAllocationSWPDataTableListRepository
    {
        public SWPDMSDeskAllocationSWPDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<DeskAllocationSWPDataTableList>> DeskAllocationSWPList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.IOT_SWP_DMS_REP_QRY.fn_deskallocation_swp";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);

        }

    }
}
