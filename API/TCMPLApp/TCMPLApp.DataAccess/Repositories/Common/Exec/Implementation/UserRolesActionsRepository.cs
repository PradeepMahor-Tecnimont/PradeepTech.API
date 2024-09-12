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
    public class UserRolesActionsRepository : ViewTcmPLRepository<ProfileAction>, IUserRolesActionsRepository
    {
        public UserRolesActionsRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<ProfileAction>> GetUserRolesActionsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "app_users.get_emp_roles_actions";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }


    }







}
