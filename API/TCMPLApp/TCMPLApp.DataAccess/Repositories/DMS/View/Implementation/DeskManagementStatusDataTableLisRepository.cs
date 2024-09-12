using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class DeskManagementStatusDataTableLisRepository : ViewTcmPLRepository<DeskManagementStatusDataTableList>, IDeskManagementStatusDataTableLisRepository
    {
        public DeskManagementStatusDataTableLisRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<DeskManagementStatusDataTableList>> DeskManagementStatusDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_reports.fn_desk_management_status_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<DeskManagementStatusDataTableList>> DeskManagementStatusDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_reports.fn_desk_management_status_xls";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}