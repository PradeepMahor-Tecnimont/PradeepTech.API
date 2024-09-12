using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.OffBoarding;

namespace TCMPLApp.DataAccess.Repositories.OffBoarding
{
    public interface IOffBoardingUserManagementRepository
    {
        public Task<IEnumerable<OffBoardingUserRolesActions>> GetUserRolesActions();

        public Task<IEnumerable<DdlModel>> GetRolesActionsSelectAsync();

        public Task<OffBoardingAddUserAccess> AddUserRolesActions(OffBoardingAddUserAccess offBoardingAddUserAccess);

        public Task<OffBoardingRemoveUserRoleAction> RemoveUserRolesActions(OffBoardingRemoveUserRoleAction offBoardingRemoveUserRoleAction);

    }
}
