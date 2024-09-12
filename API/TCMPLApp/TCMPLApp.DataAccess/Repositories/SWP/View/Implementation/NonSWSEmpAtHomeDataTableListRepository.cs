using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class NonSWSEmpAtHomeDataTableListRepository : ViewTcmPLRepository<NonSWSEmpAtHomeDataTableList>, INonSWSEmpAtHomeDataTableListRepository
    {
        public NonSWSEmpAtHomeDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<NonSWSEmpAtHomeDataTableList>> NonSWSEmpAtHome4HodSecDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.IOT_SWP_DMS_REP_QRY.fn_non_sws_emp_athome_4hodsec";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<NonSWSEmpAtHomeDataTableList>> NonSWSEmpAtHome4AdminDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.IOT_SWP_DMS_REP_QRY.fn_non_sws_emp_athome_4admin";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}