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
    public class OFBDeptmntExitApprovalsDataTableListRepository : ViewTcmPLRepository<OffBoardingEmployeeExitApprovals>, IOFBDeptmntExitApprovalsDataTableListRepository
    {
        public OFBDeptmntExitApprovalsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<OffBoardingEmployeeExitApprovals>> DeptmntExitApprovalsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_ofb_exits_print_qry.fn_deptmnt_exit_approvals_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}