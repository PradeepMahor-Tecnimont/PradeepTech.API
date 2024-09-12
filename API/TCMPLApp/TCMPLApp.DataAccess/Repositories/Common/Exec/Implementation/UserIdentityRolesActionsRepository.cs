using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.Attendance;



namespace TCMPLApp.DataAccess.Repositories.Common
{
    public class UserIdentityRolesActionsRepository : ExecTcmPLRepository<ParameterSpTcmPL, UserIdentityProfile>, IUserIdentityRolesActionsRepository
    {
        public UserIdentityRolesActionsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<UserIdentityProfile> GetUserIdentityRolesActionsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "app_users.get_emp_details_from_metaid";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;
        }

    }

}
