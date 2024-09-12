using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class DeskManagementWorkloadDataTableLisRepository : ViewTcmPLRepository<DeskManagementWorkloadDataTableList>, IDeskManagementWorkloadDataTableLisRepository
    {
        public DeskManagementWorkloadDataTableLisRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<DeskManagementWorkloadDataTableList>> DeskManagementWorkloadDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_reports.fn_desk_management_wl_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<DeskManagementWorkloadDataTableList>> DeskManagementWorkloadDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_reports.fn_desk_management_wl_xls";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}