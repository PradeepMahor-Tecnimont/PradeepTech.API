using Microsoft.Extensions.Logging;
using System.Data;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class EmployeeAssetStatusDataTableListRepository : ViewTcmPLRepository<DataTable>, IEmployeeAssetStatusDataTableListRepository
    {
        public EmployeeAssetStatusDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DataTable> EmployeeAssetsDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_asset_distribution_qry.fn_xl_employee_assets";
            return await GetDataTableAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}