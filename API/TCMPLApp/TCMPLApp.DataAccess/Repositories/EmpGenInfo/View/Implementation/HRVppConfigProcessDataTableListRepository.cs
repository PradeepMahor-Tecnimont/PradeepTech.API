using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class HRVppConfigProcessDataTableListRepository : ViewTcmPLRepository<HRVppConfigProcessDataTableList>, IHRVppConfigProcessDataTableListRepository
    {
        public HRVppConfigProcessDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<HRVppConfigProcessDataTableList>> HRVppConfigProcessDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_vpp_config_qry.fn_vpp_config_list ";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
