using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.DataAccess.Repositories.Common
{


    public interface IUserProfileRepository 
    {
        public Task<AppModuleUserAccessModel> UserModuleAccessAsync(AppModuleUserAccessModel appModuleUserAccessModel);

        public AppModuleUserAccessModel UserModuleAccess(AppModuleUserAccessModel appModuleUserAccessModel);

        public Task<AppModuleUserDetailsModel> UserDetailsAsync(AppModuleUserDetailsModel appModuleUserAccessModel);

        public AppModuleUserDetailsModel UserDetails(AppModuleUserDetailsModel appModuleUserAccessModel);


        public Task<IEnumerable<ProfileAction>> UserProfileActionsAsync(string module, string empno);

        public IEnumerable<ProfileAction> UserProfileActions(string module, string empno);

    }
}
