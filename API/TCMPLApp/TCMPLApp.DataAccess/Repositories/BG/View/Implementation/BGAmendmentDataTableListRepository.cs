using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.BG;

namespace TCMPLApp.DataAccess.Repositories.BG
{
    public class BGAmendmentDataTableListRepository : ViewTcmPLRepository<BGAmendmentDataTableList>, IBGAmendmentDataTableListRepository
    {
        public BGAmendmentDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<BGAmendmentDataTableList>>BGAmendmentDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.pkg_bg_main_amendment_qry.fn_bg_amendment_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}