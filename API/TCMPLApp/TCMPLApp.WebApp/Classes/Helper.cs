using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.Domain.Models;
//using TCMPLApp.WebApp.Lib.Models;

namespace TCMPLApp.WebApp.Classes
{
    public static class Helper
    {
        public const string PolicyNamePrefixRole = "AuthorizeRole";
        public const string PolicyNamePrefixAction = "AuthorizeAction";


        public static async Task<UserIdentity> GetUserIdentityAsync(HttpContext context, IUserProfileRepository userProfileRepository)
        {
            var area = context.GetRouteData()?.Values["area"]?.ToString();

            UserIdentity userIdentity = null;

            if (context.Items["UserIdentity"] != null)
            {
                return await Task.FromResult((UserIdentity)context.Items["UserIdentity"]);
            }


            AppModuleUserDetailsModel appModuleUserDetailsModel = new AppModuleUserDetailsModel
            {
                PWinUid = context.User.Identity.Name
            };

            appModuleUserDetailsModel = await userProfileRepository.UserDetailsAsync(appModuleUserDetailsModel);

            if (appModuleUserDetailsModel.OutPSuccess.ToUpper() == "OK")
            {
                userIdentity = new UserIdentity
                {
                    CostCode = appModuleUserDetailsModel.OutPCostcode,
                    EmpNo = appModuleUserDetailsModel.OutPEmpno,
                    Name = appModuleUserDetailsModel.OutPEmpName
                };

                var moduleAccess = await userProfileRepository.UserModuleAccessAsync(new AppModuleUserAccessModel { PWinUid = context.User.Identity.Name });
                if (moduleAccess.OutPSuccess == "OK" && string.IsNullOrEmpty(moduleAccess.OutPModulesCsv) == false)
                {
                    userIdentity.Modules = moduleAccess.OutPModulesCsv.Split(",");
                }
                userIdentity.CurrentModule = area;
                var profileRoleActions = await userProfileRepository.UserProfileActionsAsync(userIdentity.CurrentModule, userIdentity.EmpNo);

                userIdentity.ProfileActions = Enumerable.Empty<ProfileAction>();

                userIdentity.ProfileActions = profileRoleActions;
            }
            return userIdentity;
        }

        public static UserIdentity GetUserIdentity(HttpContext context)
        {
            var area = context.GetRouteData()?.Values["area"]?.ToString();

            UserIdentity userIdentity = null;

            if (context.Items["UserIdentity"] != null)
            {
                userIdentity = (UserIdentity)context.Items["UserIdentity"];
            }


            //AppModuleUserDetailsModel appModuleUserDetailsModel = new AppModuleUserDetailsModel
            //{
            //    PWinUid = context.User.Identity.Name
            //};

            //appModuleUserDetailsModel = userProfileRepository.UserDetails(appModuleUserDetailsModel);

            //if (appModuleUserDetailsModel.OutPSuccess.ToUpper() == "OK")
            //{
            //    userIdentity = new UserIdentity
            //    {
            //        CostCode = appModuleUserDetailsModel.OutPCostcode,
            //        EmpNo = appModuleUserDetailsModel.OutPEmpno,
            //        Name = appModuleUserDetailsModel.OutPEmpName
            //    };

            //    var moduleAccess = userProfileRepository.UserModuleAccess(new AppModuleUserAccessModel { PWinUid = context.User.Identity.Name });
            //    if (moduleAccess.OutPSuccess == "OK" && string.IsNullOrEmpty(moduleAccess.OutPModulesCsv) == false)
            //    {
            //        userIdentity.Modules = moduleAccess.OutPModulesCsv.Split(",");
            //    }
            //    userIdentity.CurrentModule = area ?? "SWP";
            //    var profileRoleActions = userProfileRepository.UserProfileActions(userIdentity.CurrentModule, userIdentity.EmpNo);

            //    userIdentity.ProfileActions = Enumerable.Empty<ProfileAction>();

            //    userIdentity.ProfileActions = profileRoleActions;
            //}
            return userIdentity;
        }

    }
}
