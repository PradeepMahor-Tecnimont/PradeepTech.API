using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.OffBoarding;

namespace TCMPLApp.DataAccess.Repositories.OffBoarding
{
    public class OffBoardingUserManagementRepository : Base.ExecRepository, IOffBoardingUserManagementRepository
    {

        public OffBoardingUserManagementRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {

        }

        public async Task<IEnumerable<OffBoardingUserRolesActions>> GetUserRolesActions()
        {
            return await QueryAsync<OffBoardingUserRolesActions>(OffBoardingQueries.GetUserRolesActions);
        }

        public async Task<OffBoardingAddUserAccess> AddUserRolesActions(OffBoardingAddUserAccess offBoardingAddUserAccess)
        {
            return await ExecuteProcAsync<OffBoardingAddUserAccess>(offBoardingAddUserAccess);
        }


        public async Task<IEnumerable<DdlModel>> GetRolesActionsSelectAsync()
        {
            return await QueryAsync<DdlModel>(OffBoardingQueries.GetRolesActions);
        }

        public async Task<OffBoardingRemoveUserRoleAction> RemoveUserRolesActions(OffBoardingRemoveUserRoleAction offBoardingRemoveUserRoleAction)
        {
            return await ExecuteProcAsync(offBoardingRemoveUserRoleAction);
        }


    }
}
