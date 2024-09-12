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
    public class LaptopLotWiseDataTableListRepository : ViewTcmPLRepository<LaptopLotWiseDataTableList>, ILaptopLotWiseDataTableListRepository
    {
        public LaptopLotWiseDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<LaptopLotWiseDataTableList>> LaptopLotWisePendingDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_laptop_lotwise_qry.fn_lotwise_pending";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<LaptopLotWiseDataTableList>> LaptopLotWiseIssuedDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_laptop_lotwise_qry.fn_lotwise_issued";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<LaptopLotWiseDataTableList>> LaptopLotWiseAllDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_laptop_lotwise_qry.fn_lotwise_all";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
