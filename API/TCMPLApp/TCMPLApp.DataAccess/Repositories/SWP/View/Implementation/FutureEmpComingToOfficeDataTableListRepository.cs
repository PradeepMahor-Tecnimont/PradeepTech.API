using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class FutureEmpComingToOfficeDataTableListRepository : ViewTcmPLRepository<FutureEmpComingToOfficeDataTableList>, IFutureEmpComingToOfficeDataTableListRepository
    {
        public FutureEmpComingToOfficeDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<FutureEmpComingToOfficeDataTableList>> FutureEmpComingToOfficeDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_emp_to_office_qry.fn_emp_coming_to_office_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}