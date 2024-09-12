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
    public class FlexiToDMSDataTableListRepository : ViewTcmPLRepository<FlexiToDMSDataTableList>, IFlexiToDMSDataTableListRepository
    {
        public FlexiToDMSDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<FlexiToDMSDataTableList>> FlexiToDMSDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_movement_qry.fn_flexi_to_dms_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}