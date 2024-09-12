using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.Razor;
using Microsoft.AspNetCore.Mvc.Razor.Internal;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.DependencyInjection;
//using TCMPLApp.WebApp.Lib.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.WebApp.Classes
{
    public abstract class BasePage<TModel> : RazorPage<TModel>
    {
        private IConfiguration _configuration;

        protected UserIdentity CurrentUserIdentity => GetUserIdentityAsync().Result;
        protected IConfiguration Configuration => _configuration ??= Context.RequestServices.GetService<IConfiguration>();

        protected IUserProfileRepository UserProfileRepository => Context.RequestServices.GetService<IUserProfileRepository>();

        protected const string IsOk = "OK";
        protected const string NotOk = "KO";

        protected BasePage()
        {
        }



        private async Task<UserIdentity> GetUserIdentityAsync()
        {
            
            return await Helper.GetUserIdentityAsync(Context, UserProfileRepository);

            //if (Context?.Items["UserIdentity"] != null)
            //{
            //    return await Task.FromResult((UserIdentity)Context.Items["UserIdentity"]);
            //}
            //else
            //{
            //    AppModuleUserDetailsModel appModuleUserDetailsModel = new AppModuleUserDetailsModel { PWinUid=Context.User.Identity.Name };
            //    var userDetails = await UserProfileRepository.UserDetailsAsync(appModuleUserDetailsModel);
            //    var oUserIdentity = new UserIdentity
            //    {
            //        WinUID = Context.User.Identity.Name,
            //        Name = userDetails.OutPEmpName,
            //        CostCode = userDetails.OutPCostcode,
            //        EmpNo = userDetails.OutPEmpno
            //    };
            //    var moduleAccess = await UserProfileRepository.UserModuleAccessAsync(new AppModuleUserAccessModel { PWinUid = Context.User.Identity.Name });
            //    if (moduleAccess.OutPSuccess == "OK" && string.IsNullOrEmpty(moduleAccess.OutPModulesCsv) == false)
            //    {
            //        oUserIdentity.Modules = moduleAccess.OutPModulesCsv.Split(",");
            //    }
            //    return oUserIdentity;
            //}

        }
    }
}