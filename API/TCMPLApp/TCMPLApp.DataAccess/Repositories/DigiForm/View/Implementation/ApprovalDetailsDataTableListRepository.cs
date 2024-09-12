using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.OffBoarding;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DigiForm;
using TCMPLApp.Domain.Models.OffBoarding;

namespace TCMPLApp.DataAccess.Repositories.DigiForm
{
    public class ApprovalDetailsDataTableListRepository : ViewTcmPLRepository<ApprovalDetailsDataTableList>, IApprovalDetailsDataTableListRepository
    {
        public ApprovalDetailsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<ApprovalDetailsDataTableList>> ApprovalDetailsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.fn_get_apprl_status";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<ApprovalDetailsDataTableList>> ExtensionDetailsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.fn_get_extension_details";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
