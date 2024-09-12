using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.BG;

namespace TCMPLApp.DataAccess.Repositories.BG
{
    public class BGVendorMasterDataTableListRepository : ViewTcmPLRepository<BGVendorMasterDataTableList>, IBGVendorMasterDataTableListRepository
    {
        public BGVendorMasterDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<BGVendorMasterDataTableList>> BGVendorMasterDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.pkg_bg_vendor_mast_qry.fn_vendor_mast";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}