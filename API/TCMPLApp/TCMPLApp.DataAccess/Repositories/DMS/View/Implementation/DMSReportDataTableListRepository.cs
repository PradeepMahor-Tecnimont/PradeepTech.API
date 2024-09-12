using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class DMSReportDataTableListRepository : ViewTcmPLRepository<DataTable>, IDMSReportDataTableListRepository
    {
        public DMSReportDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DataTable> DeskManagementStatusExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_reports.fn_desk_management_status_list";
            return await GetDataTableAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}