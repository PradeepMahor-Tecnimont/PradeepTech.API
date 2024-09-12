using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DigiForm;

namespace TCMPLApp.DataAccess.Repositories.DigiForm
{
    public class SiteMasterDataTableListRepository : ViewTcmPLRepository<SiteMasterDataTableList>, ISiteMasterDataTableListRepository
    {
        public SiteMasterDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<SiteMasterDataTableList>> SiteMasterDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_site_master_qry.fn_dg_site_master_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<SiteMasterDataTableList>> SiteMasterDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_site_master_qry.fn_dg_site_master_xl_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
