using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.JOB;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class InternalTransfersDataTableListRepository : ViewTcmPLRepository<InternalTransferDataTableList>, IInternalTransfersDataTableListRepository
    {
        public InternalTransfersDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<InternalTransferDataTableList>> InternalTransferDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_transfers_qry.fn_all_emp_list_hr";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
