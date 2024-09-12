using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.Hosting;
using MoreLinq;
using System;
using System.DirectoryServices;
using System.DirectoryServices.AccountManagement;
using System.Linq;
using System.Net;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.WebApp.Middleware
{
    public class UserIdentityMiddleware
    {
        private readonly static string _tecnimont = "tecnimont";
        private readonly RequestDelegate _next;
        private static readonly string[] SkipMetaIds = { "-4E66BA1ED95ED6541B8", "-4E4D98651F9E0E1A8E7", "-42E18833E5B567B3BFB", "-499A8E26377BC3ECECE", "-41F9A1D98FBE637DE18", "-4A0BBFFFCE942B691C7" };
        public UserIdentityMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(
                HttpContext context,
                IUserProfileRepository userProfileRepository,
                UserIdentity userIdentity,
                IUserRolesActionsRepository userRolesActionsRepository,
                BaseSpTcmPL baseSpTcmPL,
                IWebHostEnvironment env,
                IUserIdentityRolesActionsRepository userIdentityRolesActionsRepository
            )
        {
            context.Items["isMobile"] = false;

            if (!context.User.Identity.Name.ToLower().StartsWith(_tecnimont))
            {
#pragma warning disable CA1416 // Validate platform compatibility
                using (var principalContext = new PrincipalContext(ContextType.Domain))
                {
                    var principal = UserPrincipal.FindByIdentity(principalContext, context.User.Identity.Name);


                    var extensionAttribute13 = ((DirectoryEntry)principal.GetUnderlyingObject())
                                                .Properties["extensionAttribute13"]?.Value as string;

                    userIdentity.EmployeeId = extensionAttribute13;

                    var extensionAttribute2 = ((DirectoryEntry)principal.GetUnderlyingObject())
                                                .Properties["extensionAttribute2"]?.Value as string;

                    userIdentity.MetaId = extensionAttribute2;

                }
#pragma warning restore CA1416 // Validate platform compatibility
            }
            //context.Items["UserIdentity"] = await Helper.GetUserIdentityAsync(context, userProfileRepository);


            userIdentity.CurrentModule = context.GetRouteData()?.Values["area"]?.ToString().ToUpper() ?? Domain.Models.ConstantsHelper.ModuleSWPVaccine;
            //if (env.IsProduction())
            //{


            //    AppModuleUserDetailsModel appModuleUserDetailsModel = new AppModuleUserDetailsModel
            //    {
            //        PWinUid = context.User.Identity.Name
            //    };

            //    appModuleUserDetailsModel = await userProfileRepository.UserDetailsAsync(appModuleUserDetailsModel);

            //    if (appModuleUserDetailsModel.OutPSuccess.ToUpper() == "OK")
            //    {
            //        userIdentity.CostCode = appModuleUserDetailsModel.OutPCostcode;
            //        userIdentity.EmpNo = appModuleUserDetailsModel.OutPEmpno;
            //        userIdentity.Name = appModuleUserDetailsModel.OutPEmpName;

            //        if (context.User.Identity.Name.ToLower().StartsWith("tecnimont") || string.IsNullOrEmpty(appModuleUserDetailsModel.OutPMetaId) == false)
            //        {
            //            userIdentity.MetaId = appModuleUserDetailsModel.OutPMetaId;
            //            userIdentity.EmployeeId = appModuleUserDetailsModel.OutPPersonId;
            //        }
            //        var moduleAccess = await userProfileRepository.UserModuleAccessAsync(new AppModuleUserAccessModel { PWinUid = context.User.Identity.Name });
            //        if (moduleAccess.OutPSuccess == "OK" && string.IsNullOrEmpty(moduleAccess.OutPModulesCsv) == false)
            //        {
            //            userIdentity.Modules = moduleAccess.OutPModulesCsv.Split(",");
            //        }

            //        //var profileRoleActions = await userProfileRepository.UserProfileActionsAsync(userIdentity.CurrentModule, userIdentity.EmpNo);

            //        baseSpTcmPL.PMetaId = userIdentity.MetaId;
            //        baseSpTcmPL.PPersonId = userIdentity.EmployeeId;


            //        var profileRolesActions = await userRolesActionsRepository.GetUserRolesActionsAsync(baseSpTcmPL, new ParameterSpTcmPL
            //        {
            //            PModuleName = userIdentity.CurrentModule
            //        });

            //        userIdentity.ProfileActions = Enumerable.Empty<ProfileAction>();

            //        userIdentity.ProfileActions = profileRolesActions;

            //    }
            //}
            //else
            //{
            var userIdentityRolesAction = await userIdentityRolesActionsRepository.GetUserIdentityRolesActionsAsync(
                new BaseSpTcmPL { PMetaId = userIdentity.MetaId },
                 new ParameterSpTcmPL
                 {
                     PWinUid = context.User.Identity.Name,
                     PModuleName = userIdentity.CurrentModule
                 }
                );
            if (userIdentityRolesAction.PMessageType == "OK")
            {
                userIdentity.EmpNo = userIdentityRolesAction.PEmpno;
                userIdentity.ProfileActions = userIdentityRolesAction.PProfileActions ?? Enumerable.Empty<ProfileAction>();
                userIdentity.Modules = userIdentityRolesAction.PModulesCsv.Split(",");

                userIdentity.CostCode = userIdentityRolesAction.PCostcode;

                if (context.User.Identity.Name.ToLower().StartsWith(_tecnimont))
                {
                    userIdentity.MetaId = userIdentityRolesAction.PTcmMetaId;
                    userIdentity.EmployeeId = userIdentityRolesAction.PTcmPersonId;
                }
                context.Items["UserIdentity"] = userIdentity;
                await _next.Invoke(context);
            }
            else
            {
                await ReturnErrorResponse(context);
            }
            
        }

        private async Task ReturnErrorResponse(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            context.Response.StatusCode = (int)HttpStatusCode.Forbidden;
            await context.Response.WriteAsync("Employee validation has failed. Access is denied.");
            await context.Response.StartAsync();
           
        }
    }
}
