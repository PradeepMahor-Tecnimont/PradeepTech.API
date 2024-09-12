using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.DataAccess.Repositories
{
    public class NavratriRSVPDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, NavratriRSVPDetailOutput>, INavratriRSVPDetailRepository
    {

        public NavratriRSVPDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        #region Navratri RSVP Detail   

        public async Task<NavratriRSVPDetailOutput> NavratriRSVPDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_rsvp.sp_detail_navratri_rsvp";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }

        #endregion Navratri RSVP Detail  

    }
}
