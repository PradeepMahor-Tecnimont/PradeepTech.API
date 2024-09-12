using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class InvLaptopLotwiseDataTableListExcelRepository : ViewTcmPLRepository<InvLaptopLotwiseDataTableListExcel>, IInvLaptopLotwiseDataTableListExcelRepository
    {
        public InvLaptopLotwiseDataTableListExcelRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<InvLaptopLotwiseDataTableListExcel>> LaptopLotwiseAllDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_asset_distribution_qry.fn_xl_lotwise_all";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<InvLaptopLotwiseDataTableListExcel>> LaptopLotwiseIssuedDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_asset_distribution_qry.fn_xl_lotwise_issued";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<InvLaptopLotwiseDataTableListExcel>> LaptopLotwisePendingDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_asset_distribution_qry.fn_xl_lotwise_pending";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

    }
}