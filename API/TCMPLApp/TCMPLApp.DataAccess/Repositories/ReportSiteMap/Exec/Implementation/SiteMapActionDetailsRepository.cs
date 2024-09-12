using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.RapReporting;
using TCMPLApp.Domain.Models.ReportSiteMap;

namespace TCMPLApp.DataAccess.Repositories.ReportSiteMap
{
    public class SiteMapActionDetailsRepository : ExecTcmPLRepository<ParameterSpTcmPL, SiteMapActionDetails>, ISiteMapActionDetailsRepository
    {
        public SiteMapActionDetailsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<SiteMapActionDetails> ActionDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_site_map.sp_get_action_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;
        }
    }
}