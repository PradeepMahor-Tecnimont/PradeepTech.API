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
    public class OFBApprovalDetailsDataTableListRepository : ViewTcmPLRepository<OFBApprovalDetailsDataTableList>, IOFBApprovalDetailsDataTableListRepository
    {
        public OFBApprovalDetailsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<OFBApprovalDetailsDataTableList>> OFBApprovalDetailsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_ofb_approval.fn_ofb_emp_apprl_status";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<OFBApprovalDetailsDataTableList>> OFBApprovalDetailsAllDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_ofb_approval.fn_ofb_emp_apprl_status_all";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

    }
}
