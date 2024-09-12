using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.OffBoarding;

namespace TCMPLApp.DataAccess.Repositories.OffBoarding
{
    public class OFBApprovalsXLDataTableListRepository : ViewTcmPLRepository<OFBApprovalsXLDataTableList>, IOFBApprovalsXLDataTableListRepository
    {
        public OFBApprovalsXLDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<OFBApprovalsXLDataTableList>> OFBApprovalsDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_ofb_approval_list.fn_all_XL";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}